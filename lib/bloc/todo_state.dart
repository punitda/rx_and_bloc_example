part of 'todo_bloc.dart';

enum TodoStatus { initial, loading, error, success }

class TodoState extends Equatable {
  const TodoState._({
    this.todos,
    this.errorMessage = '',
    this.status = TodoStatus.initial,
  });

  final List<Todo> todos;
  final String errorMessage;
  final TodoStatus status;

  const TodoState.initial() : this._();

  const TodoState.loading() : this._(status: TodoStatus.loading);

  const TodoState.error(String errorMessage)
      : this._(errorMessage: errorMessage, status: TodoStatus.error);

  const TodoState.success(List<Todo> todos)
      : this._(todos: todos, status: TodoStatus.success);

  @override
  List<Object> get props => [todos, errorMessage, status];
}
