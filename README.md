# 🎓 U-Pad — Tu Central Universitaria Todo-en-Uno

**U-Pad** es una app móvil hecha en Flutter orientada a estudiantes universitarios y de institutos. Integra en un solo lugar la gestión de tareas académicas sincronizadas con **Canvas LMS**, el organizador de horarios y un módulo de hábitos y bienestar físico/mental con gamificación.

---

## 🌟 Características Principales

1. **🔗 Integración con Canvas LMS (Instructure):**
   - Conexión vía dominio universitario + API Token personal o feed iCal.
   - Sincronización automática de materias, tareas pendientes, quizzes y rúbricas.
   - Badge distintivo `CANVAS` en tareas y enlace directo de entrega.

2. **📋 Gestor de Tareas & Deadlines:**
   - Prioridades (Alta, Media, Baja), countdown de días restantes.
   - Sistema de recompensas XP al completar cada entrega.
   - Filtros rápidos: Todas, Pendientes, Canvas, Completadas.

3. **📅 Horario Semanal:**
   - Bloques diferenciados: Clases universitarias, Estudio focalizado, Descansos y Ejercicio.

4. **🌿 Hábitos y Vida Saludable:**
   - Contador rápido de agua (meta 8 vasos).
   - Tracker de horas de sueño con diagnóstico de descanso.
   - Registro de actividad física (Gym, Caminata, Yoga).
   - Racha diaria de vida sana.

5. **🏆 Gamificación & Motivación:**
   - Sistema de XP, Niveles de estudiante y Medallas desbloqueables.
   - Rachas de estudio activo (🔥 Streaks).

---

## 📁 Estructura del Código

```
lib/
├── app.dart                               # Configuración de MaterialApp y Temas
├── main.dart                              # Punto de entrada de la aplicación
├── core/
│   ├── state/
│   │   └── app_state.dart                 # Estado global reactivo (ChangeNotifier)
│   └── theme/
│       └── app_theme.dart                 # Paleta moderna (Primary Indigo, Mint, Orange)
└── features/
    ├── canvas/                            # Integración con Canvas LMS
    │   ├── models/canvas_models.dart
    │   ├── services/canvas_service.dart
    │   └── presentation/canvas_connect_dialog.dart
    ├── tasks/                             # Gestión de tareas y entregas
    │   ├── models/task_model.dart
    │   └── presentation/tasks_screen.dart
    ├── schedule/                          # Horario y bloques semanales
    │   └── presentation/schedule_screen.dart
    ├── health/                            # Agua, Sueño y Ejercicio
    │   ├── models/health_metrics.dart
    │   └── presentation/health_screen.dart
    ├── gamification/                      # XP, Niveles y Logros
    │   ├── models/user_stats.dart
    │   └── presentation/profile_screen.dart
    └── home/                              # Dashboard principal
        ├── presentation/home_screen.dart
        └── presentation/main_scaffold.dart
```

---

## 🚀 Cómo Ejecutar el Proyecto

1. Clonar o abrir la carpeta en tu IDE (VS Code o Android Studio).
2. Obtener dependencias:
   ```bash
   flutter pub get
   ```
3. Ejecutar en emulador o dispositivo físico:
   ```bash
   flutter run
   ```
