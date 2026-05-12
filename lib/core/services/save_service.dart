import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/player_data.dart';
import '../../models/settings_data.dart';

/// Serviço de persistência local.
///
/// Estratégia offline-first:
/// - Hive: save principal do jogador (binário, rápido)
/// - SharedPreferences: configurações simples (flags, strings)
class SaveService {
  static final SaveService _instance = SaveService._internal();
  factory SaveService() => _instance;
  SaveService._internal();

  Box<PlayerData>? _playerBox;
  Box<SettingsData>? _settingsBox;
  SharedPreferences? _prefs;

  bool _initialized = false;
  bool get isInitialized => _initialized;

  /// Inicializa Hive e SharedPreferences.
  Future<void> initialize() async {
    if (_initialized) return;

    await Hive.initFlutter();

    // Registra adapters
    if (!Hive.isAdapterRegistered(PlayerDataAdapter().typeId)) {
      Hive.registerAdapter(PlayerDataAdapter());
    }
    if (!Hive.isAdapterRegistered(SettingsDataAdapter().typeId)) {
      Hive.registerAdapter(SettingsDataAdapter());
    }

    _playerBox = await Hive.openBox<PlayerData>('playerData');
    _settingsBox = await Hive.openBox<SettingsData>('settingsData');
    _prefs = await SharedPreferences.getInstance();

    _initialized = true;
  }

  // ─── Player Data ───

  PlayerData get playerData {
    return _playerBox?.get('current') ?? PlayerData.defaultData();
  }

  Future<void> savePlayerData(PlayerData data) async {
    await _playerBox?.put('current', data);
  }

  // ─── Settings ───

  SettingsData get settingsData {
    return _settingsBox?.get('current') ?? SettingsData.defaultData();
  }

  Future<void> saveSettings(SettingsData data) async {
    await _settingsBox?.put('current', data);
  }

  // ─── SharedPreferences helpers ───

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  String? getString(String key) => _prefs?.getString(key);

  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  int getInt(String key, {int defaultValue = 0}) {
    return _prefs?.getInt(key) ?? defaultValue;
  }

  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  // ─── Reset ───

  Future<void> resetAll() async {
    await _playerBox?.clear();
    await _settingsBox?.clear();
    await _prefs?.clear();
  }
}
