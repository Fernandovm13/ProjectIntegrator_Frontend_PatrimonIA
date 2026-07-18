import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import 'secure_session_storage.dart';

class InactivitySessionGuard extends ConsumerStatefulWidget {
  const InactivitySessionGuard({
    required this.child,
    this.timeout = sessionInactivityTimeout,
    super.key,
  });

  final Widget child;
  final Duration timeout;

  @override
  ConsumerState<InactivitySessionGuard> createState() =>
      _InactivitySessionGuardState();
}

class _InactivitySessionGuardState extends ConsumerState<InactivitySessionGuard>
    with WidgetsBindingObserver {
  Timer? _inactivityTimer;
  Timer? _persistenceTimer;
  DateTime? _lastActivityAt;
  String? _activeToken;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_activeToken == null) return;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _persistActivityNow();
    } else if (state == AppLifecycleState.resumed) {
      _validateElapsedTime();
    }
  }

  void _startSession(String token) {
    _activeToken = token;
    _lastActivityAt = DateTime.now();
    _restartTimer(widget.timeout);
  }

  void _stopSession() {
    _activeToken = null;
    _lastActivityAt = null;
    _inactivityTimer?.cancel();
    _persistenceTimer?.cancel();
  }

  void _registerInteraction() {
    if (_activeToken == null || !ref.read(authProvider).isAuthenticated) return;

    _lastActivityAt = DateTime.now();
    _restartTimer(widget.timeout);

    _persistenceTimer?.cancel();
    _persistenceTimer = Timer(const Duration(seconds: 1), _persistActivityNow);
  }

  void _restartTimer(Duration duration) {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(duration, _expireSession);
  }

  void _validateElapsedTime() {
    final lastActivityAt = _lastActivityAt;
    if (lastActivityAt == null) return;

    final elapsed = DateTime.now().difference(lastActivityAt);
    if (elapsed >= widget.timeout) {
      _expireSession();
    } else {
      _restartTimer(widget.timeout - elapsed);
    }
  }

  Future<void> _persistActivityNow() async {
    _persistenceTimer?.cancel();
    final lastActivityAt = _lastActivityAt;
    if (_activeToken == null || lastActivityAt == null) return;

    await ref.read(sessionStorageProvider).saveLastActivity(lastActivityAt);
  }

  Future<void> _expireSession() async {
    final lastActivityAt = _lastActivityAt;
    if (_activeToken == null || lastActivityAt == null) return;

    _inactivityTimer?.cancel();
    await ref
        .read(authProvider.notifier)
        .expireDueToInactivity(
          lastActivityAt: lastActivityAt,
          timeout: widget.timeout,
        );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    _persistenceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      final nextToken = next.isAuthenticated ? next.token : null;
      if (nextToken != null && nextToken != _activeToken) {
        _startSession(nextToken);
      } else if (nextToken == null && _activeToken != null) {
        _stopSession();
      }
    });

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _registerInteraction(),
      onPointerMove: (_) => _registerInteraction(),
      onPointerSignal: (_) => _registerInteraction(),
      child: Focus(
        autofocus: true,
        onKeyEvent: (_, __) {
          _registerInteraction();
          return KeyEventResult.ignored;
        },
        child: widget.child,
      ),
    );
  }
}
