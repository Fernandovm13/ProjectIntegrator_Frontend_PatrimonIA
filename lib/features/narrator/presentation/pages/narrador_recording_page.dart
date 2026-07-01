import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/theme_colors_extension.dart';
import '../../../../shared/widgets/waveform_widget.dart';

class NarradorRecordingPage extends StatelessWidget {
  const NarradorRecordingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surface,
      appBar: AppBar(
        backgroundColor: context.appBarDarkBg,
        elevation: 0,
        leading: const Icon(Icons.close, color: Colors.white),
        title: Text(
          'Grabando Relato Oral',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            color: context.textPrimary,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: const BoxDecoration(
              color: AppColors.warmAmber,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: const Text(
              '¿Cómo podemos pedirle permiso al cerro antes de entrar?',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(height: 40),
          const WaveformWidget(color: AppColors.maizeGold),
          const SizedBox(height: 16),
          Text(
            'Escuchando...',
            style: TextStyle(
              color: context.maizeGold,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
      bottomNavigationBar: Container(
        color: AppColors.navBackground,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: const Icon(Icons.close, color: Colors.white, size: 22),
              ),
              Container(
                height: 64,
                width: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.sacredJade,
                ),
                child: const Icon(Icons.mic, color: Colors.white, size: 30),
              ),
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.maizeGold,
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
