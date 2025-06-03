
// lib/cubits/todo_form/todo_form_state.dart
import 'package:equatable/equatable.dart';

class TodoFormState extends Equatable {
  final String todoText;
  final bool isValid;
  final String? errorMessage;

  const TodoFormState({
    this.todoText = '',
    this.isValid = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [todoText, isValid, errorMessage];

  TodoFormState copyWith({
    String? todoText,
    bool? isValid,
    String? errorMessage,
  }) {
    return TodoFormState(
      todoText: todoText ?? this.todoText,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
