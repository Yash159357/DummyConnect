// lib/blocs/user_detail/user_detail_bloc.dart
import 'package:equatable/equatable.dart';

// Events
abstract class UserDetailEvent extends Equatable {
  const UserDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserDetail extends UserDetailEvent {
  final int userId;
  
  const LoadUserDetail(this.userId);
  
  @override
  List<Object?> get props => [userId];
}

class LoadUserPosts extends UserDetailEvent {
  final int userId;
  
  const LoadUserPosts(this.userId);
  
  @override
  List<Object?> get props => [userId];
}

class LoadUserTodos extends UserDetailEvent {
  final int userId;
  
  const LoadUserTodos(this.userId);
  
  @override
  List<Object?> get props => [userId];
}

class RefreshUserDetail extends UserDetailEvent {
  final int userId;
  
  const RefreshUserDetail(this.userId);
  
  @override
  List<Object?> get props => [userId];
}
