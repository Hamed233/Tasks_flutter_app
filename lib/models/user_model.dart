import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:manage_life_app/models/general_user_settings_model.dart';
import 'package:manage_life_app/models/pomodoro_setting_model.dart';


class UserModel {
  String? id;
  String? username;
  String? email;
  String? password;
  String? date;
  bool? isVerfied = false;
  String? whoIs = "default";
  String? image;
  PomodoroSetting? pomo_settings = PomodoroSetting();
  UserNormalSettings? user_settings = UserNormalSettings();

  UserModel({
    this.username,
    this.email,
    this.password,
    this.date,
    this.isVerfied,
    this.whoIs = "default",
    this.image,
    this.pomo_settings,
    // this.user_settings,
  });

  UserModel.withId({
    this.id,
    this.username,
    this.email,
    this.password,
    this.date,
    this.isVerfied,
    this.whoIs = "default",
    this.image,
    this.pomo_settings,
    this.user_settings,
  });

    Map<String, dynamic> toMap() {
      final map = Map<String, dynamic>();
      map['id'] = id;
      map['username'] = username;
      map['email'] = email;
      map['password'] = password;
      map['date'] = date;
      map['isVerfied'] = isVerfied;
      map['whoIs'] = whoIs;
      map['image'] = image;
      map['pomo_settings'] = pomo_settings!.toMap();
      map['user_settings'] = user_settings!.toMap();
      return map;
    }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel.withId(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      date: map['date'],
      isVerfied: map['isVerfied'],
      whoIs: map['whoIs'],
      image: map['image'],
      pomo_settings: PomodoroSetting.fromMap(Map<String,dynamic>.from(map["pomo_settings"] ?? {})),
      user_settings: UserNormalSettings.fromMap(Map<String,dynamic>.from(map["user_settings"] ?? {}))
    );
  }

}