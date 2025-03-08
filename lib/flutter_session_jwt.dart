import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jaguar_jwt_lite/jaguar_jwt_lite.dart';

/// Flutter session management using JWT token.
///
/// Note: Make sure to save token using ```FlutterSessionJwt.saveToken("token here")``` before using other methods
class FlutterSessionJwt {
  static const _storage = FlutterSecureStorage();
  static const _keyJwtToken = 'jwtToken';

  final String token;
  final JwtClaim claims;

  /// Create new FlutterSessionJwt from Token String.
  FlutterSessionJwt(this.token) : claims = decodeToken(token);

  /// Create new FlutterSessionJwt from Token String.
  /// This allows passing a custom [JwtClaim].
  FlutterSessionJwt.withClaims(this.token, this.claims);

  /// valid is a simple check if the token is expired or "not before"
  bool valid() {
    try {
      claims.validate(currentTime: DateTime.now());
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Saves a JWT token with encryption.
  /// It accepts ```String``` and saves the token with advanced encyption.
  /// Keychain is used for iOS. AES encryption is used for Android.
  /// AES secret key is encrypted with RSA and RSA key is stored in KeyStore
  Future save() => _storage.write(key: _keyJwtToken, value: token);

  /// Retrieves the JWT token from storage.
  /// Returns token as ```String``` if token is saved in storage or ```null```, otherwise.
  ///
  ///```Note:```
  ///Make sure to save token using ```FlutterSessionJwt.saveToken("token here")``` method before using other methods
  static Future<String?> retrieveToken() => _storage.read(key: _keyJwtToken);

  /// Deletes the JWT token from storage.
  static Future<void> deleteToken() => _storage.delete(key: _keyJwtToken);
}
