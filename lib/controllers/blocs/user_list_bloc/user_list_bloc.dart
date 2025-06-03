import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dummy_connect/model/user_model.dart';
import 'package:dummy_connect/service/user_service.dart';
import 'package:dummy_connect/controllers/blocs/user_list_bloc/user_list_event.dart';
import 'package:dummy_connect/controllers/blocs/user_list_bloc/user_list_states.dart';

// BLoC
class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final UserService userRepository;
  static const int _limit = 20;

  UserListBloc({required this.userRepository}) : super(UserListInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<LoadMoreUsers>(_onLoadMoreUsers);
    on<SearchUsers>(_onSearchUsers);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserListState> emit) async {
    if (event.refresh && state is UserListLoaded) {
      emit((state as UserListLoaded).copyWith(isLoadingMore: false));
    } else {
      emit(UserListLoading());
    }

    try {
      final result = await userRepository.getUsers(limit: _limit, skip: 0);
      final users = result['users'] as List<User>;
      final total = result['total'] as int;

      emit(UserListLoaded(
        users: users,
        hasReachedMax: users.length >= total,
        total: total,
      ));
    } catch (e) {
      emit(UserListError(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreUsers(LoadMoreUsers event, Emitter<UserListState> emit) async {
    if (state is UserListLoaded) {
      final currentState = state as UserListLoaded;
      
      if (currentState.hasReachedMax || currentState.isLoadingMore) return;

      emit(currentState.copyWith(isLoadingMore: true));

      try {
        final result = await userRepository.getUsers(
          limit: _limit,
          skip: currentState.users.length,
          search: currentState.searchQuery,
        );
        
        final newUsers = result['users'] as List<User>;
        final total = result['total'] as int;
        final allUsers = [...currentState.users, ...newUsers];

        emit(UserListLoaded(
          users: allUsers,
          hasReachedMax: allUsers.length >= total,
          searchQuery: currentState.searchQuery,
          total: total,
        ));
      } catch (e) {
        emit(UserListError(
          message: e.toString(),
          users: currentState.users,
        ));
      }
    }
  }

  Future<void> _onSearchUsers(SearchUsers event, Emitter<UserListState> emit) async {
    emit(UserListLoading());

    try {
      final result = await userRepository.getUsers(
        limit: _limit,
        skip: 0,
        search: event.query,
      );
      
      final users = result['users'] as List<User>;
      final total = result['total'] as int;

      emit(UserListLoaded(
        users: users,
        hasReachedMax: users.length >= total,
        searchQuery: event.query,
        total: total,
      ));
    } catch (e) {
      emit(UserListError(message: e.toString()));
    }
  }

  Future<void> _onClearSearch(ClearSearch event, Emitter<UserListState> emit) async {
    add(const LoadUsers(refresh: true));
  }
}