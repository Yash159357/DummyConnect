import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dummy_connect/model/post_model.dart';
import 'package:dummy_connect/controllers/cubits/post_create/post_create_state.dart';
// Cubit
class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  void initializeForm() {
    emit(const PostFormState());
  }

  void updateTitle(String title) {
    if (state is PostFormState) {
      final currentState = state as PostFormState;
      final newState = currentState.copyWith(
        title: title,
        isValid: title.trim().isNotEmpty && currentState.body.trim().isNotEmpty,
      );
      emit(newState);
    }
  }

  void updateBody(String body) {
    if (state is PostFormState) {
      final currentState = state as PostFormState;
      final newState = currentState.copyWith(
        body: body,
        isValid: body.trim().isNotEmpty && currentState.title.trim().isNotEmpty,
      );
      emit(newState);
    }
  }

  Future<void> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    if (title.trim().isEmpty || body.trim().isEmpty) {
      emit(const PostError('Title and body cannot be empty'));
      return;
    }

    emit(PostCreating());

    try {
      // Simulate network delay for local post creation
      await Future.delayed(const Duration(milliseconds: 500));
      
      final post = Post.createLocal(
        title: title.trim(),
        body: body.trim(),
        userId: userId,
      );

      emit(PostCreated(post));
    } catch (e) {
      emit(PostError('Failed to create post: $e'));
    }
  }

  void resetForm() {
    emit(const PostFormState());
  }

  void resetToInitial() {
    emit(PostInitial());
  }
}