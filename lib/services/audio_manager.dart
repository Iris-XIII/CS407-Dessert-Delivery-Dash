import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _musicPlayer = AudioPlayer();
  String? _currentTrack;
  bool _isInitialized = false;

  // Audio settings
  bool _backgroundMusicEnabled = true;
  double _musicVolume = 0.7;

  // Initialize the audio manager
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _loadSettings();
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setVolume(_musicVolume);

    _isInitialized = true;
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _backgroundMusicEnabled = prefs.getBool('backgroundMusic') ?? true;
    _musicVolume = prefs.getDouble('musicVolume') ?? 0.7;
  }

  // Play a music track
  Future<void> playMusic(String trackName) async {
    if (!_isInitialized) await initialize();

    // Store the current track name for later
    _currentTrack = trackName;

    // Don't restart if already playing this track
    if (_musicPlayer.state == PlayerState.playing) {
      // Check if it's the same track by comparing source
      final currentSource = _musicPlayer.source;
      if (currentSource is AssetSource && currentSource.path == 'audio/$trackName') {
        return;
      }
    }

    // Stop current music if playing
    if (_musicPlayer.state == PlayerState.playing) {
      await _musicPlayer.stop();
    }

    // Only play if background music is enabled
    if (_backgroundMusicEnabled) {
      await _musicPlayer.play(AssetSource('audio/$trackName'));
    }
  }

  // Stop music
  Future<void> stopMusic() async {
    await _musicPlayer.stop();
    // Keep _currentTrack so we can resume it later
  }

  // Pause music
  Future<void> pauseMusic() async {
    await _musicPlayer.pause();
  }

  // Resume music
  Future<void> resumeMusic() async {
    if (_backgroundMusicEnabled && _currentTrack != null) {
      // If music was paused, resume it
      if (_musicPlayer.state == PlayerState.paused) {
        await _musicPlayer.resume();
      } else {
        // Otherwise, restart the track
        await playMusic(_currentTrack!);
      }
    }
  }

  // Update volume
  Future<void> setVolume(double volume) async {
    _musicVolume = volume;
    await _musicPlayer.setVolume(volume);
  }

  // Enable/disable background music
  Future<void> setBackgroundMusicEnabled(bool enabled) async {
    _backgroundMusicEnabled = enabled;

    if (!enabled) {
      await stopMusic();
    } else {
      // Resume the last track if there was one
      if (_currentTrack != null) {
        await playMusic(_currentTrack!);
      }
    }
  }

  // Getters
  bool get isBackgroundMusicEnabled => _backgroundMusicEnabled;
  double get volume => _musicVolume;
  String? get currentTrack => _currentTrack;

  // Dispose
  Future<void> dispose() async {
    await _musicPlayer.dispose();
  }
}