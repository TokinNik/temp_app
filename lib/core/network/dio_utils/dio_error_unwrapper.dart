import 'package:dio/dio.dart';

mixin DioErrorUnwrapper {
  Future<T> run<T>(Future<T> request) async {
    try {
      return await request;
    } on DioError catch (e) {
      throw _tryParse(e);
    }
  }

  Object _tryParse(DioError dioError) {
    final e = dioError.error;
    if (e == null) return dioError;
    return e;
  }
}
