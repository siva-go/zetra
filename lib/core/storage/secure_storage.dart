import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zetra/core/constants/app_constants.dart';

class SecureStorage {

  SecureStorage({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage(
    aOptions: AndroidOptions(
        encryptedSharedPreferences: true
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock
    )
  );

  final FlutterSecureStorage _storage;

  Future<void> saveAccessToken(String token) => _storage.write(
      key: AppConstants.tokenKey,
      value: token
  );

  Future<String?> getAccessToken() => _storage.read(
      key: AppConstants.tokenKey
  );

  Future<void> saveRefreshToken(String token) => _storage.write(
      key: AppConstants.refreshTokenKey,
      value: token
  );

  Future<String?> getRefreshToken() => _storage.read(
      key: AppConstants.refreshTokenKey
  );

  /// Clears all persisted tokens — call on logout or session expiry.
  Future<void> clearTokens() async {

    await _storage.delete(
        key: AppConstants.tokenKey
    );
    await _storage.delete(
        key: AppConstants.refreshTokenKey
    );

  }

  /// Returns `true` if an access token is currently stored.
  Future<bool> hasAccessToken() async {

    final String? token = await getAccessToken();
    return token != null && token.isNotEmpty;

  }

}