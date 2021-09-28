import 'package:temp_app/core/dio/errors/dio_errors.dart';

abstract class BasicState {
  bool isLoading;
  bool isSuccessful;
  Exception error;

  BasicState copyWith({
    bool isSuccessful,
    bool isLoading,
    ApiErrorException error,
  });
}