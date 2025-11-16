import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class VoiceInputSection extends StatelessWidget {
  final bool isListening;
  final String recognizedText;
  final String detectedName;
  final String detectedUnit;
  final Future<void> Function() onStartListening;
  final Future<void> Function() onStopListening;

  const VoiceInputSection({
    super.key,
    required this.isListening,
    required this.recognizedText,
    required this.detectedName,
    required this.detectedUnit,
    required this.onStartListening,
    required this.onStopListening,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Voice status container
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.getLightColor(AppColors.primary),
                AppColors.getLightColor(AppColors.primaryLight),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isListening ? AppColors.success : AppColors.primary,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              // Animated microphone icon
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isListening
                      ? AppColors.success.withOpacity(0.2)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isListening ? Icons.mic : Icons.mic_none,
                  size: 48,
                  color: isListening ? AppColors.success : AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isListening ? '🎤 Listening...' : '🎤 Voice Input Mode',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isListening ? AppColors.success : AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isListening
                    ? 'Say product name with unit\ne.g., "Rice 5 kg" or "Chicken pieces"'
                    : 'Tap the microphone button below\nto start speaking',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Microphone button
        Center(
          child: ElevatedButton.icon(
            onPressed: isListening ? onStopListening : onStartListening,
            style: ElevatedButton.styleFrom(
              backgroundColor: isListening ? AppColors.error : AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: Icon(isListening ? Icons.stop : Icons.mic),
            label: Text(
              isListening ? 'Stop Listening' : 'Start Speaking',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Recognized text display
        if (recognizedText.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.getLightColor(AppColors.primary),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.hearing, color: AppColors.primary, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Recognized:',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  recognizedText,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

        if (recognizedText.isNotEmpty) const SizedBox(height: 16),

        // Detected product info
        if (detectedName.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.getLightColor(AppColors.success),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.success),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.success, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Detected: $detectedName ($detectedUnit)',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}