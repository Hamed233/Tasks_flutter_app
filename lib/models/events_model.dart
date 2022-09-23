import 'package:flutter/material.dart';
import 'package:manage_life_app/shared/styles/colors.dart';

class Event {
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;

  const Event({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    this.backgroundColor = Colors.green,
    this.isAllDay = false,
  });
}