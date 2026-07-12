import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

class AIEyesApp extends ConsumerWidget {
  const AIEyesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI EYES',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
