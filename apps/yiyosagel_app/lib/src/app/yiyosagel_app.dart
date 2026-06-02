import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../features/settings/settings_controller.dart';
import 'yiyosagel_router.dart';

class YiyosaGelApp extends ConsumerWidget {
  const YiyosaGelApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(settingsControllerProvider).darkMode;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'YiyosaGel',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
