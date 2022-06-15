import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:temp_app/core/network/dio_utils/dio_factory.dart';
import 'package:temp_app/data/auth/auth_holder.dart';

import '../core/network/exceptions.dart';
import '../domain/session/clear_session_usecase.dart';

enum NetworkRequestType { GET, POST, PUT, PATCH, DELETE }

class NetworkRequest {
  const NetworkRequest({
    required this.type,
    required this.path,
    this.data,
    this.queryParams,
    this.headers,
  });

  final NetworkRequestType type;
  final String path;
  final dynamic data;
  final Map<String, dynamic>? queryParams;
  final Map<String, String>? headers;
}

class IsolateResponse<T> {
  final bool isSuccess;
  final T? result;
  final Exception? error;

  IsolateResponse({
    required this.isSuccess,
    this.result,
    this.error,
  });

  @override
  String toString() {
    return 'IsolateResponse{isSuccess: $isSuccess, result: $result, error: $error}';
  }
}

class _PreparedNetworkRequest<Model> {
  const _PreparedNetworkRequest(
      this.request,
      this.parser,
      this.dio,
      this.headers,
      );

  final NetworkRequest request;
  final Model Function(Map<String, dynamic>)? parser;
  final Dio dio;
  final Map<String, dynamic> headers;
}

Future<IsolateResponse<Model>> executeRequest<Model>(
    _PreparedNetworkRequest request,
    ) async {
  try {
    var response = await _dioCall(request);
    return IsolateResponse(
      isSuccess: true,
      result: request.parser == null ? response : request.parser!(response),
    );
  } on DioError catch (error) {
    return IsolateResponse(
      isSuccess: false,
      error: error.error,
    );
  } catch (e) {
    return IsolateResponse(
      isSuccess: false,
    );
  }
}

Future<dynamic> _dioCall(_PreparedNetworkRequest request) async {
  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  const _extra = <String, dynamic>{};
  final queryParameters = request.request.queryParams;
  final _headers = request.headers;
  final _data = request.request.data;
  final _result = await request.dio.fetch(
    _setStreamType<dynamic>(
      Options(
        method: request.request.type.name,
        headers: _headers,
        extra: _extra,
      )
          .compose(
        request.dio.options,
        request.request.path,
        queryParameters: queryParameters,
        data: _data,
        options: Options(
          method: request.request.type.name,
          headers: request.headers,
        ),
      )
          .copyWith(baseUrl: request.dio.options.baseUrl),
    ),
  );
  final value = _result.data;
  return value;
}

class NetworkService {
  NetworkService({
    this.authHolder,
    this.clearSessionUseCase,
    this.dio,
    httpHeaders,
  }) : this._headers = httpHeaders ?? {};
  Dio? dio;
  final AuthHolder? authHolder;
  final ClearSessionUseCase? clearSessionUseCase;
  Map<String, String> _headers;

  void addBasicAuth(String accessToken) {
    _headers['Authorization'] = 'Bearer $accessToken';
  }

  Future<IsolateResponse<Model>> execute<Model>(
      NetworkRequest request, {
        Model Function(Map<String, dynamic>)? parser,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    if (dio == null) {
      dio = DioFactory.buildClientByState(
        authHolder: authHolder!,
        clearSessionUseCase: clearSessionUseCase!,
      );
    }
    final req = _PreparedNetworkRequest<Model>(
      request,
      parser,
      dio!,
      {..._headers, ...(request.headers ?? {}), ...dio!.options.headers},
    );
    final result = await compute(
      executeRequest<Model>,
      req,
    );
    return result;
  }

  Future<IsolateResponse<Model>> executeWithCancel<Model>(
      NetworkRequest request, {
        Model Function(Map<String, dynamic>)? parser,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        CancelToken? cancelToken,
      }) async {
    if (dio == null) {
      dio = DioFactory.buildClientByState(
        authHolder: authHolder!,
        clearSessionUseCase: clearSessionUseCase!,
      );
    }
    final networkRequest = _PreparedNetworkRequest<Model>(
      request,
      parser,
      dio!,
      {..._headers, ...(request.headers ?? {}), ...dio!.options.headers},
    );
    Completer<IsolateResponse<Model>> completeResult =
    Completer<IsolateResponse<Model>>();

    ReceivePort receivePort = ReceivePort();
    SendPort? sendPort;

    var isolate = await Isolate.spawn<IsolateConfiguration>(
      executeRequestWithCancel<Model>,
      IsolateConfiguration<_PreparedNetworkRequest<Model>,
          IsolateResponse<Model>>(
        executeRequest<Model>,
        networkRequest,
        receivePort.sendPort,
      ),
    );

    receivePort.listen((result) {
      if (result is SendPort) {
        sendPort = result;
      } else {
        if (!completeResult.isCompleted) {
          completeResult.complete(result as IsolateResponse<Model>);
        }
      }
    });

    cancelToken?.whenCancel.then((value) {
      sendPort?.send("cancel");
    });

    await completeResult.future;

    receivePort.close();
    isolate.kill(priority: Isolate.immediate);

    return completeResult.future;
  }

  Future<IsolateResponse<R>> executeRequestWithCancel<R>(
      IsolateConfiguration list) async {
    ReceivePort rp = ReceivePort();

    list.resultPort.send(rp.sendPort);

    rp.listen((message) {
      if (message == "cancel") {
        Isolate.exit(
          list.resultPort,
          IsolateResponse<R>(
            isSuccess: false,
            error: RequestCancelledException(),
          ),
        );
      }
    });

    final FutureOr<IsolateResponse<R>> result = await list.apply();

    Isolate.exit(list.resultPort, result);
  }
}

typedef ComputeCallback<Q, R> = FutureOr<R> Function(Q message);

@immutable
class IsolateConfiguration<Q, R> {
  const IsolateConfiguration(
      this.callback,
      this.message,
      this.resultPort,
      );

  final ComputeCallback<Q, R> callback;
  final Q message;
  final SendPort resultPort;

  FutureOr<R> apply() => callback(message);
}
