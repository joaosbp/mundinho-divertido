import 'dart:developer' as developer;
import 'package:flame_audio/flame_audio.dart';

/// Serviço de áudio — música e SFX.
///
/// Stub inicial. Será expandido conforme assets forem adicionados.
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  bool _initialized = false;
  bool _soundOn = true;
  bool _musicOn = true;

  bool get soundOn => _soundOn;
  bool get musicOn => _musicOn;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await FlameAudio.audioCache.loadAll([
        // 'sfx/tap.mp3',
        // 'sfx/success.mp3',
        // 'music/ambient.mp3',
      ]);
      _initialized = true;
    } catch (e) {
      developer.log('Audio init error: $e');
    }
  }

  void setSoundEnabled(bool enabled) => _soundOn = enabled;
  void setMusicEnabled(bool enabled) {
    _musicOn = enabled;
    if (!_musicOn) {
      stopMusic();
    }
  }

  void playSfx(String name) {
    if (!_soundOn || !_initialized) return;
    try {
      FlameAudio.play(name);
    } catch (e) {
      developer.log('SFX error: $e');
    }
  }

  void playMusic(String name, {bool loop = true}) {
    if (!_musicOn || !_initialized) return;
    try {
      FlameAudio.bgm.play(name);
    } catch (e) {
      developer.log('Music error: $e');
    }
  }

  void stopMusic() {
    try {
      FlameAudio.bgm.stop();
    } catch (e) {
      developer.log('Stop music error: $e');
    }
  }

  void stopAll() {
    stopMusic();
  }
}
