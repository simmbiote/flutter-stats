import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../api/receiving_api.dart';

class SecureInstallationCredentialProvider
    implements InstallationCredentialProvider {
  SecureInstallationCredentialProvider({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'installation_credential_v1';
  final FlutterSecureStorage _storage;

  @override
  Future<String?> readCredential() async {
    final value = await _storage.read(key: _key);
    if (value == null || value.trim().isEmpty) return null;
    return value;
  }

  @override
  Future<void> writeCredential(String credential) async {
    if (credential.trim().isEmpty) {
      throw const FormatException('Credential cannot be empty.');
    }
    await _storage.write(key: _key, value: credential);
  }

  @override
  Future<void> clear() => _storage.delete(key: _key);
}

class InMemoryCredentialProvider implements InstallationCredentialProvider {
  InMemoryCredentialProvider([this.credential]);

  String? credential;

  @override
  Future<String?> readCredential() async => credential;

  @override
  Future<void> writeCredential(String value) async => credential = value;

  @override
  Future<void> clear() async => credential = null;
}
