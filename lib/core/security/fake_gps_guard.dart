import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FakeGpsGuard extends StatefulWidget {
  const FakeGpsGuard({required this.child, super.key});

  final Widget child;

  @override
  State<FakeGpsGuard> createState() => _FakeGpsGuardState();
}

class _FakeGpsGuardState extends State<FakeGpsGuard>
    with WidgetsBindingObserver {
  static const _channel = MethodChannel('patrimonia/device_integrity');

  bool _isChecking = true;
  bool _fakeGpsDetected = false;
  int _checkGeneration = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkDevice();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkDevice();
    }
  }

  Future<void> _checkDevice({bool showProgress = false}) async {
    final generation = ++_checkGeneration;
    if (showProgress && mounted) {
      setState(() => _isChecking = true);
    }

    var detected = false;
    try {
      detected = await _channel.invokeMethod<bool>('isFakeGpsEnabled') ?? false;
    } on MissingPluginException {
      // This verification is only available in the Android application.
    } on PlatformException {
      // A platform failure must not leave the application on a loading screen.
    }

    if (!mounted || generation != _checkGeneration) return;
    setState(() {
      _fakeGpsDetected = detected;
      _isChecking = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isChecking && !_fakeGpsDetected) {
      return widget.child;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF5F0DC),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: _isChecking
                  ? const CircularProgressIndicator(color: Color(0xFF1A5C3A))
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_off_rounded,
                          color: Color(0xFF8B2020),
                          size: 72,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Ubicación simulada detectada',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF2D1A0A),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'PatrimonIA no puede ejecutarse mientras exista una '
                          'aplicación Fake GPS activa. Desactiva la aplicación '
                          'de ubicación simulada en las Opciones de desarrollador '
                          'y vuelve a intentarlo.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF5A3A20),
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 28),
                        FilledButton.icon(
                          onPressed: () => _checkDevice(showProgress: true),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Volver a comprobar'),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF1A5C3A),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
