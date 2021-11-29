
import 'package:temp_app/core/network/exceptions.dart';
import 'package:temp_app/data/token/service/token_service.dart';

import 'models/exeptions.dart';
import 'models/requests/refresh_request.dart';
import 'models/token.dart';

enum TokenEvent { ok, expired, updated }

typedef TokenEventCallback = Function(TokenEvent tokenEvent,
    {String? accessToken, String? refreshToken});

class TokenHolder {
  final TokenService _tokenService;

  TokenHolder(this._tokenService);

  Token? authToken;
  Token? refreshToken;

  TokenEventCallback? _eventCallback;

  void init(Token? authToken, Token? refreshToken, TokenEventCallback listener) {
    _eventCallback = listener;
    this.authToken = authToken;
    this.refreshToken = refreshToken;

    if (authToken == null || refreshToken == null || refreshToken.isExpired()) {
      _eventCallback?.call(TokenEvent.expired);
    } else {
      _eventCallback?.call(TokenEvent.ok);
    }
  }

  Future<String?> tryRefreshToken() async {
    if (refreshToken!.isNearExpiration()) {
      onAuthExpired();
      throw SessionExpiredException();
    }

    try {
      final response =
          await _tokenService.postRefresh(RefreshRequest(refreshToken!.value));
      _eventCallback?.call(
        TokenEvent.updated,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      return response.accessToken;
    } catch (error) {
      if (error is UnauthorizedClientApiException) {
        onAuthExpired();
        throw SessionExpiredException();
      } else {
        rethrow;
      }
    }
  }

  void onAuthExpired() {
    _eventCallback?.call(TokenEvent.expired);
  }
}
