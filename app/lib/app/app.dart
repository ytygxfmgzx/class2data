import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';
import 'theme.dart';

class Class2DataApp extends ConsumerWidget {
  const Class2DataApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: '课小记',
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
