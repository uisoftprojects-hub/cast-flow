import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/pairing.dart';

/// Android Keystore / iOS Keychain backed storage for pairing tokens and
/// client certificates.
class SecureCredentialStore implements CredentialStore {
  SecureCredentialStore([FlutterSecureStorage? storage]) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static String _key(String deviceId) => 'pairing.$deviceId';

  @override
  Future<String?> read(String deviceId) => _storage.read(key: _key(deviceId));

  @override
  Future<void> write(String deviceId, String credential) => _storage.write(key: _key(deviceId), value: credential);

  @override
  Future<void> delete(String deviceId) => _storage.delete(key: _key(deviceId));
}
