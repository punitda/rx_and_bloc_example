import 'package:bloc_rx_app/bloc/todo_bloc.dart';
import 'package:bloc_rx_app/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TodosPage(),
    );
  }
}

class TodosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            TodoBloc(service: TodoServiceImpl())..add(GetTodosEvent()),
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            switch (state.status) {
              case TodoStatus.initial:
              case TodoStatus.loading:
                return Center(
                  child: CircularProgressIndicator(
                    value: 16,
                  ),
                );
              case TodoStatus.error:
                return Center(
                  child: Text(state.errorMessage),
                );
              case TodoStatus.success:
                final todos = state.todos;
                return ListView.builder(
                  itemCount: state.todos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(todos[index].title),
                      subtitle: Text(todos[index].description),
                    );
                  },
                );
              default:
                throw UnimplementedError(
                    'Incorrect state reached : ${state.status}');
            }
          },
        ),
      ),
    );
  }
}
