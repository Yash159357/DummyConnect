import 'package:equatable/equatable.dart';
import 'package:dummy_connect/model/user_model.dart';
// States
abstract class UserListState extends Equatable {
  const UserListState();

  @override
  List<Object?> get props => [];
}

class UserListInitial extends UserListState {}

class UserListLoading extends UserListState {}

class UserListLoaded extends UserListState {
  final List<User> users;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final String? searchQuery;
  final int total;

  const UserListLoaded({
    required this.users,
    required this.hasReachedMax,
    this.isLoadingMore = false,
    this.searchQuery,
    required this.total,
  });

  UserListLoaded copyWith({
    List<User>? users,
    bool? hasReachedMax,
    bool? isLoadingMore,
    String? searchQuery,
    int? total,
  }) {
    return UserListLoaded(
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchQuery: searchQuery ?? this.searchQuery,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props => [users, hasReachedMax, isLoadingMore, searchQuery, total];
}

class UserListError extends UserListState {
  final String message;
  final List<User> users; // Keep existing users when error occurs during pagination

  const UserListError({
    required this.message,
    this.users = const [],
  });

  @override
  List<Object?> get props => [message, users];
}
