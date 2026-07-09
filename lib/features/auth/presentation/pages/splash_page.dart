import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.scrim,
      body: Stack(
        children: [
          _buildParticles(context),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGlowLogo(context),
                const SizedBox(height: 32),
                Text(
                  'PatrimonIA',
                  style: tt.displaySmall?.copyWith(
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.bold,
                    color: cs.surface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '♦ ♦ ♦ ♦ ♦ ♦ ♦ ♦ ♦ ♦',
                  style: TextStyle(
                    color: cs.tertiary.withValues(alpha: 0.4),
                    fontSize: 10,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'La memoria viva de tu comunidad',
                  style: tt.titleMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: cs.surface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticles(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    final particles = <_ParticleData>[
      _ParticleData(top: 0.05, left: 0.08, size: 3, color: cs.primary),
      _ParticleData(top: 0.10, left: 0.75, size: 4, color: cs.tertiary),
      _ParticleData(top: 0.18, left: 0.25, size: 2, color: cs.onPrimary.withValues(alpha: 0.3)),
      _ParticleData(top: 0.25, left: 0.65, size: 5, color: cs.primary),
      _ParticleData(top: 0.33, left: 0.12, size: 3, color: cs.tertiary),
      _ParticleData(top: 0.40, left: 0.82, size: 2, color: cs.onPrimary.withValues(alpha: 0.3)),
      _ParticleData(top: 0.48, left: 0.35, size: 4, color: cs.primary),
      _ParticleData(top: 0.55, left: 0.88, size: 3, color: cs.tertiary),
      _ParticleData(top: 0.62, left: 0.04, size: 5, color: cs.onPrimary.withValues(alpha: 0.3)),
      _ParticleData(top: 0.70, left: 0.55, size: 2, color: cs.primary),
      _ParticleData(top: 0.78, left: 0.18, size: 4, color: cs.tertiary),
      _ParticleData(top: 0.85, left: 0.72, size: 3, color: cs.onPrimary.withValues(alpha: 0.3)),
      _ParticleData(top: 0.93, left: 0.42, size: 5, color: cs.primary),
    ];

    return Stack(
      children: particles.map((p) {
        return Positioned(
          top: size.height * p.top,
          left: size.width * p.left,
          child: Container(
            width: p.size,
            height: p.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: p.color,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGlowLogo(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border.all(
          color: cs.tertiary.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: cs.tertiary.withValues(alpha: 0.5),
            blurRadius: 50,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Icon(
        Icons.auto_awesome,
        color: cs.tertiary,
        size: 40,
      ),
    );
  }
}

class _ParticleData {
  final double top;
  final double left;
  final double size;
  final Color color;

  const _ParticleData({
    required this.top,
    required this.left,
    required this.size,
    required this.color,
  });
}
