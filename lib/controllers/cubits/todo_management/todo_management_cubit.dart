// lib/cubits/todo_management/todo_management_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dummy_connect/model/todo_model.dart';
import 'package:dummy_connect/service/todo_service.dart';
import 'package:dummy_connect/controllers/cubits/todos/todo_cubit.dart';
import 'package:dummy_connect/controllers/cubits/todos/todo_state.dart';
import 'todo_management_state.dart';

class TodoManagementCubit extends Cubit<TodoManagementState> {
  final TodoService _todoService;
  final TodosCubit _todosCubit;

  TodoManagementCubit(this._todoService, this._todosCubit) : super(TodoManagementInitial());

  // Create new todo
  Future<void> createTodo({
    required String todoText,
    required int userId,
  }) async {
    try {
      emit(TodoManagementLoading());
      
      final newTodo = await _todoService.createTodo(
        todo: todoText,
        userId: userId,
      );
      
      emit(TodoManagementSuccess(
        todo: newTodo,
        message: 'Todo created successfully',
      ));
      
      // Refresh the todos list
      await _todosCubit.refreshTodos(userId);
    } catch (e) {
      emit(TodoManagementError('Failed to create todo: ${e.toString()}'));
    }
  }

  // Update todo
  Future<void> updateTodo({
    required int todoId,
    required String todoText,
    bool? completed,
  }) async {
    try {
      emit(TodoManagementLoading());
      
      final updatedTodo = await _todoService.updateTodo(
        id: todoId,
        todo: todoText,
        completed: completed,
      );
      
      emit(TodoManagementSuccess(
        todo: updatedTodo,
        message: 'Todo updated successfully',
      ));
      
      // Update the todos list locally
      _updateTodoInList(updatedTodo);
    } catch (e) {
      emit(TodoManagementError('Failed to update todo: ${e.toString()}'));
    }
  }

  // Toggle todo completion
  Future<void> toggleTodoCompletion(Todo todo) async {
    try {
      // Optimistically update UI
      final optimisticTodo = todo.toggleCompleted();
      _updateTodoInList(optimisticTodo);
      
      final updatedTodo = await _todoService.updateTodo(
        id: todo.id,
        completed: !todo.completed,
      );
      
      emit(TodoManagementSuccess(
        todo: updatedTodo,
        message: updatedTodo.completed ? 'Todo completed!' : 'Todo marked as pending',
      ));
      
      // Update with actual response
      _updateTodoInList(updatedTodo);
    } catch (e) {
      // Revert optimistic update
      _updateTodoInList(todo);
      emit(TodoManagementError('Failed to update todo: ${e.toString()}'));
    }
  }

  // Delete todo
  Future<void> deleteTodo(int todoId, int userId) async {
    try {
      emit(TodoManagementLoading());
      
      await _todoService.deleteTodo(todoId);
      
      emit(TodoManagementSuccess(
        todo: Todo(id: todoId, todo: '', completed: false, userId: userId),
        message: 'Todo deleted successfully',
      ));
      
      // Refresh the todos list
      await _todosCubit.refreshTodos(userId);
    } catch (e) {
      emit(TodoManagementError('Failed to delete todo: ${e.toString()}'));
    }
  }

  // Helper method to update todo in the current list
  void _updateTodoInList(Todo updatedTodo) {
    final currentState = _todosCubit.state;
    if (currentState is TodosLoaded) {
      final updatedTodos = currentState.todosResponse.todos
          .map((todo) => todo.id == updatedTodo.id ? updatedTodo : todo)
          .toList();
      
      final updatedResponse = TodosResponse(
        todos: updatedTodos,
        total: currentState.todosResponse.total,
        skip: currentState.todosResponse.skip,
        limit: currentState.todosResponse.limit,
      );
      
      _todosCubit.emit(currentState.copyWith(todosResponse: updatedResponse));
    }
  }

  // Reset state
  void reset() {
    emit(TodoManagementInitial());
  }
}
