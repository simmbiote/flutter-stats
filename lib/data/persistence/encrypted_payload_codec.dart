import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import '../../features/sync/domain/models.dart';
import 'secure_key_store.dart';

class EncryptedPayloadCodec {
  EncryptedPayloadCodec({required KeyStore keyStore, AesGcm? cipher})
    : _keyStore = keyStore,
      _cipher = cipher ?? AesGcm.with256bits();

  final KeyStore _keyStore;
  final AesGcm _cipher;

  Future<String> encode(PendingOperation operation) {
    return encryptText(operation.encode());
  }

  Future<PendingOperation> decode(String encoded) async {
    final clear = await decryptText(encoded);
    return PendingOperation.decode(clear);
  }

  Future<String> encryptText(String clearText) async {
    final key = await _keyStore.getOrCreateKey();
    final box = await _cipher.encrypt(utf8.encode(clearText), secretKey: key);
    return jsonEncode({
      'v': 1,
      'nonce': base64UrlEncode(box.nonce),
      'ciphertext': base64UrlEncode(box.cipherText),
      'mac': base64UrlEncode(box.mac.bytes),
    });
  }

  Future<String> decryptText(String encoded) async {
    final key = await _keyStore.getOrCreateKey();
    final json = jsonDecode(encoded) as Map<String, dynamic>;
    if (json['v'] != 1) {
      throw const FormatException('Unsupported encrypted payload version.');
    }
    final box = SecretBox(
      base64Url.decode(json['ciphertext'] as String),
      nonce: base64Url.decode(json['nonce'] as String),
      mac: Mac(base64Url.decode(json['mac'] as String)),
    );
    final clear = await _cipher.decrypt(box, secretKey: key);
    return utf8.decode(clear);
  }
}
