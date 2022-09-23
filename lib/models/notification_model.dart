class NotificationModel {
  int? id;
  String? title;
  String? body;
  // String tag_notification;
  String start_date;
  String end_date;
  String start_time;
  String end_time;
  String? payload;
  int? is_open = 0;

  NotificationModel({
    required this.title,
    required this.body,
    // required this.tag_notification,
    required this.start_date,
    required this.end_date,
    required this.start_time,
    required this.end_time,
    required this.payload,
    this.is_open,
  });

  NotificationModel.withId({
    this.id,
    required this.title,
    required this.body,
    // required this.tag_notification,
    required this.start_date,
    required this.end_date,
    required this.start_time,
    required this.end_time,
    required this.payload,
    this.is_open,
  });

    Map<String, dynamic> toMap() {
      final map = Map<String, dynamic>();
      map['id'] = id;
      map['title'] = title;
      map['body'] = body;
      // map['tag_notification'] = tag_notification;
      map['start_date'] = start_date;
      map['end_date'] = end_date;
      map['start_time'] = start_time;
      map['end_time'] = end_time;
      map['payload'] = payload;
      map['is_open'] = is_open;
      return map;
    }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel.withId(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      // tag_notification: map['tag_notification'],
      start_date: map['start_date'],
      end_date: map['end_date'],
      start_time: map['start_time'],
      end_time: map['end_time'],
      payload: map['payload'],
      is_open: map['is_open'],
    );
  }

}