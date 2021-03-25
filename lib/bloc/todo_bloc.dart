import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_rx_app/todo.dart';
import 'package:bloc_rx_app/todo_service.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoService _service;
  TodoBloc({@required TodoService service})
      : _service = service,
        super(TodoState.initial());

  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    if (event is GetTodosEvent) {
      yield* _service
          .todos()
          .map<TodoState>((todos) => TodoState.success(todos))
          .onErrorReturnWith((err) => state.status == TodoStatus.success
              ? state // we emit last success state when we receive error from network
              : TodoState.error(err.message))
          .startWith(TodoState.loading());
    }
  }
}
