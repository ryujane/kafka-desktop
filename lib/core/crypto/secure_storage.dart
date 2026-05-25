import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

/// AES-256 encryption for sensitive data stored locally.
///
/// Derives a key from the machine hostname (placeholder -- production
/// will use the system keychain).
class SecureStorage {
  static SecureStorage? _instance;
  late final Encrypter _encrypter;

  SecureStorage._(String masterKey) {
    final key = Key.fromUtf8(masterKey.padRight(32).substring(0, 32));
    _encrypter = Encrypter(AES(key));
  }

  /// Returns the singleton [SecureStorage] instance.
  static Future<SecureStorage> get instance async {
    if (_instance != null) return _instance!;
    final key = await _deriveKey();
    _instance = SecureStorage._(key);
    return _instance!;
  }

  static Future<String> _deriveKey() async {
    final machineId = Platform.localHostname;
    final bytes = utf8.encode(machineId);
    return sha256.convert(bytes).toString().substring(0, 32);
  }

  /// Encrypts [plaintext] and returns `iv:ciphertext` in base64.
  String encrypt(String plaintext) {
    final iv = IV.fromLength(16);
    final encrypted = _encrypter.encrypt(plaintext, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  /// Decrypts a value produced by [encrypt].
  String decrypt(String ciphertext) {
    final parts = ciphertext.split(':');
    final iv = IV.fromBase64(parts[0]);
    return _encrypter.decrypt64(parts[1], iv: iv);
  }
}
