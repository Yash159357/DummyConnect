// lib/blocs/post_creation/post_cubit.dart
import 'package:equatable/equatable.dart';
import 'package:dummy_connect/model/post_model.dart';

// States
abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostCreating extends PostState {}

class PostCreated extends PostState {
  final Post post;
  
  const PostCreated(this.post);
  
  @override
  List<Object?> get props => [post];
}

class PostError extends PostState {
  final String message;
  
  const PostError(this.message);
  
  @override
  List<Object?> get props => [message];
}

class PostFormState extends PostState {
  final String title;
  final String body;
  final bool isValid;
  
  const PostFormState({
    this.title = '',
    this.body = '',
    this.isValid = false,
  });
  
  PostFormState copyWith({
    String? title,
    String? body,
    bool? isValid,
  }) {
    return PostFormState(
      title: title ?? this.title,
      body: body ?? this.body,
      isValid: isValid ?? this.isValid,
    );
  }
  
  @override
  List<Object?> get props => [title, body, isValid];
}
