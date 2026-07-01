import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme_colors_extension.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingScreen> _screens = const [
    _OnboardingScreen(
      icon: Icons.groups_outlined,
      title: 'Voces que no deben perderse',
      description:
          'Miles de historias, leyendas y saberes ancestrales están desapareciendo. PatrimonIA las preserva.',
    ),
    _OnboardingScreen(
      icon: Icons.smartphone_outlined,
      title: 'Habla con la memoria de tu comunidad',
      description:
          'Pregunta cualquier cosa sobre la historia, leyendas y tradiciones de tu región. El narrador te responde.',
    ),
    _OnboardingScreen(
      icon: Icons.shield_outlined,
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
    return Scaffold(
      backgroundColor: context.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text(
                      'Omitir',
                      style: TextStyle(
                        color: context.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _screens.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final screen = _screens[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 120,
                          child: Icon(
                            screen.icon,
                            size: 80,
                            color: context.sacredJade,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          screen.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Playfair Display',
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: context.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          screen.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: context.textBody,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _screens.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 10 : 8,
                  height: _currentPage == index ? 10 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? context.maizeGold
                        : context.card,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _currentPage == _screens.length - 1
                            ? context.maizeGold
                            : context.sacredJade,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (_currentPage == _screens.length - 1) {
                      context.go('/login');
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    _currentPage == _screens.length - 1
                        ? 'Comenzar'
                        : 'Siguiente →',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _OnboardingScreen {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingScreen({
    required this.icon,
    required this.title,
    required this.description,
  });
}
