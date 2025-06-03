
// lib/cubits/todo_management/todo_management_state.dart
import 'package:equatable/equatable.dart';
import 'package:dummy_connect/model/todo_model.dart';

abstract class TodoManagementState extends Equatable {
  const TodoManagementState();

  @override
  List<Object?> get props => [];
}

class TodoManagementInitial extends TodoManagementState {}

class TodoManagementLoading extends TodoManagementState {}

class TodoManagementSuccess extends TodoManagementState {
  final Todo todo;
  final String message;

  const TodoManagementSuccess({required this.todo, required this.message});

  @override
  List<Object?> get props => [todo, message];
}

class TodoManagementError extends TodoManagementState {
  final String message;

  const TodoManagementError(this.message);

  @override
  List<Object?> get props => [message];
}
