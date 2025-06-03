import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dummy_connect/service/user_service.dart';
import 'package:dummy_connect/controllers/blocs/user_detail_bloc/user_detail_events.dart';
import 'package:dummy_connect/controllers/blocs/user_detail_bloc/user_detail_states.dart';

// BLoC
class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final UserService userRepository;

  UserDetailBloc({required this.userRepository}) : super(UserDetailInitial()) {
    on<LoadUserDetail>(_onLoadUserDetail);
    on<LoadUserPosts>(_onLoadUserPosts);
    on<LoadUserTodos>(_onLoadUserTodos);
    on<RefreshUserDetail>(_onRefreshUserDetail);
  }

  Future<void> _onLoadUserDetail(LoadUserDetail event, Emitter<UserDetailState> emit) async {
    emit(UserDetailLoading());

    try {
      final user = await userRepository.getUserById(event.userId);
      
      emit(UserDetailLoaded(
        user: user,
        isLoadingPosts: true,
        isLoadingTodos: true,
      ));

      // Load posts and todos concurrently
      add(LoadUserPosts(event.userId));
      add(LoadUserTodos(event.userId));
      
    } catch (e) {
      emit(UserDetailError(e.toString()));
    }
  }

  Future<void> _onLoadUserPosts(LoadUserPosts event, Emitter<UserDetailState> emit) async {
    if (state is UserDetailLoaded) {
      final currentState = state as UserDetailLoaded;
      
      try {
        final posts = await userRepository.getUserPosts(event.userId);
        
        emit(currentState.copyWith(
          posts: posts,
          isLoadingPosts: false,
          postsError: null,
        ));
      } catch (e) {
        emit(currentState.copyWith(
          isLoadingPosts: false,
          postsError: e.toString(),
        ));
      }
    }
  }

  Future<void> _onLoadUserTodos(LoadUserTodos event, Emitter<UserDetailState> emit) async {
    if (state is UserDetailLoaded) {
      final currentState = state as UserDetailLoaded;
      
      try {
        final todos = await userRepository.getUserTodos(event.userId);
        
        emit(currentState.copyWith(
          todos: todos,
          isLoadingTodos: false,
          todosError: null,
        ));
      } catch (e) {
        emit(currentState.copyWith(
          isLoadingTodos: false,
          todosError: e.toString(),
        ));
      }
    }
  }

  Future<void> _onRefreshUserDetail(RefreshUserDetail event, Emitter<UserDetailState> emit) async {
    if (state is UserDetailLoaded) {
      final currentState = state as UserDetailLoaded;
      
      emit(currentState.copyWith(
        isLoadingPosts: true,
        isLoadingTodos: true,
        postsError: null,
        todosError: null,
      ));

      // Reload user data
      try {
        final user = await userRepository.getUserById(event.userId);
        emit(currentState.copyWith(user: user));
      } catch (e) {
        // Keep existing user data if refresh fails
      }

      // Reload posts and todos
      add(LoadUserPosts(event.userId));
      add(LoadUserTodos(event.userId));
    }
  }
}