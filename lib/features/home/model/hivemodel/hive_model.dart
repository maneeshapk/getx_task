import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'hive_model.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final TimeOfDay time;

  Task({required this.title, required this.date, required this.time});
}

