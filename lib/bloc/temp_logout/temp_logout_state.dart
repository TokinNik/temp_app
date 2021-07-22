part of 'temp_logout_cubit.dart';

class BasicState {
  bool isLoading;
  bool isSuccessful;
}

class TempLogoutState implements BasicState {
  @override
  bool isSuccessful;
  @override
  bool isLoading;

  TempLogoutState({
    this.isSuccessful = false,
    this.isLoading = false,
  });

  TempLogoutState copyWith({
    bool isSuccessful,
    bool isLoading,
  }) {
    return new TempLogoutState(
      isSuccessful: isSuccessful ?? this.isSuccessful,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  String toString() {
    return 'TempLogoutState{isSuccessful: $isSuccessful, isLoading: $isLoading}';
  }
}