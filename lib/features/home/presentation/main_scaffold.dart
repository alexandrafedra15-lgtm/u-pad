import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/state/app_state.dart';
import 'home_screen.dart';
import '../../tasks/presentation/tasks_screen.dart';
import '../../schedule/presentation/schedule_screen.dart';
import '../../health/presentation/health_screen.dart';
import '../../gamification/presentation/profile_screen.dart';

class MainScaffold extends StatefulWidget {
  final AppState appState;

  const MainScaffold({Key? key, required this.appState}) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final screens = [
          HomeScreen(appState: widget.appState),
          TasksScreen(appState: widget.appState),
          ScheduleScreen(appState: widget.appState),
          HealthScreen(appState: widget.appState),
          ProfileScreen(appState: widget.appState),
        ];

        return Scaffold(
          backgroundColor: AppTheme.bgSand,
          body: IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: AppTheme.bgSand,
              border: Border(top: BorderSide(color: AppTheme.borderSubtle, width: 1)),
            ),
            child: NavigationBar(
              backgroundColor: AppTheme.bgSand,
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
              },
              indicatorColor: AppTheme.primary.withOpacity(0.1),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home, color: AppTheme.primary),
                  label: 'Inicio',
                ),
                NavigationDestination(
                  icon: Icon(Icons.check_circle_outline),
                  selectedIcon: Icon(Icons.check_circle, color: AppTheme.primary),
                  label: 'Tareas',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_today_outlined),
                  selectedIcon: Icon(Icons.calendar_today, color: AppTheme.primary),
                  label: 'Horario',
                ),
                NavigationDestination(
                  icon: Icon(Icons.spa_outlined),
                  selectedIcon: Icon(Icons.spa, color: AppTheme.primary),
                  label: 'Balance',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person, color: AppTheme.primary),
                  label: 'Perfil',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
