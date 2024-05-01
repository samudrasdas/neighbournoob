import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> storeToken(String token, String tokenType) async {
    await _storage.write(key: 'jwt_token', value: token);
    await _storage.write(key: 'token_type', value: tokenType);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<String?> getTokenType() async {
    return await _storage.read(key: 'token_type');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }
}