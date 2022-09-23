import 'dart:convert';
import 'package:flutter/material.dart';


class Task {
  int? id;
  String task_title;
  String? task_description;
  String task_start_date;
  String task_deadline;
  String task_start_time;
  String task_end_time;
  double? priority;
  int? status;
  int? is_archived = 0;
  int? folder_tagged;
  int? project_tagged;

  Task({
    required this.task_title,
    this.task_description,
    required this.task_start_date,
    required this.task_deadline,
    required this.task_start_time,
    required this.task_end_time,
    this.priority,
    this.status,
    this.is_archived,
    this.folder_tagged,
    this.project_tagged,
  });

  Task.withId({
    this.id,
    required this.task_title,
    this.task_description,
    required this.task_start_date,
    required this.task_deadline,
    required this.task_start_time,
    required this.task_end_time,
    this.priority,
    this.status,
    this.is_archived,
    this.folder_tagged,
    this.project_tagged,
  });

    Map<String, dynamic> toMap() {
      final map = Map<String, dynamic>();
      map['id'] = id;
      map['task_title'] = task_title;
      map['task_description'] = task_description;
      map['task_start_date'] = task_start_date;
      map['task_deadline'] = task_deadline;
      map['task_start_time'] = task_start_time;
      map['task_end_time'] = task_end_time;
      map['priority'] = priority;
      map['status'] = status;
      map['is_archived'] = is_archived;
      map['folder_tagged'] = folder_tagged;
      map['project_tagged'] = project_tagged;
      return map;
    }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
      id: map['id'],
      task_title: map['task_title'],
      task_description: map['task_description'],
      task_start_date: map['task_start_date'],
      task_deadline: map['task_deadline'],
      task_start_time: map['task_start_time'],
      task_end_time: map['task_end_time'],
      priority: map['priority'],
      status: map['status'],
      is_archived: map['is_archived'],
      folder_tagged: map['folder_tagged'],
      project_tagged: map['project_tagged'],
    );
  }

}