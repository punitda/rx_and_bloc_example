import 'package:bloc_rx_app/bloc/todo_bloc.dart';
import 'package:bloc_rx_app/todo.dart';
import 'package:bloc_rx_app/todo_service.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTodoService extends Mock implements TodoService {}

void main() {
  group(
    'TodoBloc',
    () {
      TodoService todoService;
      final cachedTodos = <Todo>[
        Todo(id: 1, title: 'Title #1', description: 'Description #1'),
        Todo(id: 2, title: 'Title #2', description: 'Description #2'),
        Todo(id: 3, title: 'Title #3', description: 'Description #3'),
      ];

      // Same Todos as we've in cache(not updated)
      final networkTodos = <Todo>[
        Todo(id: 1, title: 'Title #1', description: 'Description #1'),
        Todo(id: 2, title: 'Title #2', description: 'Description #2'),
        Todo(id: 3, title: 'Title #3', description: 'Description #3'),
      ];

      // Description of todos have been updated and cache is stale
      final updatedNetworkTodos = <Todo>[
        Todo(id: 1, title: 'Title #1', description: 'Description #11'),
        Todo(id: 2, title: 'Title #2', description: 'Description #22'),
        Todo(id: 3, title: 'Title #3', description: 'Description #33'),
      ];

      setUp(() {
        todoService = MockTodoService();
      });

      blocTest<TodoBloc, TodoState>(
        'emits [TodoState.loading], [TodoState.success] when cache and network todos emit same List<Todos>',
        build: () {
          return TodoBloc(service: todoService);
        },
        act: (bloc) => bloc.add(GetTodosEvent()),
        verify: (_) {
          verify(todoService.todos()).called(1);
        },
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoState.loading], [TodoState.success] when cache and network todos emit same List<Todos>',
        build: () {
          when(todoService.todos()).thenAnswer((_) async* {
            yield cachedTodos;
            yield networkTodos;
          });
          return TodoBloc(service: todoService);
        },
        act: (bloc) => bloc.add(GetTodosEvent()),
        expect: [
          TodoState.loading(),
          TodoState.success(cachedTodos),
        ],
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoState.loading], [TodoState.success] x 2 when cache and network return different List<Todos>',
        build: () {
          when(todoService.todos()).thenAnswer((_) async* {
            yield cachedTodos;
            yield updatedNetworkTodos;
          });
          return TodoBloc(service: todoService);
        },
        act: (bloc) => bloc.add(GetTodosEvent()),
        expect: [
          TodoState.loading(),
          TodoState.success(cachedTodos),
          TodoState.success(updatedNetworkTodos),
        ],
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoState.loading], [TodoState.success] when cache returns List<Todos> but network call fails',
        build: () {
          when(todoService.todos()).thenAnswer((_) async* {
            yield cachedTodos;
            throw Exception('Network error occurred');
          });
          return TodoBloc(service: todoService);
        },
        act: (bloc) => bloc.add(GetTodosEvent()),
        expect: [
          TodoState.loading(),
          TodoState.success(cachedTodos),
        ],
      );
    },
  );
}
