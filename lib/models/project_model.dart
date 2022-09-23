import 'package:manage_life_app/shared/components/constants.dart';

class Project {
  int? id;
  String? project_title;
  String? project_description;
  String? project_created_at;
  int? project_color;
  int? index_of_color;
  int? is_archived = 0;
  String? status;

  Project({
    this.project_title, 
    this.project_description, 
    this.project_created_at, 
    this.project_color, 
    this.index_of_color,
    this.is_archived,
    this.status, 
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['project_title'] = project_title;
    map['project_description'] = project_description;
    map['project_created_at'] = project_created_at;
    map['project_color'] = project_color;
    map['index_of_color'] = index_of_color;
    map['is_archived'] = is_archived;
    map['status'] = status;
    return map;
  }

  Project.withId({
    this.id, 
    this.project_title, 
    this.project_description, 
    this.project_created_at, 
    this.project_color, 
    this.index_of_color,
    this.is_archived,
    this.status, 
  });
  
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project.withId(
      id: map['id'],
      project_title: map['project_title'],
      project_description: map['project_description'],
      project_created_at: map['project_created_at'],
      project_color: map['project_color'],
      index_of_color: map['index_of_color'],
      is_archived: map['is_archived'],
      status: map['status'],
    );
  }
}

