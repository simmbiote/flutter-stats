import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class KeyStore {
  Future<SecretKey> getOrCreateKey();
}

class SecureKeyStore implements KeyStore {
  SecureKeyStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _storageKey = 'health_pending_payload_key_v1';
  final FlutterSecureStorage _storage;

  @override
  Future<SecretKey> getOrCreateKey() async {
    final existing = await _storage.read(key: _storageKey);
    if (existing != null && existing.isNotEmpty) {
      return SecretKey(base64Url.decode(existing));
    }
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    await _storage.write(key: _storageKey, value: base64UrlEncode(bytes));
    return SecretKey(bytes);
  }
}

class InMemoryKeyStore implements KeyStore {
  InMemoryKeyStore([List<int>? bytes])
    : _bytes = bytes ?? List<int>.generate(32, (index) => index + 1);

  final List<int> _bytes;

  @override
  Future<SecretKey> getOrCreateKey() async => SecretKey(_bytes);
}
