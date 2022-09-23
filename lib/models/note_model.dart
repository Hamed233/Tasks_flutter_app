import 'dart:convert';
import 'package:flutter/material.dart';


class Note {
  int? id;
  String? note_title;
  String? note_description;
  String? note_date;
  int? note_color;
  int? index_of_color;
  int? is_archived = 0;

  Note({
    this.note_title,
    this.note_description,
    this.note_date,
    this.note_color,
    this.index_of_color,
    this.is_archived,
  });

  Note.withId({
    this.id,
    this.note_title,
    this.note_description,
    this.note_date,
    this.note_color,
    this.index_of_color,
    this.is_archived,
  });


  Note.fromJson(Map<String, dynamic> json){
    note_title = json['note_title'];
    note_description = json['note_description'];
    note_date = json['note_date'];
    note_color = json['note_color'];
    index_of_color = json['index_of_color'];
    is_archived = json['is_archived'];
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['note_title'] = note_title;
    map['note_description'] = note_description;
    map['note_date'] = note_date;
    map['note_color'] = note_color;
    map['index_of_color'] = index_of_color;
    map['is_archived'] = is_archived;
    return map;
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note.withId(
      id: map['id'],
      note_title: map['note_title'],
      note_description: map['note_description'],
      note_date: map['note_date'],
      note_color: map['note_color'],
      index_of_color: map['index_of_color'],
      is_archived: map['is_archived'],
    );
  }
}