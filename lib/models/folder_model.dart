class FolderModel {
  int? id;
  String? folder_title;
  String? folder_content;
  int folder_icon;
  int folder_color;
  int folder_color_index;
  String? is_built_in;

  FolderModel({
    required this.folder_title,
    required this.folder_content,
    required this.folder_icon,
    required this.folder_color,
    required this.folder_color_index,
    this.is_built_in,
  });

  FolderModel.withId({
    this.id,
    required this.folder_title,
    required this.folder_content,
    required this.folder_icon,
    required this.folder_color,
    required this.folder_color_index,
    this.is_built_in,
  });

    Map<String, dynamic> toMap() {
      final map = Map<String, dynamic>();
      map['id'] = id;
      map['folder_title'] = folder_title;
      map['folder_content'] = folder_content;
      map['folder_icon'] = folder_icon;
      map['folder_color'] = folder_color;
      map['folder_color_index'] = folder_color_index;
      map['is_built_in'] = is_built_in;
      return map;
    }

  factory FolderModel.fromMap(Map<String, dynamic> map) {
    return FolderModel.withId(
      id: map['id'],
      folder_title: map['folder_title'],
      folder_content: map['folder_content'],
      folder_icon: map['folder_icon'],
      folder_color: map['folder_color'],
      folder_color_index: map['folder_color_index'],
      is_built_in: map['is_built_in'],
    );
  }

}