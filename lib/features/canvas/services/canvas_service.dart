import 'package:flutter/material.dart';
import '../models/canvas_models.dart';
import '../../tasks/models/task_model.dart';

class CanvasService {
  String? canvasDomain;
  String? apiToken;
  bool isConnected = false;

  // Mock initial demo data showing realistic university courses
  final List<CanvasCourse> _mockCourses = [
    CanvasCourse(
      id: '101',
      name: 'Estructuras de Datos y Algoritmos',
      courseCode: 'CS-201',
      color: const Color(0xFF6C5CE7),
    ),
    CanvasCourse(
      id: '102',
      name: 'Cálculo Multivariable',
      courseCode: 'MAT-301',
      color: const Color(0xFF0984E3),
    ),
    CanvasCourse(
      id: '103',
      name: 'Física Universitaria II',
      courseCode: 'FIS-102',
      color: const Color(0xFFE17055),
    ),
  ];

  Future<bool> connect({
    required String domain,
    required String token,
  }) async {
    // Simulation of Canvas API authentication check
    await Future.delayed(const Duration(milliseconds: 600));
    canvasDomain = domain.replaceAll('https://', '').replaceAll('/', '');
    apiToken = token;
    isConnected = true;
    return true;
  }

  void disconnect() {
    canvasDomain = null;
    apiToken = null;
    isConnected = false;
  }

  Future<List<CanvasCourse>> fetchActiveCourses() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockCourses;
  }

  Future<List<TaskModel>> fetchAssignmentsAsTasks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final now = DateTime.now();

    return [
      TaskModel(
        id: 'canvas_1',
        title: 'Laboratorio 4: Grafos y Árboles AVL',
        description: 'Implementar el algoritmo de Dijkstra en C++ y subir informe en PDF.',
        courseName: 'CS-201: Algoritmos',
        dueDate: now.add(const Duration(days: 2, hours: 4)),
        priority: TaskPriority.alta,
        status: TaskStatus.pendiente,
        isFromCanvas: true,
        canvasUrl: 'https://$canvasDomain/courses/101/assignments/1',
        xpReward: 120,
      ),
      TaskModel(
        id: 'canvas_2',
        title: 'Problem Set 5: Integrales Dobles',
        description: 'Resolver los ejercicios pares de la guía 3.',
        courseName: 'MAT-301: Cálculo',
        dueDate: now.add(const Duration(days: 4)),
        priority: TaskPriority.media,
        status: TaskStatus.enProgreso,
        isFromCanvas: true,
        canvasUrl: 'https://$canvasDomain/courses/102/assignments/2',
        xpReward: 80,
      ),
      TaskModel(
        id: 'canvas_3',
        title: 'Quiz 3: Ley de Gauss',
        description: 'Evaluación online de 20 minutos con preguntas teóricas y numéricas.',
        courseName: 'FIS-102: Física II',
        dueDate: now.add(const Duration(days: 1, hours: 2)),
        priority: TaskPriority.alta,
        status: TaskStatus.pendiente,
        isFromCanvas: true,
        canvasUrl: 'https://$canvasDomain/courses/103/assignments/3',
        xpReward: 100,
      ),
    ];
  }
}
