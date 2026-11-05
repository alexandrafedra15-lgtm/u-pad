import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/state/app_state.dart';
import '../../home/presentation/main_scaffold.dart';
import '../../../core/widgets/animated_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  final AppState appState;

  const OnboardingScreen({Key? key, required this.appState}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _btnPulseCtrl;
  late Animation<double> _btnPulse;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.balance_outlined,
      'category': 'EQUILIBRIO UNIVERSITARIO',
      'title': 'Estudio y bienestar en armonía',
      'subtitle':
          'Equilibra-U te ayuda a cumplir con tus materias sin descuidar tu descanso, hidratación y tiempo libre.',
    },
    {
      'icon': Icons.sync_alt_outlined,
      'category': 'CANVAS LMS',
      'title': 'Tus entregas siempre al día',
      'subtitle':
          'Conecta tu plataforma universitaria para importar tareas, fechas de examen y calificaciones automáticamente.',
    },
    {
      'icon': Icons.spa_outlined,
      'category': 'HÁBITOS DIARIOS',
      'title': 'Cuidar tu cuerpo es rendir mejor',
      'subtitle':
          'Registra tu agua, horas de sueño y bloques de concentración con un diseño pensado para darte paz mental.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _btnPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _btnPulse = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _btnPulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _btnPulseCtrl.dispose();
    super.dispose();
  }

  void _onFinish() {
    widget.appState.storage.setOnboardingDone(true);
    widget.appState.awardXp(100, reason: 'Inicio en Equilibra-U');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (_) => MainScaffold(appState: widget.appState)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppTheme.bgSand,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              FadeSlideIn(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Equilibra-U',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    TextButton(
                      onPressed: _onFinish,
                      child: const Text(
                        'Omitir',
                        style: TextStyle(
                          color: AppTheme.textSub,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Page View
              SizedBox(
                height: 380,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final item = _pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon box
                        FadeSlideIn(
                          delay: const Duration(milliseconds: 0),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceCard,
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: AppTheme.borderSubtle),
                            ),
                            child: Icon(
                              item['icon'] as IconData,
                              size: 30,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Category
                        FadeSlideIn(
                          delay: const Duration(milliseconds: 90),
                          child: Text(
                            item['category'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: AppTheme.accentRose,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Title
                        FadeSlideIn(
                          delay: const Duration(milliseconds: 160),
                          child: Text(
                            item['title'] as String,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textMain,
                              height: 1.2,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Subtitle
                        FadeSlideIn(
                          delay: const Duration(milliseconds: 220),
                          child: Text(
                            item['subtitle'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSub,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const Spacer(),

              // Bottom Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dot indicators
                  Row(
                    children: List.generate(_pages.length, (index) {
                      final active = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.only(right: 6),
                        width: active ? 24 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color:
                              active ? AppTheme.primary : AppTheme.borderSubtle,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),

                  // Forward / Start Button
                  AnimatedBuilder(
                    animation: _btnPulse,
                    builder: (context, child) => Transform.scale(
                      scale: isLastPage ? _btnPulse.value : 1.0,
                      child: child,
                    ),
                    child: BounceTap(
                      onTap: () {
                        if (isLastPage) {
                          _onFinish();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOutCubic,
                          );
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(
                                  isLastPage ? 0.4 : 0.2),
                              blurRadius: isLastPage ? 16 : 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          isLastPage ? 'Comenzar' : 'Siguiente',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
