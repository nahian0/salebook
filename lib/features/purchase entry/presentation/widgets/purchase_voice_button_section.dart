// lib/features/purchase/presentation/widgets/purchase_voice_button_section.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/purchase_entry_controller.dart';

class PurchaseVoiceButtonSection extends StatelessWidget {
  final PurchaseEntryController controller;

  const PurchaseVoiceButtonSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Listening Status
            Obx(() {
              final isListening = controller.isListening.value;

              if (!isListening) {
                return const SizedBox.shrink();
              }
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    _WaveAnimation(controller: controller),
                    const SizedBox(height: 8),
                    Text(
                      controller.getListeningPrompt(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),

            // Voice Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: controller.toggleVoiceInput,
                child: Obx(() {
                  final isListening = controller.isListening.value;

                  return AnimatedBuilder(
                    animation: controller.scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: isListening
                            ? controller.scaleAnimation.value
                            : 1.0,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: isListening
                                ? AppColors.error
                                : AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (isListening
                                    ? AppColors.error
                                    : AppColors.primary)
                                    .withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: isListening ? 8 : 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            isListening
                                ? Icons.stop_rounded
                                : Icons.mic_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),

            // Hint Text
            Obx(() {
              final isListening = controller.isListening.value;

              if (isListening) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  controller.getVoiceHintText(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _WaveAnimation extends StatelessWidget {
  final PurchaseEntryController controller;

  const _WaveAnimation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return AnimatedBuilder(
            animation: controller.waveController,
            builder: (context, child) {
              final double value =
                  (controller.waveController.value + (index * 0.15)) % 1.0;
              final double height = 8 +
                  (24 *
                      (0.5 +
                          0.5 *
                              (value < 0.5 ? value * 2 : (1 - value) * 2)));
              return Container(
                width: 4,
                height: height,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}