// utils/shake_detector.dart
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:sensors_plus/sensors_plus.dart';

/// Detects when the device is shaken
/// Usage:
/// ```
/// final detector = ShakeDetector(
///   onShake: () {
///     print('Device shaken!');
///   },
///   shakeThreshold: 2.7,
/// );
/// detector.startListening();
/// // Later...
/// detector.stopListening();
/// ```
class ShakeDetector {
  /// Callback function when shake is detected
  final VoidCallback onShake;

  /// How hard the device needs to be shaken (1.0 = very sensitive, 5.0 = very hard)
  final double shakeThreshold;

  /// Minimum time between shake detections (milliseconds)
  final int shakeCooldown;

  StreamSubscription<AccelerometerEvent>? _subscription;
  DateTime? _lastShakeTime;

  ShakeDetector({
    required this.onShake,
    this.shakeThreshold = 2.7,
    this.shakeCooldown = 500,
  });

  /// Start listening for shake events
  void startListening() {
    _subscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      // Calculate the magnitude of acceleration (excluding gravity)
      double acceleration = sqrt(
          event.x * event.x +
              event.y * event.y +
              event.z * event.z
      );

      // Standard gravity is ~9.8, so we subtract it
      // to get the device's movement acceleration
      double gForce = (acceleration - 9.8).abs();

      // Check if shake threshold is exceeded
      if (gForce > shakeThreshold) {
        final now = DateTime.now();

        // Only trigger if enough time has passed since last shake (cooldown)
        if (_lastShakeTime == null ||
            now.difference(_lastShakeTime!).inMilliseconds > shakeCooldown) {
          _lastShakeTime = now;
          onShake();
        }
      }
    });
  }

  /// Stop listening for shake events
  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    _lastShakeTime = null;
  }

  /// Check if currently listening
  bool get isListening => _subscription != null;
}