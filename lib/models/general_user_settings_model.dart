import 'package:flutter/material.dart';

class UserNormalSettings {
  String? language;
  String? startWeekOn;
  String? wakeUpAt;
  String? sleepAt;

  UserNormalSettings({
    this.language = "en",
    this.startWeekOn = "Saturday",
    this.wakeUpAt = "7:00 AM",
    this.sleepAt = "9:00 PM",
  });

  UserNormalSettings.fromMap(Map<String, dynamic> data)
      : language =  data["language"] ?? "en",
        startWeekOn = data["startWeekOn"] ?? "Saturday",
        wakeUpAt = data["wakeUpAt"] ?? "7:00 AM",
        sleepAt = data["sleepAt"] ?? "9:00 PM";

  Map<String, dynamic> toMap() => {
        "language": language,
        "startWeekOn": startWeekOn,
        "wakeUpAt": wakeUpAt,
        "sleepAt": sleepAt,
      };
}