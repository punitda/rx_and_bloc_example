import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Todo extends Equatable {
  final int id;
  final String title;
  final String description;
  Todo({
    @required this.id,
    @required this.title,
    @required this.description,
  });

  Todo copyWith({
    int id,
    String title,
    String description,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  @override
  List<Object> get props => [id, title, description];
}
