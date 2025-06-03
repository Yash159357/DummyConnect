// lib/cubits/todo_form/todo_form_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'todo_form_state.dart';

class TodoFormCubit extends Cubit<TodoFormState> {
  TodoFormCubit() : super(const TodoFormState());

  void updateTodoText(String text) {
    final trimmedText = text.trim();
    var isValid = trimmedText.isNotEmpty && trimmedText.length >= 3;
    
    String? errorMessage;
    if (trimmedText.isEmpty) {
      errorMessage = 'Todo cannot be empty';
    } else if (trimmedText.length < 3) {
      errorMessage = 'Todo must be at least 3 characters long';
    } else if (trimmedText.length > 200) {
      errorMessage = 'Todo must be less than 200 characters';
      isValid = false;
    }

    emit(state.copyWith(
      todoText: text,
      isValid: isValid,
      errorMessage: errorMessage,
    ));
  }

  void reset() {
    emit(const TodoFormState());
  }

  bool get canSubmit => state.isValid && state.todoText.trim().isNotEmpty;
}