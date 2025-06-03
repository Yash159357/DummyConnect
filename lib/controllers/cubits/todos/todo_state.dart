// lib/cubits/todos/todos_state.dart
import 'package:equatable/equatable.dart';
import 'package:dummy_connect/model/todo_model.dart';

abstract class TodosState extends Equatable {
  const TodosState();

  @override
  List<Object?> get props => [];
}

class TodosInitial extends TodosState {}

class TodosLoading extends TodosState {}

class TodosLoaded extends TodosState {
  final TodosResponse todosResponse;
  final TodoFilter filter;
  final TodoSort sort;

  const TodosLoaded({
    required this.todosResponse,
    this.filter = TodoFilter.all,
    this.sort = TodoSort.newest,
  });

  @override
  List<Object?> get props => [todosResponse, filter, sort];

  TodosLoaded copyWith({
    TodosResponse? todosResponse,
    TodoFilter? filter,
    TodoSort? sort,
  }) {
    return TodosLoaded(
      todosResponse: todosResponse ?? this.todosResponse,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
    );
  }

  List<Todo> get filteredTodos {
    List<Todo> todos = todosResponse.todos;
    
    // Apply filter
    switch (filter) {
      case TodoFilter.completed:
        todos = todos.where((todo) => todo.completed).toList();
        break;
      case TodoFilter.pending:
        todos = todos.where((todo) => !todo.completed).toList();
        break;
      case TodoFilter.highPriority:
        todos = todos.where((todo) => todo.priority == TodoPriority.high).toList();
        break;
      case TodoFilter.work:
        todos = todos.where((todo) => todo.category == TodoCategory.work).toList();
        break;
      case TodoFilter.personal:
        todos = todos.where((todo) => todo.category == TodoCategory.personal).toList();
        break;
      case TodoFilter.all:
      default:
        break;
    }

    // Apply sort
    switch (sort) {
      case TodoSort.newest:
        todos.sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
        break;
      case TodoSort.oldest:
        todos.sort((a, b) => (a.createdAt ?? DateTime.now()).compareTo(b.createdAt ?? DateTime.now()));
        break;
      case TodoSort.priority:
        todos.sort((a, b) => b.priority.sortOrder.compareTo(a.priority.sortOrder));
        break;
      case TodoSort.alphabetical:
        todos.sort((a, b) => a.todo.toLowerCase().compareTo(b.todo.toLowerCase()));
        break;
      case TodoSort.completion:
        todos.sort((a, b) => a.completed ? 1 : -1);
        break;
    }

    return todos;
  }
}

class TodosError extends TodosState {
  final String message;

  const TodosError(this.message);

  @override
  List<Object?> get props => [message];
}

// Enums for filtering and sorting
enum TodoFilter {
  all,
  completed,
  pending,
  highPriority,
  work,
  personal,
}

enum TodoSort {
  newest,
  oldest,
  priority,
  alphabetical,
  completion,
}
