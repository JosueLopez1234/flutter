import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:taskflow/app/taskflow_app.dart';
import 'package:taskflow/features/tasks/data/local_task_repository.dart';
import 'package:taskflow/features/tasks/presentation/tasks_view_model.dart';

void main() {
  testWidgets('La lista muestra tareas y abre el detalle', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<TasksViewModel>(
        create: (_) => TasksViewModel(LocalTaskRepository()),
        child: const TaskFlowApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mis tareas'), findsOneWidget);
    expect(find.text('Estudiar para el examen'), findsOneWidget);

    await tester.tap(find.text('Estudiar para el examen'));
    await tester.pumpAndSettle();

    expect(find.text('Detalle de tarea'), findsOneWidget);
    expect(find.text('Usuario: 1'), findsOneWidget);
  });
}