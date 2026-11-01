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
          body: IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
              },
              indicatorColor: AppTheme.primary.withOpacity(0.15),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard, color: AppTheme.primary),
                  label: 'Inicio',
                ),
                NavigationDestination(
                  icon: Icon(Icons.checklist_outlined),
                  selectedIcon: Icon(Icons.checklist, color: AppTheme.primary),
                  label: 'Tareas',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_month_outlined),
                  selectedIcon: Icon(Icons.calendar_month, color: AppTheme.primary),
                  label: 'Horario',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite, color: AppTheme.healthMint),
                  label: 'Salud',
                ),
                NavigationDestination(
                  icon: Icon(Icons.emoji_events_outlined),
                  selectedIcon: Icon(Icons.emoji_events, color: AppTheme.xpGold),
                  label: 'Logros',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
