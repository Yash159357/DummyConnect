// lib/cubits/todos/todos_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dummy_connect/model/todo_model.dart';
import 'package:dummy_connect/service/todo_service.dart';
import 'package:dummy_connect/controllers/cubits/todos/todo_state.dart';

class TodosCubit extends Cubit<TodosState> {
  final TodoService _todoService;

  TodosCubit(this._todoService) : super(TodosInitial());

  // Load todos for a user
  Future<void> loadTodos(int userId, {int skip = 0, int limit = 20}) async {
    try {
      emit(TodosLoading());
      final todosResponse = await _todoService.getUserTodos(userId, skip: skip, limit: limit);
      emit(TodosLoaded(todosResponse: todosResponse));
    } catch (e) {
      emit(TodosError('Failed to load todos: ${e.toString()}'));
    }
  }

  // Load more todos (pagination)
  Future<void> loadMoreTodos(int userId) async {
    final currentState = state;
    if (currentState is TodosLoaded && currentState.todosResponse.hasMore) {
      try {
        final todosResponse = await _todoService.getUserTodos(
          userId,
          skip: currentState.todosResponse.nextSkip,
          limit: currentState.todosResponse.limit,
        );
        
        // Merge with existing todos
        final mergedTodos = [
          ...currentState.todosResponse.todos,
          ...todosResponse.todos,
        ];
        
        final mergedResponse = TodosResponse(
          todos: mergedTodos,
          total: todosResponse.total,
          skip: todosResponse.skip,
          limit: todosResponse.limit,
        );
        
        emit(currentState.copyWith(todosResponse: mergedResponse));
      } catch (e) {
        emit(TodosError('Failed to load more todos: ${e.toString()}'));
      }
    }
  }

  // Refresh todos
  Future<void> refreshTodos(int userId) async {
    final currentState = state;
    if (currentState is TodosLoaded) {
      await loadTodos(userId, limit: currentState.todosResponse.todos.length);
    } else {
      await loadTodos(userId);
    }
  }

  // Apply filter
  void applyFilter(TodoFilter filter) {
    final currentState = state;
    if (currentState is TodosLoaded) {
      emit(currentState.copyWith(filter: filter));
    }
  }

  // Apply sort
  void applySort(TodoSort sort) {
    final currentState = state;
    if (currentState is TodosLoaded) {
      emit(currentState.copyWith(sort: sort));
    }
  }

  // Clear all filters and sorts
  void clearFilters() {
    final currentState = state;
    if (currentState is TodosLoaded) {
      emit(currentState.copyWith(
        filter: TodoFilter.all,
        sort: TodoSort.newest,
      ));
    }
  }

  // Search todos
  void searchTodos(String query) {
    final currentState = state;
    if (currentState is TodosLoaded) {
      if (query.isEmpty) {
        // Reset to original todos
        emit(currentState);
        return;
      }

      final filteredTodos = currentState.todosResponse.todos
          .where((todo) => todo.todo.toLowerCase().contains(query.toLowerCase()))
          .toList();

      final searchResponse = TodosResponse(
        todos: filteredTodos,
        total: filteredTodos.length,
        skip: 0,
        limit: filteredTodos.length,
      );

      emit(currentState.copyWith(todosResponse: searchResponse));
    }
  }
}
