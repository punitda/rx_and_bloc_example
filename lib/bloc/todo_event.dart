part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent extends Equatable {
  const TodoEvent();
}

class GetTodosEvent extends TodoEvent {
  const GetTodosEvent();
  @override
  List<Object> get props => [];
}

class RefreshTodosEvent extends TodoEvent {
  const RefreshTodosEvent();
  @override
  List<Object> get props => [];
}
