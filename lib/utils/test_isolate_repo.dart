import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:temp_app/core/network/dio_utils/dio_factory.dart';
import 'package:temp_app/data/auth/auth_holder.dart';

import '../core/network/exceptions.dart';
import '../domain/session/clear_session_usecase.dart';
import 'pair.dart';

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
    this.onSendProgress,
    this.onReceiveProgress,
  );

  final NetworkRequest request;
  final Model Function(Map<String, dynamic>)? parser;
  final Dio dio;
  final Map<String, dynamic> headers;
  final ProgressCallback? onSendProgress;
  final ProgressCallback? onReceiveProgress;

  _PreparedNetworkRequest copyWith({
    NetworkRequest? request,
    Model Function(Map<String, dynamic>)? parser,
    Dio? dio,
    Map<String, dynamic>? headers,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _PreparedNetworkRequest<Model>(
      request ?? this.request,
      parser ?? this.parser,
      dio ?? this.dio,
      headers ?? this.headers,
      onSendProgress ?? this.onSendProgress,
      onReceiveProgress ?? this.onReceiveProgress,
    );
  }
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
            onSendProgress: request.onSendProgress,
            onReceiveProgress: request.onReceiveProgress,
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
  })  : assert(
            (authHolder != null && clearSessionUseCase != null) || dio != null),
        this._headers = httpHeaders ?? {};
  Dio? dio;
  final AuthHolder? authHolder;
  final ClearSessionUseCase? clearSessionUseCase;
  Map<String, String> _headers;

  void addBasicAuth(String accessToken) {
    _headers['Authorization'] = 'Bearer $accessToken';
  }

  Dio get defaultDio {
    return DioFactory.buildClientByState(
      authHolder: authHolder!,
      clearSessionUseCase: clearSessionUseCase!,
    );
  }

  Future<IsolateResponse<Model>> execute<Model>(
    NetworkRequest request, {
    Model Function(Map<String, dynamic>)? parser,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (dio == null) {
      dio = defaultDio;
    }
    final req = _PreparedNetworkRequest<Model>(
      request,
      parser,
      dio!,
      {..._headers, ...(request.headers ?? {}), ...dio!.options.headers},
      onSendProgress,
      onReceiveProgress,
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
      dio = defaultDio;
    }
    final networkRequest = _PreparedNetworkRequest<Model>(
      request,
      parser,
      dio!,
      {..._headers, ...(request.headers ?? {}), ...dio!.options.headers},
      onSendProgress,
      onReceiveProgress,
    );
    Completer<IsolateResponse<Model>> completeResult =
        Completer<IsolateResponse<Model>>();

    ReceivePort receivePort = ReceivePort();
    SendPort? sendPort;

    var isolate = await Isolate.spawn<IsolateConfiguration>(
      executeRequestWithCancel<Model>,
      IsolateConfiguration<_PreparedNetworkRequest<Model>,
          IsolateResponse<Model>>(
        callback: executeRequest<Model>,
        message: networkRequest,
        resultPort: receivePort.sendPort,
      ),
    );

    receivePort.listen(
      (result) {
        if (result is SendPort) {
          sendPort = result;
        } else if (result is Triple<_IsolateMessage, int, int>) {
          if (result.first == _IsolateMessage.ON_SEND_PROGRESS &&
              onSendProgress != null) {
            onSendProgress.call(result.second, result.third);
          }
          if (result.first == _IsolateMessage.ON_RECEIVE_PROGRESS &&
              onReceiveProgress != null) {
            onReceiveProgress.call(result.second, result.third);
          }
        } else if (result is IsolateResponse<Model> &&
            !completeResult.isCompleted) {
          completeResult.complete(result);
        } else {
          //todo
        }
      },
    );

    cancelToken?.whenCancel.then((value) {
      sendPort?.send(_IsolateMessage.CANCEL);
    });

    await completeResult.future;

    receivePort.close();
    isolate.kill(priority: Isolate.immediate);

    return completeResult.future;
  }

  Future<IsolateResponse<R>> executeRequestWithCancel<R>(
      IsolateConfiguration message) async {
    ReceivePort rp = ReceivePort();
    IsolateConfiguration config = message;

    config.resultPort.send(rp.sendPort);

    rp.listen(
      (message) {
        if (message == _IsolateMessage.CANCEL) {
          Isolate.exit(
            config.resultPort,
            IsolateResponse<R>(
              isSuccess: false,
              error: RequestCancelledException(),
            ),
          );
        }
      },
    );

    if (config.message is _PreparedNetworkRequest) {
      config = config.copyWith(
        message: (config.message as _PreparedNetworkRequest).copyWith(
          onReceiveProgress:
              (config.message as _PreparedNetworkRequest).onReceiveProgress ==
                      null
                  ? null
                  : (c, t) {
                      config.resultPort.send(
                        Triple(
                          _IsolateMessage.ON_RECEIVE_PROGRESS,
                          c,
                          t,
                        ),
                      );
                    },
          onSendProgress:
              (config.message as _PreparedNetworkRequest).onSendProgress == null
                  ? null
                  : (c, t) {
                      config.resultPort.send(
                        Triple(
                          _IsolateMessage.ON_SEND_PROGRESS,
                          c,
                          t,
                        ),
                      );
                    },
        ),
      );
    }

    final FutureOr<IsolateResponse<R>> result = await config.apply();

    Isolate.exit(config.resultPort, result);
  }
}

enum _IsolateMessage {
  CANCEL,
  ON_RECEIVE_PROGRESS,
  ON_SEND_PROGRESS,
}

typedef ComputeCallback<Q, R> = FutureOr<R> Function(Q message);

@immutable
class IsolateConfiguration<Q, R> {
  const IsolateConfiguration({
    required this.callback,
    required this.message,
    required this.resultPort,
  });

  final ComputeCallback<Q, R> callback;
  final Q message;
  final SendPort resultPort;

  FutureOr<R> apply() => callback(message);

  IsolateConfiguration copyWith({
    Q? message,
  }) {
    return IsolateConfiguration<Q, R>(
      callback: this.callback,
      message: message ?? this.message,
      resultPort: this.resultPort,
    );
  }
}
