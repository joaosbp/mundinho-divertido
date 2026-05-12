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
///
/// Auto-save: a cada 30s quando o jogo está rodando.
/// Save em eventos importantes: completar missão, ganhar recompensa,
/// sair de local, completar mini-jogo.
class SaveService {
  static final SaveService _instance = SaveService._internal();
  factory SaveService() => _instance;
  SaveService._internal();

  Box<PlayerData>? _playerBox;
  Box<SettingsData>? _settingsBox;
  SharedPreferences? _prefs;

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Timer? _autoSaveTimer;
  static const _autoSaveInterval = Duration(seconds: 30);

  /// Callback chamado após cada auto-save (ex: mostrar toast).
  void Function()? onAutoSave;

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
    final updated = data.copyWith(lastPlayed: DateTime.now());
    await _playerBox?.put('current', updated);
  }

  /// Carrega PlayerData do Hive. Retorna [defaultData] se não houver save.
  PlayerData loadPlayerData() {
    return _playerBox?.get('current') ?? PlayerData.defaultData();
  }

  // ─── Settings ───

  SettingsData get settingsData {
    return _settingsBox?.get('current') ?? SettingsData.defaultData();
  }

  Future<void> saveSettings(SettingsData data) async {
    await _settingsBox?.put('current', data);
  }

  /// Carrega SettingsData do Hive. Retorna [defaultData] se não houver save.
  SettingsData loadSettings() {
    return _settingsBox?.get('current') ?? SettingsData.defaultData();
  }

  // ─── Save / Delete checks ───

  /// Verifica se existe algum dado de save salvo.
  bool hasSaveData() {
    return _playerBox?.containsKey('current') ?? false;
  }

  /// Apaga todos os dados de save (player + settings + prefs).
  Future<void> deleteSave() async {
    await _playerBox?.delete('current');
    await _settingsBox?.delete('current');
    await _prefs?.clear();
    _stopAutoSave();
  }

  /// Reseta todas as caixas (limpa tudo).
  Future<void> resetAll() async {
    await _playerBox?.clear();
    await _settingsBox?.clear();
    await _prefs?.clear();
    _stopAutoSave();
  }

  // ─── Auto-save ───

  /// Inicia o timer de auto-save a cada 30s.
  /// [getCurrentData] deve retornar os dados atuais do jogador.
  void startAutoSave(PlayerData Function() getCurrentData) {
    _stopAutoSave();
    _autoSaveTimer = Timer.periodic(_autoSaveInterval, (_) async {
      final data = getCurrentData();
      await savePlayerData(data);
      onAutoSave?.call();
    });
  }

  /// Para o timer de auto-save.
  void stopAutoSave() => _stopAutoSave();

  void _stopAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = null;
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
}
