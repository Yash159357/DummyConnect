import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dummy_connect/model/post_model.dart';

class PostService {
  static const String _baseUrl = "https://dummyjson.com";
  
  // Fetch posts for a specific user
  Future<List<Post>> getUserPosts(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/posts/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> postsJson = data['posts'] ?? [];
        
        return postsJson.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user posts: $e');
    }
  }

  // Fetch all posts with pagination
  Future<Map<String, dynamic>> getAllPosts({
    int limit = 10,
    int skip = 0,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/posts?limit=$limit&skip=$skip'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> postsJson = data['posts'] ?? [];
        final List<Post> posts = postsJson.map((json) => Post.fromJson(json)).toList();
        
        return {
          'posts': posts,
          'total': data['total'] ?? 0,
          'skip': data['skip'] ?? 0,
          'limit': data['limit'] ?? limit,
        };
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  // Search posts by title/content
  Future<List<Post>> searchPosts(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/posts/search?q=${Uri.encodeComponent(query)}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> postsJson = data['posts'] ?? [];
        
        return postsJson.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching posts: $e');
    }
  }

  // Get a single post by ID
  Future<Post> getPostById(int postId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/posts/$postId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Post.fromJson(data);
      } else {
        throw Exception('Failed to load post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching post: $e');
    }
  }

  // Create a new post (this will be simulated since it's for local creation)
  Future<Post> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      final postData = {
        'title': title,
        'body': body,
        'userId': userId,
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/posts/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(postData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return Post.fromJson(data);
      } else {
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      // If API fails, create a local post as fallback
      return Post.createLocal(
        title: title,
        body: body,
        userId: userId,
      );
    }
  }

  // Update an existing post
  Future<Post> updatePost({
    required int postId,
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      final postData = {
        'title': title,
        'body': body,
        'userId': userId,
      };

      final response = await http.put(
        Uri.parse('$_baseUrl/posts/$postId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(postData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Post.fromJson(data);
      } else {
        throw Exception('Failed to update post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating post: $e');
    }
  }

  // Delete a post
  Future<bool> deletePost(int postId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/posts/$postId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['isDeleted'] ?? false;
      } else {
        throw Exception('Failed to delete post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting post: $e');
    }
  }
}