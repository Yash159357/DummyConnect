// lib/repositories/user_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dummy_connect/model/user_model.dart';
import 'package:dummy_connect/model/post_model.dart';
import 'package:dummy_connect/model/todo_model.dart';

class UserService {
  static const String _baseUrl = 'https://dummyjson.com';
  
  // Fetch users with pagination
  Future<Map<String, dynamic>> getUsers({
    int limit = 20,
    int skip = 0,
    String? search,
  }) async {
    try {
      String url = '$_baseUrl/users?limit=$limit&skip=$skip';
      
      if (search != null && search.isNotEmpty) {
        url = '$_baseUrl/users/search?q=$search&limit=$limit&skip=$skip';
      }
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'users': (data['users'] as List)
              .map((json) => User.fromJson(json))
              .toList(),
          'total': data['total'],
          'skip': data['skip'],
          'limit': data['limit'],
        };
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  // Fetch user by ID
  Future<User> getUserById(int userId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/users/$userId'));
      
      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  // Fetch user posts
  Future<List<Post>> getUserPosts(int userId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/posts/user/$userId'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['posts'] as List)
            .map((json) => Post.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  // Fetch user todos
  Future<List<Todo>> getUserTodos(int userId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/todos/user/$userId'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['todos'] as List)
            .map((json) => Todo.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load todos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}