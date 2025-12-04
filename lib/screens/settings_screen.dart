import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/audio_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AudioManager _audioManager = AudioManager();

  // Audio Settings
  bool _backgroundMusic = true;
  bool _soundEffects = true;
  double _musicVolume = 0.7;

  // Gameplay Settings
  bool _shakeToMix = true;
  bool _notifications = true;
  bool _hapticFeedback = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load saved settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _backgroundMusic = prefs.getBool('backgroundMusic') ?? true;
      _soundEffects = prefs.getBool('soundEffects') ?? true;
      _musicVolume = prefs.getDouble('musicVolume') ?? 0.7;
      _shakeToMix = prefs.getBool('shakeToMix') ?? true;
      _notifications = prefs.getBool('notifications') ?? true;
      _hapticFeedback = prefs.getBool('hapticFeedback') ?? true;
    });
  }

  // Save a setting to SharedPreferences
  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'Caveat',
            fontSizeFactor: 1.5,
          ),
        ),
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF0F5), // Lavender blush
                  Color(0xFFFFE4E1), // Misty rose
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header with back button
                  _buildHeader(context),

                  // Settings content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAudioSection(),
                          const SizedBox(height: 24),
                          _buildGameplaySection(),
                          const SizedBox(height: 24),
                          _buildAboutSection(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFB6C1)),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Settings',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFB6C1),
                fontFamily: 'Caveat',
              ),
            ),
          ),
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFCFA6AF), size: 28),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'Caveat',
              color: Color(0xFFCFA6AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildToggleTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'Caveat',
        ),
      ),
      subtitle: subtitle != null
          ? Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 18,
          fontFamily: 'Caveat',
        ),
      )
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFFFB6C1),
        activeTrackColor: const Color(0xFFFFF0F3),
      ),
    );
  }

  Widget _buildSliderTile({
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
    required bool enabled,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Caveat',
                  color: enabled ? Colors.black87 : Colors.grey,
                ),
              ),
              Text(
                '${(value * 100).round()}%',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Caveat',
                  fontWeight: FontWeight.bold,
                  color: enabled ? const Color(0xFFFFB6C1) : Colors.grey,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor:
              enabled ? const Color(0xFFFFB6C1) : Colors.grey[300],
              inactiveTrackColor: Colors.grey[200],
              thumbColor: enabled ? const Color(0xFFFFB6C1) : Colors.grey,
              overlayColor: const Color(0xFFFFB6C1).withOpacity(0.2),
            ),
            child: Slider(
              value: value,
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Audio', Icons.volume_up),
        _buildSettingsCard(
          children: [
            _buildToggleTile(
              title: 'Background Music',
              subtitle: 'Play music during gameplay',
              value: _backgroundMusic,
              onChanged: (value) async {
                setState(() => _backgroundMusic = value);
                await _saveSetting('backgroundMusic', value);
                // Update AudioManager
                await _audioManager.setBackgroundMusicEnabled(value);
              },
            ),
            _buildSliderTile(
              title: 'Music Volume',
              value: _musicVolume,
              enabled: _backgroundMusic,
              onChanged: (value) async {
                setState(() => _musicVolume = value);
                await _saveSetting('musicVolume', value);
                // Update AudioManager volume
                await _audioManager.setVolume(value);
              },
            ),
            const Divider(height: 1),
            _buildToggleTile(
              title: 'Sound Effects',
              subtitle: 'Play sounds for actions',
              value: _soundEffects,
              onChanged: (value) {
                setState(() => _soundEffects = value);
                _saveSetting('soundEffects', value);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGameplaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Gameplay', Icons.gamepad),
        _buildSettingsCard(
          children: [
            _buildToggleTile(
              title: 'Shake to Mix',
              subtitle: 'Shake your device to mix ingredients',
              value: _shakeToMix,
              onChanged: (value) {
                setState(() => _shakeToMix = value);
                _saveSetting('shakeToMix', value);
              },
            ),
            const Divider(height: 1),
            _buildToggleTile(
              title: 'Haptic Feedback',
              subtitle: 'Vibration for actions',
              value: _hapticFeedback,
              onChanged: (value) {
                setState(() => _hapticFeedback = value);
                _saveSetting('hapticFeedback', value);
              },
            ),
            const Divider(height: 1),
            _buildToggleTile(
              title: 'Notifications',
              subtitle: 'Get reminders to play',
              value: _notifications,
              onChanged: (value) {
                setState(() => _notifications = value);
                _saveSetting('notifications', value);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('About', Icons.info_outline),
        _buildSettingsCard(
          children: [
            ListTile(
              title: const Text(
                'Version',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Caveat',
                ),
              ),
              trailing: Text(
                '1.0.0',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20,
                  fontFamily: 'Caveat',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              title: const Text(
                'Credits',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Caveat',
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showCreditsDialog(),
            ),
          ],
        ),
      ],
    );
  }

  void _showCreditsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Credits',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Caveat',
            color: Color(0xFFCFA6AF),
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dessert Delivery Dash',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Caveat',
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Developed by:',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Caveat',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '• Iris Xu\n• Rae Dong\n• Maria Shackett\n• Ben Stroeher',
              style: TextStyle(fontSize: 16, fontFamily: 'Caveat'),
            ),
            SizedBox(height: 8),
            Text(
              'CS 407 - Fall 2025',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Caveat',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Caveat',
                fontWeight: FontWeight.bold,
                color: Color(0xFFCFA6AF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}