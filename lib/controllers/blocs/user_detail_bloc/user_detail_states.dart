import 'package:equatable/equatable.dart';
import 'package:dummy_connect/model/user_model.dart';
import 'package:dummy_connect/model/post_model.dart';
import 'package:dummy_connect/model/todo_model.dart';
// States
abstract class UserDetailState extends Equatable {
  const UserDetailState();

  @override
  List<Object?> get props => [];
}

class UserDetailInitial extends UserDetailState {}

class UserDetailLoading extends UserDetailState {}

class UserDetailLoaded extends UserDetailState {
  final User user;
  final List<Post> posts;
  final List<Todo> todos;
  final bool isLoadingPosts;
  final bool isLoadingTodos;
  final String? postsError;
  final String? todosError;

  const UserDetailLoaded({
    required this.user,
    this.posts = const [],
    this.todos = const [],
    this.isLoadingPosts = false,
    this.isLoadingTodos = false,
    this.postsError,
    this.todosError,
  });

  UserDetailLoaded copyWith({
    User? user,
    List<Post>? posts,
    List<Todo>? todos,
    bool? isLoadingPosts,
    bool? isLoadingTodos,
    String? postsError,
    String? todosError,
  }) {
    return UserDetailLoaded(
      user: user ?? this.user,
      posts: posts ?? this.posts,
      todos: todos ?? this.todos,
      isLoadingPosts: isLoadingPosts ?? this.isLoadingPosts,
      isLoadingTodos: isLoadingTodos ?? this.isLoadingTodos,
      postsError: postsError ?? this.postsError,
      todosError: todosError ?? this.todosError,
    );
  }

  @override
  List<Object?> get props => [
        user,
        posts,
        todos,
        isLoadingPosts,
        isLoadingTodos,
        postsError,
        todosError,
      ];
}

class UserDetailError extends UserDetailState {
  final String message;
  
  const UserDetailError(this.message);
  
  @override
  List<Object?> get props => [message];
}
