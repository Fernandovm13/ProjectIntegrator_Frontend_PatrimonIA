import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/platform/screen_security.dart';
import '../../../../core/router/route_observer.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/theme_colors_extension.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/underline_input.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> with RouteAware {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ModalRoute<void>? _route;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (_route != route) {
      if (_route != null) appRouteObserver.unsubscribe(this);
      _route = route;
      if (route != null) appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void didPush() {
    ScreenSecurity.setSecure(true);
  }

  @override
  void didPushNext() {
    ScreenSecurity.setSecure(false);
  }

  @override
  void didPopNext() {
    ScreenSecurity.setSecure(true);
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    ScreenSecurity.setSecure(false);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: context.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.headerStart, AppColors.headerEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle_outlined,
                    size: 36,
                    color: context.maizeGold,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'PatrimonIA',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDotPattern(context),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenido de vuelta',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    UnderlineInput(
                      controller: _emailController,
                      hint: 'tu@correo.com',
                      validator: (v) =>
                          v != null && v.contains('@') ? null : 'Correo inválido',
                    ),
                    const SizedBox(height: 20),
                    UnderlineInput(
                      controller: _passwordController,
                      hint: '········',
                      isPassword: true,
                      validator: (v) =>
                          v != null && v.length >= 3 ? null : 'Mínimo 3 caracteres',
                    ),
                    const SizedBox(height: 32),
                    if (authState.errorMessage != null) ...[
                      Text(
                        authState.errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    PrimaryButton(
                      text: authState.isLoading ? 'Iniciando...' : 'Iniciar sesión',
                      onPressed: authState.isLoading ? null : _doLogin,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: context.border),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'o continúa como',
                            style: TextStyle(
                              color: context.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: context.border),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: context.copalBrown),
                          foregroundColor: context.textPrimary,
                          backgroundColor: context.card,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          ref.read(authProvider.notifier).loginAnonymously();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.language, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Explorador anónimo',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: context.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: GestureDetector(
                        onTap: () => context.push('/register'),
                        child: Text.rich(
                          TextSpan(
                            text: '¿No tienes cuenta? ',
                            style: TextStyle(
                              color: context.textBody,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: 'Regístrate',
                                style: TextStyle(
                                  color: context.sacredJade,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDotPattern(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        12,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 3,
          height: 3,
          decoration: BoxDecoration(
            color: context.maizeGold,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
