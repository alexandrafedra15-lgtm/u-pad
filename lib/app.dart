import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/state/app_state.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/home/presentation/main_scaffold.dart';

class UPadApp extends StatefulWidget {
  const UPadApp({Key? key}) : super(key: key);

  @override
  State<UPadApp> createState() => _UPadAppState();
}

class _UPadAppState extends State<UPadApp> {
  final AppState _appState = AppState();
  bool _isOnboardingDone = false;
  bool _checkedOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final done = await _appState.storage.isOnboardingDone();
    if (mounted) {
      setState(() {
        _isOnboardingDone = done;
        _checkedOnboarding = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Equilibra-U',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _checkedOnboarding
          ? (_isOnboardingDone
              ? MainScaffold(appState: _appState)
              : OnboardingScreen(appState: _appState))
          : const Scaffold(
              backgroundColor: AppTheme.bgSand,
              body: Center(
                child: CircularProgressIndicator(color: AppTheme.primary),
              ),
            ),
    );
  }
}
