import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'task.dart';

const demoTasks = <Task>[
  Task(
    id: 1,
    title: 'Entregar informe de Aplicaciones Móviles',
    description: 'Terminar y subir el informe al aula virtual',
    priority: 'Alta',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 2,
    title: 'Estudiar para el examen',
    description: 'Repasar widgets, estado y navegación',
    priority: 'Alta',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 3,
    title: 'Preparar exposición',
    description: 'Organizar diapositivas y practicar',
    priority: 'Media',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 4,
    title: 'Subir avance a GitHub',
    description: 'Hacer commit y push del proyecto TaskFlow',
    priority: 'Media',
    isCompleted: true,
    userId: 1,
  ),
  Task(
    id: 5,
    title: 'Revisar código',
    description: 'Ejecutar flutter analyze',
    priority: 'Baja',
    isCompleted: false,
    userId: 1,
  ),
];

Task? findTask(int? id) {
  for (final task in demoTasks) {
    if (task.id == id) return task;
  }
  return null;
}

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TaskListScreen()),
    GoRoute(
      path: '/task/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return TaskDetailScreen(task: findTask(id));
      },
    ),
  ],
);

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, this.onTap});

  final Task task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: task.isCompleted ? Colors.green : null,
        ),
        title: Text(task.title),
        subtitle: Text('Prioridad: ${task.priority}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis tareas'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demoTasks.length,
        itemBuilder: (context, index) {
          final task = demoTasks[index];
          return TaskCard(
            task: task,
            onTap: () => context.push('/task/${task.id}'),
          );
        },
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  static const String studentName = 'Eduardo Josue Lopez Lopez';
  static const String courseName = 'Desarrollo de aplicaciones móviles';
  static const int dailyGoal = 5;

  int pendingTasks = 3;
  int completedTasks = 0;

  void _completeTask() {
    if (pendingTasks == 0) return;

    setState(() {
      pendingTasks--;
      if (completedTasks < dailyGoal) {
        completedTasks++;
      }
    });
  }

  void _addTask() {
    setState(() {
      pendingTasks++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final statusMessage = pendingTasks == 0
        ? '¡Excelente! No tienes tareas pendientes.'
        : 'Aún tienes tareas por organizar.';

    return Scaffold(
      appBar: AppBar(title: const Text('TaskFlow'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle_outline, size: 56),
            const SizedBox(height: 24),
            Text(
              '¡Hola, $studentName!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            const Text('Bienvenido/a a $courseName.'),
            const SizedBox(height: 8),
            Text(statusMessage),
            const SizedBox(height: 8),
            Text('Completadas hoy: $completedTasks de $dailyGoal'),
            const SizedBox(height: 28),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.pending_actions),
                    const SizedBox(width: 12),
                    Text('Tareas pendientes: $pendingTasks'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: _addTask,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar tarea'),
                ),
                OutlinedButton.icon(
                  onPressed: pendingTasks == 0 ? null : _completeTask,
                  icon: const Icon(Icons.done),
                  label: const Text('Completar una tarea'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.task});

  final Task? task;

  @override
  Widget build(BuildContext context) {
    final selected = task;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarea')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: selected == null
            ? const Text('No se encontró esta tarea.')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selected.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(selected.description),
                  const SizedBox(height: 16),
                  Chip(label: Text('Prioridad: ${selected.priority}')),
                  const SizedBox(height: 12),
                  Text(
                    selected.isCompleted
                        ? 'Estado: completada'
                        : 'Estado: pendiente',
                  ),
                  const SizedBox(height: 8),
                  Text('Usuario: ${selected.userId}'),
                  const Spacer(),
                  FilledButton.tonalIcon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Volver al listado'),
                  ),
                ],
              ),
      ),
    );
  }
}
