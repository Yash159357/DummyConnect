// lib/services/todo_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dummy_connect/model/todo_model.dart';

class TodoService {
  static const String _baseUrl = 'https://dummyjson.com';
  
  // Headers for API requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
  };

  /// Get todos for a specific user with pagination
  Future<TodosResponse> getUserTodos(
    int userId, {
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/todos/user/$userId?skip=$skip&limit=$limit');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TodosResponse.fromJson(data);
      } else {
        throw Exception('Failed to load todos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user todos: $e');
    }
  }

  /// Get all todos with pagination
  Future<TodosResponse> getAllTodos({
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/todos?skip=$skip&limit=$limit');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TodosResponse.fromJson(data);
      } else {
        throw Exception('Failed to load todos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching todos: $e');
    }
  }

  /// Get a single todo by ID
  Future<Todo> getTodoById(int id) async {
    try {
      final url = Uri.parse('$_baseUrl/todos/$id');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Todo.fromJson(data);
      } else {
        throw Exception('Failed to load todo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching todo: $e');
    }
  }

  /// Create a new todo
  Future<Todo> createTodo({
    required String todo,
    required int userId,
    bool completed = false,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/todos/add');
      final body = json.encode({
        'todo': todo,
        'completed': completed,
        'userId': userId,
      });

      final response = await http.post(
        url,
        headers: _headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return Todo.fromJson(data);
      } else {
        throw Exception('Failed to create todo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating todo: $e');
    }
  }

  /// Update an existing todo
  Future<Todo> updateTodo({
    required int id,
    String? todo,
    bool? completed,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/todos/$id');
      final Map<String, dynamic> updateData = {};
      
      if (todo != null) updateData['todo'] = todo;
      if (completed != null) updateData['completed'] = completed;

      final body = json.encode(updateData);

      final response = await http.put(
        url,
        headers: _headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Todo.fromJson(data);
      } else {
        throw Exception('Failed to update todo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating todo: $e');
    }
  }

  /// Delete a todo
  Future<bool> deleteTodo(int id) async {
    try {
      final url = Uri.parse('$_baseUrl/todos/$id');
      final response = await http.delete(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['isDeleted'] == true;
      } else {
        throw Exception('Failed to delete todo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting todo: $e');
    }
  }

  /// Search todos by text
  Future<TodosResponse> searchTodos({
    required String query,
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/todos/search?q=$query&skip=$skip&limit=$limit');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TodosResponse.fromJson(data);
      } else {
        throw Exception('Failed to search todos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching todos: $e');
    }
  }

  /// Bulk update todos (for batch operations)
  Future<List<Todo>> updateMultipleTodos(List<Map<String, dynamic>> updates) async {
    try {
      final List<Todo> updatedTodos = [];
      
      for (final update in updates) {
        final id = update['id'] as int;
        final todo = update['todo'] as String?;
        final completed = update['completed'] as bool?;
        
        final updatedTodo = await updateTodo(
          id: id,
          todo: todo,
          completed: completed,
        );
        
        updatedTodos.add(updatedTodo);
      }
      
      return updatedTodos;
    } catch (e) {
      throw Exception('Error updating multiple todos: $e');
    }
  }

  /// Toggle todo completion status
  Future<Todo> toggleTodoCompletion(int id) async {
    try {
      // First get the current todo to know its completion status
      final currentTodo = await getTodoById(id);
      
      // Then update with opposite completion status
      return await updateTodo(
        id: id,
        completed: !currentTodo.completed,
      );
    } catch (e) {
      throw Exception('Error toggling todo completion: $e');
    }
  }

  /// Get todos statistics for a user
  Future<Map<String, dynamic>> getTodosStatistics(int userId) async {
    try {
      final todosResponse = await getUserTodos(userId, limit: 1000); // Get all todos
      final todos = todosResponse.todos;
      
      final completed = todos.where((todo) => todo.completed).length;
      final pending = todos.length - completed;
      final completionRate = todos.isNotEmpty ? (completed / todos.length) * 100 : 0.0;
      
      return {
        'total': todos.length,
        'completed': completed,
        'pending': pending,
        'completionRate': completionRate,
      };
    } catch (e) {
      throw Exception('Error getting todos statistics: $e');
    }
  }
}