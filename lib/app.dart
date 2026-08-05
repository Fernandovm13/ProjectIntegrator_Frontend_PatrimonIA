import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/router.dart';
import 'core/di/app_container.dart';
import 'shared/theme/material_theme.dart';
import 'shared/theme/util.dart';

class PatrimonIAApp extends ConsumerStatefulWidget {
  const PatrimonIAApp({super.key});

  @override
  ConsumerState<PatrimonIAApp> createState() => _PatrimonIAAppState();
}

class _PatrimonIAAppState extends ConsumerState<PatrimonIAApp> {
  @override
  void initState() {
    super.initState();
    ref.read(appContainerProvider.notifier).init();
  }

  @override
  Widget build(BuildContext context) {
    final container = ref.watch(appContainerProvider);

    if (container == null) {
      return MaterialApp(
        title: 'PatrimonIA',
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final textTheme = createTextTheme('Poppins', 'Nunito');
    final materialTheme = MaterialTheme(textTheme);

    return MaterialApp.router(
      title: 'PatrimonIA',
      debugShowCheckedModeBanner: false,
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
