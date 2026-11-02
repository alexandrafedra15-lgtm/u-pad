import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/state/app_state.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';

class UPadApp extends StatefulWidget {
  const UPadApp({Key? key}) : super(key: key);

  @override
  State<UPadApp> createState() => _UPadAppState();
}

class _UPadAppState extends State<UPadApp> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Equilibra-U',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: OnboardingScreen(appState: _appState),
    );
  }
}
