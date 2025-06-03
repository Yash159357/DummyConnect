// lib/blocs/user_list/user_list_bloc.dart
import 'package:equatable/equatable.dart';

// Events
abstract class UserListEvent extends Equatable {
  const UserListEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends UserListEvent {
  final bool refresh;
  
  const LoadUsers({this.refresh = false});
  
  @override
  List<Object?> get props => [refresh];
}

class LoadMoreUsers extends UserListEvent {}

class SearchUsers extends UserListEvent {
  final String query;
  
  const SearchUsers(this.query);
  
  @override
  List<Object?> get props => [query];
}

class ClearSearch extends UserListEvent {}
