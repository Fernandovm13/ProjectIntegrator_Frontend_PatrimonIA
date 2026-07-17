import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrimonia/core/security/fake_gps_guard.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('patrimonia/device_integrity');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('permite iniciar cuando no existe Fake GPS', (tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async => false);

    await tester.pumpWidget(
      const FakeGpsGuard(
        child: MaterialApp(home: Text('Aplicación disponible')),
      ),
    );
    await tester.pump();

    expect(find.text('Aplicación disponible'), findsOneWidget);
    expect(find.textContaining('Fake GPS'), findsNothing);
  });

  testWidgets('bloquea la aplicación y muestra un mensaje descriptivo', (
    tester,
  ) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async => true);

    await tester.pumpWidget(
      const FakeGpsGuard(
        child: MaterialApp(home: Text('Aplicación disponible')),
      ),
    );
    await tester.pump();

    expect(find.text('Aplicación disponible'), findsNothing);
    expect(find.textContaining('Fake GPS'), findsOneWidget);
    expect(find.text('Volver a comprobar'), findsOneWidget);
  });
}
