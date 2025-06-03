// lib/models/todo.dart
class Todo {
  final int id;
  final String todo;
  final bool completed;
  final int userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Todo({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] ?? 0,
      todo: json['todo'] ?? '',
      completed: json['completed'] ?? false,
      userId: json['userId'] ?? 0,
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.tryParse(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo': todo,
      'completed': completed,
      'userId': userId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Copy with method for updating todos
  Todo copyWith({
    int? id,
    String? todo,
    bool? completed,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      todo: todo ?? this.todo,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Toggle completion status
  Todo toggleCompleted() {
    return copyWith(
      completed: !completed,
      updatedAt: DateTime.now(),
    );
  }

  // Getters for UI display
  String get formattedCreatedDate {
    if (createdAt == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(createdAt!);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  String get formattedUpdatedDate {
    if (updatedAt == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(updatedAt!);
    
    if (difference.inDays > 365) {
      return 'Updated ${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return 'Updated ${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return 'Updated ${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return 'Updated ${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return 'Updated ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just updated';
    }
  }

  // Priority based on todo content (basic keyword detection)
  TodoPriority get priority {
    final lowerTodo = todo.toLowerCase();
    
    if (lowerTodo.contains('urgent') || 
        lowerTodo.contains('asap') || 
        lowerTodo.contains('emergency') ||
        lowerTodo.contains('critical')) {
      return TodoPriority.high;
    } else if (lowerTodo.contains('important') || 
               lowerTodo.contains('priority') ||
               lowerTodo.contains('must')) {
      return TodoPriority.medium;
    } else {
      return TodoPriority.low;
    }
  }

  // Category based on todo content (basic keyword detection)
  TodoCategory get category {
    final lowerTodo = todo.toLowerCase();
    
    if (lowerTodo.contains('work') || 
        lowerTodo.contains('meeting') || 
        lowerTodo.contains('project') ||
        lowerTodo.contains('office') ||
        lowerTodo.contains('client')) {
      return TodoCategory.work;
    } else if (lowerTodo.contains('personal') || 
               lowerTodo.contains('home') ||
               lowerTodo.contains('family') ||
               lowerTodo.contains('self')) {
      return TodoCategory.personal;
    } else if (lowerTodo.contains('shop') || 
               lowerTodo.contains('buy') ||
               lowerTodo.contains('purchase') ||
               lowerTodo.contains('store')) {
      return TodoCategory.shopping;
    } else if (lowerTodo.contains('health') || 
               lowerTodo.contains('doctor') ||
               lowerTodo.contains('medicine') ||
               lowerTodo.contains('exercise') ||
               lowerTodo.contains('gym')) {
      return TodoCategory.health;
    } else {
      return TodoCategory.other;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Todo(id: $id, todo: $todo, completed: $completed, userId: $userId)';
}

// Enums for better todo organization
enum TodoPriority {
  low,
  medium,
  high;

  String get displayName {
    switch (this) {
      case TodoPriority.low:
        return 'Low';
      case TodoPriority.medium:
        return 'Medium';
      case TodoPriority.high:
        return 'High';
    }
  }

  int get sortOrder {
    switch (this) {
      case TodoPriority.high:
        return 3;
      case TodoPriority.medium:
        return 2;
      case TodoPriority.low:
        return 1;
    }
  }
}

enum TodoCategory {
  work,
  personal,
  shopping,
  health,
  other;

  String get displayName {
    switch (this) {
      case TodoCategory.work:
        return 'Work';
      case TodoCategory.personal:
        return 'Personal';
      case TodoCategory.shopping:
        return 'Shopping';
      case TodoCategory.health:
        return 'Health';
      case TodoCategory.other:
        return 'Other';
    }
  }

  String get emoji {
    switch (this) {
      case TodoCategory.work:
        return '💼';
      case TodoCategory.personal:
        return '🏠';
      case TodoCategory.shopping:
        return '🛒';
      case TodoCategory.health:
        return '🏥';
      case TodoCategory.other:
        return '📝';
    }
  }
}

// Response wrapper for user todos
class TodosResponse {
  final List<Todo> todos;
  final int total;
  final int skip;
  final int limit;

  TodosResponse({
    required this.todos,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory TodosResponse.fromJson(Map<String, dynamic> json) {
    return TodosResponse(
      todos: (json['todos'] as List<dynamic>?)
              ?.map((todoJson) => Todo.fromJson(todoJson))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todos': todos.map((todo) => todo.toJson()).toList(),
      'total': total,
      'skip': skip,
      'limit': limit,
    };
  }

  // Helper methods
  bool get hasMore => skip + limit < total;
  int get nextSkip => skip + limit;

  // Statistics methods
  int get completedCount => todos.where((todo) => todo.completed).length;
  int get pendingCount => todos.where((todo) => !todo.completed).length;
  double get completionPercentage => 
      todos.isEmpty ? 0.0 : (completedCount / todos.length) * 100;

  // Filtering methods
  List<Todo> get completedTodos => todos.where((todo) => todo.completed).toList();
  List<Todo> get pendingTodos => todos.where((todo) => !todo.completed).toList();
  
  List<Todo> getByPriority(TodoPriority priority) =>
      todos.where((todo) => todo.priority == priority).toList();
  
  List<Todo> getByCategory(TodoCategory category) =>
      todos.where((todo) => todo.category == category).toList();

  // Sorting methods
  List<Todo> get sortedByPriority => 
      List<Todo>.from(todos)..sort((a, b) => b.priority.sortOrder.compareTo(a.priority.sortOrder));
  
  List<Todo> get sortedByCompletion => 
      List<Todo>.from(todos)..sort((a, b) => a.completed ? 1 : -1);
}