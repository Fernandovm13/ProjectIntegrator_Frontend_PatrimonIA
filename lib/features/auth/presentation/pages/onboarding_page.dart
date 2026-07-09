import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingSlide> _slides = [
    _OnboardingSlide(
      imageWidget: _buildPlaceholder(Icons.record_voice_over),
      title: 'Voces que no deben perderse',
      description:
          'Miles de historias, leyendas y saberes ancestrales están desapareciendo. PatrimonIA las preserva.',
    ),
    _OnboardingSlide(
      imageWidget: _buildPlaceholder(Icons.chat_outlined),
      title: 'Habla con la memoria de tu comunidad',
      description:
          'Pregunta cualquier cosa sobre la historia, leyendas y tradiciones de tu región. El narrador te responde.',
    ),
    _OnboardingSlide(
      imageWidget: _buildPlaceholder(Icons.shield_outlined),
      title: 'Sé Guardián de tu herencia',
      description:
          'Graba tus propios testimonios y conviértete en portador de la memoria colectiva.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildSkipButton(context),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) =>
                    _buildSlidePage(context, _slides[index]),
              ),
            ),
            _buildBottomButton(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () => context.go('/'),
        child: Text(
          'Omitir',
          style: tt.labelLarge?.copyWith(color: cs.onSurfaceVariant),
        ),
      ),
    );
  }

  Widget _buildSlidePage(BuildContext context, _OnboardingSlide slide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(child: slide.imageWidget),
          ),
          _buildPageIndicator(context),
          const SizedBox(height: 24),
          Text(
            slide.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontFamily: 'Playfair Display',
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            slide.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _slides.length,
        (index) {
          final isActive = _currentPage == index;
          return Container(
            width: isActive ? 24 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: isActive ? cs.primary : cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isLast = _currentPage == _slides.length - 1;
    final Color bgColor = isLast ? cs.secondary : cs.primary;

    Widget button = SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: cs.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          if (isLast) {
            context.go('/');
          } else {
            _controller.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        child: isLast
            ? Text(
                'Comenzar',
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onPrimary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Siguiente',
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onPrimary,
                    ),
                  ),
                  Icon(Icons.arrow_right_alt, color: cs.onPrimary, size: 24),
                ],
              ),
      ),
    );

    if (isLast) {
      button = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: cs.secondary.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: button,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: button,
    );
  }

  static Widget _buildPlaceholder(IconData icon) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
      ),
      child: Icon(icon, size: 100),
    );
  }
}

class _OnboardingSlide {
  final Widget imageWidget;
  final String title;
  final String description;

  const _OnboardingSlide({
    required this.imageWidget,
    required this.title,
    required this.description,
  });
}
