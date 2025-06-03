// lib/cubits/todo_statistics/todo_statistics_state.dart
import 'package:equatable/equatable.dart';
import 'package:dummy_connect/model/todo_model.dart';

class TodoStatistics extends Equatable {
  final int totalTodos;
  final int completedTodos;
  final int pendingTodos;
  final double completionPercentage;
  final Map<TodoCategory, int> categoryBreakdown;
  final Map<TodoPriority, int> priorityBreakdown;
  final int todosCreatedToday;
  final int todosCompletedToday;

  const TodoStatistics({
    required this.totalTodos,
    required this.completedTodos,
    required this.pendingTodos,
    required this.completionPercentage,
    required this.categoryBreakdown,
    required this.priorityBreakdown,
    required this.todosCreatedToday,
    required this.todosCompletedToday,
  });

  @override
  List<Object?> get props => [
    totalTodos,
    completedTodos,
    pendingTodos,
    completionPercentage,
    categoryBreakdown,
    priorityBreakdown,
    todosCreatedToday,
    todosCompletedToday,
  ];
}

abstract class TodoStatisticsState extends Equatable {
  const TodoStatisticsState();

  @override
  List<Object?> get props => [];
}

class TodoStatisticsInitial extends TodoStatisticsState {}

class TodoStatisticsLoaded extends TodoStatisticsState {
  final TodoStatistics statistics;

  const TodoStatisticsLoaded(this.statistics);

  @override
  List<Object?> get props => [statistics];
}
