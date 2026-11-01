import 'package:flutter/material.dart';

class CanvasCourse {
  final String id;
  final String name;
  final String courseCode;
  final Color color;

  CanvasCourse({
    required this.id,
    required this.name,
    required this.courseCode,
    this.color = const Color(0xFF6C5CE7),
  });
}

class CanvasAssignment {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final DateTime? dueAt;
  final double pointsPossible;
  final bool hasSubmitted;
  final String htmlUrl;

  CanvasAssignment({
    required this.id,
    required this.courseId,
    required this.title,
    this.description = '',
    this.dueAt,
    this.pointsPossible = 20.0,
    this.hasSubmitted = false,
    required this.htmlUrl,
  });
}
