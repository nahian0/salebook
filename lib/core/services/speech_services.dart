import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

enum SpeechProvider {
  google,  // Using speech_to_text with cloud mode
  local    // Using speech_to_text with on-device mode
}

/// Hybrid Speech Service using speech_to_text package
/// Automatically switches between cloud (Google) and on-device recognition
class HybridSpeechService {
  // Speech recognition
  late stt.SpeechToText _speech;
  bool _speechAvailable = false;

  // State
  bool _isInitialized = false;
  bool _isListening = false;
  SpeechProvider? _currentProvider;

  /// Initialize speech service
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      _speech = stt.SpeechToText();
      _speechAvailable = await _speech.initialize(
        onError: (error) => debugPrint('Speech error: ${error.errorMsg}'),
        onStatus: (status) => debugPrint('Speech status: $status'),
      );

      _isInitialized = true;
      return _speechAvailable;
    } catch (e) {
      debugPrint('Speech initialization error: $e');
      return false;
    }
  }

  /// Check internet connectivity
  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 2));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Start listening with automatic cloud/local selection
  Future<void> startListening({
    required Function(String text) onResult,
    required Function(String error) onError,
    String languageCode = 'bn-BD',
  }) async {
    if (_isListening) {
      debugPrint('Already listening');
      return;
    }

    if (!_isInitialized) {
      final success = await initialize();
      if (!success) {
        onError('Speech initialization failed');
        return;
      }
    }

    // Check microphone permission
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      onError('Microphone permission denied');
      return;
    }

    // Determine if we should use cloud or on-device
    final hasInternet = await _checkInternetConnection();

    try {
      _isListening = true;

      if (hasInternet) {
        // Use cloud-based recognition (more accurate, especially for Bangla)
        _currentProvider = SpeechProvider.google;
        debugPrint('🌐 Using Cloud Speech Recognition (Google)');
      } else {
        // Use on-device recognition
        _currentProvider = SpeechProvider.local;
        debugPrint('📱 Using On-Device Speech Recognition');
      }

      await _speech.listen(
        onResult: (result) {
          if (result.recognizedWords.isNotEmpty) {
            onResult(result.recognizedWords);
          }
        },
        localeId: languageCode,
        listenMode: stt.ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
        // KEY: Set onDevice based on internet connectivity
        onDevice: !hasInternet,  // false = use cloud, true = use on-device
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
      );
    } catch (e) {
      _isListening = false;
      debugPrint('Speech listening error: $e');
      onError('Speech error: ${e.toString()}');
    }
  }

  /// Stop listening
  Future<void> stopListening() async {
    if (!_isListening) return;

    try {
      await _speech.stop();
    } catch (e) {
      debugPrint('Error stopping speech: $e');
    }

    _isListening = false;
    _currentProvider = null;
  }

  /// Check if currently listening
  bool get isListening => _isListening;

  /// Get current provider
  SpeechProvider? get currentProvider => _currentProvider;

  /// Get available locales
  Future<List<stt.LocaleName>> get locales async {
    if (!_isInitialized) await initialize();
    return _speech.locales();
  }

  /// Dispose
  Future<void> dispose() async {
    await stopListening();
  }
}