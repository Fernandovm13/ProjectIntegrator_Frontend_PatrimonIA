import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'shared/theme/material_theme.dart';
import 'shared/theme/util.dart';

class PatrimonIAApp extends ConsumerWidget {
  const PatrimonIAApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    TextTheme textTheme = createTextTheme('Poppins', 'Nunito');
    MaterialTheme materialTheme = MaterialTheme(textTheme);

    return MaterialApp.router(
      title: 'PatrimonIA',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
