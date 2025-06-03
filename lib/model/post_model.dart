class Post {
  final int id;
  final String title;
  final String body;
  final int userId;
  final List<String> tags;
  final Reactions reactions;
  final int views;
  final DateTime? createdAt;
  final bool isLocal; // For locally created posts

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.tags,
    required this.reactions,
    required this.views,
    this.createdAt,
    this.isLocal = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      userId: json['userId'] ?? 0,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((tag) => tag.toString())
              .toList() ??
          [],
      reactions: Reactions.fromJson(json['reactions'] ?? {}),
      views: json['views'] ?? 0,
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt']) 
          : null,
      isLocal: json['isLocal'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'userId': userId,
      'tags': tags,
      'reactions': reactions.toJson(),
      'views': views,
      'createdAt': createdAt?.toIso8601String(),
      'isLocal': isLocal,
    };
  }

  // Factory constructor for creating local posts
  factory Post.createLocal({
    required String title,
    required String body,
    required int userId,
    List<String>? tags,
  }) {
    return Post(
      id: DateTime.now().millisecondsSinceEpoch, // Temporary local ID
      title: title,
      body: body,
      userId: userId,
      tags: tags ?? [],
      reactions: Reactions(likes: 0, dislikes: 0),
      views: 0,
      createdAt: DateTime.now(),
      isLocal: true,
    );
  }

  // Copy with method for updating posts
  Post copyWith({
    int? id,
    String? title,
    String? body,
    int? userId,
    List<String>? tags,
    Reactions? reactions,
    int? views,
    DateTime? createdAt,
    bool? isLocal,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      userId: userId ?? this.userId,
      tags: tags ?? this.tags,
      reactions: reactions ?? this.reactions,
      views: views ?? this.views,
      createdAt: createdAt ?? this.createdAt,
      isLocal: isLocal ?? this.isLocal,
    );
  }

  // Getters for UI display
  String get formattedViews {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M views';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K views';
    } else {
      return '$views views';
    }
  }

  String get excerpt {
    if (body.length <= 100) return body;
    return '${body.substring(0, 100)}...';
  }

  String get formattedDate {
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Post && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Post(id: $id, title: $title, userId: $userId)';
}

class Reactions {
  final int likes;
  final int dislikes;

  Reactions({
    required this.likes,
    required this.dislikes,
  });

  factory Reactions.fromJson(Map<String, dynamic> json) {
    return Reactions(
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'likes': likes,
      'dislikes': dislikes,
    };
  }

  // Getter for total reactions
  int get total => likes + dislikes;

  // Getter for formatted likes/dislikes
  String get formattedLikes {
    if (likes >= 1000000) {
      return '${(likes / 1000000).toStringAsFixed(1)}M';
    } else if (likes >= 1000) {
      return '${(likes / 1000).toStringAsFixed(1)}K';
    } else {
      return likes.toString();
    }
  }

  String get formattedDislikes {
    if (dislikes >= 1000000) {
      return '${(dislikes / 1000000).toStringAsFixed(1)}M';
    } else if (dislikes >= 1000) {
      return '${(dislikes / 1000).toStringAsFixed(1)}K';
    } else {
      return dislikes.toString();
    }
  }

  // Copy with method for updating reactions
  Reactions copyWith({
    int? likes,
    int? dislikes,
  }) {
    return Reactions(
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reactions &&
          runtimeType == other.runtimeType &&
          likes == other.likes &&
          dislikes == other.dislikes;

  @override
  int get hashCode => likes.hashCode ^ dislikes.hashCode;

  @override
  String toString() => 'Reactions(likes: $likes, dislikes: $dislikes)';
}

// Response wrapper for user posts
class PostsResponse {
  final List<Post> posts;
  final int total;
  final int skip;
  final int limit;

  PostsResponse({
    required this.posts,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory PostsResponse.fromJson(Map<String, dynamic> json) {
    return PostsResponse(
      posts: (json['posts'] as List<dynamic>?)
              ?.map((postJson) => Post.fromJson(postJson))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posts': posts.map((post) => post.toJson()).toList(),
      'total': total,
      'skip': skip,
      'limit': limit,
    };
  }

  // Helper methods
  bool get hasMore => skip + limit < total;
  int get nextSkip => skip + limit;
}