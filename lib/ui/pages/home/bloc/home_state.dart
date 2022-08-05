part of 'home_cubit.dart';

class HomeState implements BasicState {
  bool isSuccessful;
  bool isLoading;
  Exception? error;
  bool? someVar;

  @override
  List<Object?> get props => [
    isSuccessful,
    isLoading,
    error,
    someVar,
  ];

  HomeState({
    this.isSuccessful = false,
    this.isLoading = false,
    this.error,
    this.someVar,
  });

  HomeState copyWith({
    bool? isSuccessful,
    bool? isLoading,
    Exception? error,
    bool? someVar,
  }) {
    return new HomeState(
      isSuccessful: isSuccessful ?? this.isSuccessful,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      someVar: someVar,
    );
  }

  @override
  String toString() {
    return 'TempLogoutState{isSuccessful: $isSuccessful, isLoading: $isLoading, error: $error, someVar: $someVar}';
  }

  @override
  bool? get stringify => true;
}
