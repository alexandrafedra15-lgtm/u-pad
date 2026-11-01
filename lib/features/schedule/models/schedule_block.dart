import 'package:flutter/material.dart';

enum ScheduleType { clase, estudio, ejercicio, descanso }

class ScheduleBlock {
  final String id;
  final int dayIndex; // 0: Lun, 1: Mar, 2: Mié, 3: Jue, 4: Vie, 5: Sáb, 6: Dom
  final String title;
  final String location; // Aula, Laboratorio o link Zoom/Meet
  final String startTime; // ej: "08:00"
  final String endTime; // ej: "10:00"
  final ScheduleType type;
  final Color color;

  ScheduleBlock({
    required this.id,
    required this.dayIndex,
    required this.title,
    this.location = '',
    required this.startTime,
    required this.endTime,
    this.type = ScheduleType.clase,
    required this.color,
  });

  String get typeLabel {
    switch (type) {
      case ScheduleType.clase:
        return 'Clase Universitaria';
      case ScheduleType.estudio:
        return 'Estudio Focalizado';
      case ScheduleType.ejercicio:
        return 'Bienestar Físico';
      case ScheduleType.descanso:
        return 'Pausa y Almuerzo';
    }
  }
}
