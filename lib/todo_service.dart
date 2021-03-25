import 'dart:math';

import 'package:bloc_rx_app/todo.dart';

abstract class TodoService {
  Stream<List<Todo>> todos();
}

class TodoServiceImpl extends TodoService {
  Stream<List<Todo>> todos() async* {
    final todos = <Todo>[];
    for (int i = 1; i <= 50; i++) {
      final todo = Todo(
        id: i,
        title: 'Title : $i',
        description: 'Description : $i',
      );
      todos.add(todo);

      if (i % 5 == 0) {
        yield todos;
      }
      if (i == 9 && Random().nextInt(10) == 1) {
        throw Exception('This is not cool!');
      }
    }
  }
}
