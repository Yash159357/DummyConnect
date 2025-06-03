
// lib/cubits/todo_statistics/todo_statistics_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dummy_connect/model/todo_model.dart';
import 'package:dummy_connect/controllers/cubits/todos/todo_cubit.dart';
import 'package:dummy_connect/controllers/cubits/todos/todo_state.dart';
import 'todo_statistics_state.dart';

class TodoStatisticsCubit extends Cubit<TodoStatisticsState> {
  final TodosCubit _todosCubit;

  TodoStatisticsCubit(this._todosCubit) : super(TodoStatisticsInitial()) {
    // Listen to todos changes
    _todosCubit.stream.listen((todosState) {
      if (todosState is TodosLoaded) {
        _calculateStatistics(todosState.todosResponse.todos);
      }
    });
  }

  void _calculateStatistics(List<Todo> todos) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Basic counts
    final totalTodos = todos.length;
    final completedTodos = todos.where((todo) => todo.completed).length;
    final pendingTodos = totalTodos - completedTodos;
    final completionPercentage = totalTodos > 0 ? (completedTodos / totalTodos) * 100 : 0.0;

    // Category breakdown
    final categoryBreakdown = <TodoCategory, int>{};
    for (final category in TodoCategory.values) {
      categoryBreakdown[category] = todos.where((todo) => todo.category == category).length;
    }

    // Priority breakdown
    final priorityBreakdown = <TodoPriority, int>{};
    for (final priority in TodoPriority.values) {
      priorityBreakdown[priority] = todos.where((todo) => todo.priority == priority).length;
    }

    // Today's activity
    final todosCreatedToday = todos.where((todo) {
      if (todo.createdAt == null) return false;
      final createdDate = DateTime(
        todo.createdAt!.year,
        todo.createdAt!.month,
        todo.createdAt!.day,
      );
      return createdDate.isAtSameMomentAs(today);
    }).length;

    final todosCompletedToday = todos.where((todo) {
      if (todo.updatedAt == null || !todo.completed) return false;
      final updatedDate = DateTime(
        todo.updatedAt!.year,
        todo.updatedAt!.month,
        todo.updatedAt!.day,
      );
      return updatedDate.isAtSameMomentAs(today);
    }).length;

    final statistics = TodoStatistics(
      totalTodos: totalTodos,
      completedTodos: completedTodos,
      pendingTodos: pendingTodos,
      completionPercentage: completionPercentage,
      categoryBreakdown: categoryBreakdown,
      priorityBreakdown: priorityBreakdown,
      todosCreatedToday: todosCreatedToday,
      todosCompletedToday: todosCompletedToday,
    );

    emit(TodoStatisticsLoaded(statistics));
  }

  // Manual refresh
  void refreshStatistics() {
    final todosState = _todosCubit.state;
    if (todosState is TodosLoaded) {
      _calculateStatistics(todosState.todosResponse.todos);
    }
  }
}
