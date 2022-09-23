import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manage_life_app/api/notification_api.dart';
import 'package:manage_life_app/models/pomodoro_setting_model.dart';
import 'package:manage_life_app/models/user_model.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/providers/pomodoro_bloc/pomodoro_states.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/styles/colors.dart';

import '../../models/pomodoro_model.dart';

enum Status {
  work,
  shortBreak,
  longBreak,
}

class PomodoroCubit extends Cubit<PomodoroStates> {
  PomodoroCubit() : super(PomodoroInitial());

  static PomodoroCubit get(context) => BlocProvider.of(context);

  
  Stopwatch sw = Stopwatch();
  Duration timeLeft = Duration();
  Duration newTimeLeft = Duration();
  Pomodoro pomodoro =
      Pomodoro(targetTime: kWorkDuration, status: Status.work, count: 0);
  bool pomodoroIsDone = false;
  
  void pomodoroButtonPressed() {
    if (sw.isRunning) {
      sw.stop();
      emit(PomodoroStoped());
    } else {
      sw.start();
      emit(PomodoroStarted());
    }
  }

  void resetPomodoro() {
    if (!sw.isRunning) {
        sw.reset();
        emit(PomodoroReseted());
    }
  }

  void callback(Timer timer) {
    if (sw.elapsed > pomodoro.targetTime) {
        changeNextStatus();
        emit(PomodoroChangeNextStatus());
      return;
    }

  newTimeLeft = pomodoro.targetTime - sw.elapsed;
    if (newTimeLeft.inSeconds != timeLeft.inSeconds) {
        timeLeft = newTimeLeft;
        emit(UpdateTimeLeft());
    }
  }

  void changeNextStatus() {
    sw.stop();
    sw.reset();
    if (pomodoro.status == Status.work) {
      pomodoro.count++;
      if (pomodoro.count % longBreakAfter == 0) {
        pomodoro.setParam(time: kLongBreakDuration, status: Status.longBreak);
        NotificationAPI.showNotification(
          title: "You have completed 5 Pomodoro!",
          body: "Let's take a long break now!",
          payload: "test",
        );
        
        playBreakPomodoroAlarm();
      } else {
        pomodoro.setParam(time:kShortBreakDuration, status: Status.shortBreak);
        NotificationAPI.showNotification(
          title: "Pomodoro Time Done!",
          body: "Let's take a short break!",
          payload: "test",
        );
        // Use here TTS instead of notifications
        playBreakPomodoroAlarm();
      }
    } else {
      pomodoro.setParam(time: kWorkDuration, status: Status.work);
      NotificationAPI.showNotification(
        title: "Break Finished!",
        body: "Let's start!",
        payload: "test2",
      );
      
      playWorkPomodoroAlarm();
      // Use here TTS

    }
  }

  Widget displayTimeString() {
    String minutes = (timeLeft.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (timeLeft.inSeconds % 60).toString().padLeft(2, '0');
    return Text("$minutes:$seconds", 
      style: TextStyle(
        fontSize: 90.0,
        color: Colors.white
      ));
  }

  Widget displayPomodoroStatus() {
    String text;
    if (pomodoro.status == Status.work) {
      text = kWorkLabel;
    } else if (pomodoro.status == Status.shortBreak) {
      text = kShortBreakLabel;
    } else {
      text = kLongBreakLabel;
    }
    return Text(text, 
      style: TextStyle(
        fontSize: 23.0,
        color: Colors.white
      )
    );
  }

  Color getColor() {
    if (pomodoro.status == Status.work) {
      return mainColor;
    } else if (pomodoro.status == Status.shortBreak) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache =  AudioCache(prefix: "assets/audios/");
  
  Future playWorkPomodoroAlarm() async {
    await audioCache.load("work-alarm.mp3");
  }

  Future playBreakPomodoroAlarm() async {
    await audioCache.load("break-alarm.mp3");
  }


  List<SvgPicture> pomodoroWidget() { 
    var _pomodoro = [
        SvgPicture.asset(Resources.pomodoroTimer, width: 25, height: 25, color: pomodoro.count <= 0 ? Colors.grey : null,),
        SvgPicture.asset(Resources.pomodoroTimer, width: 25, height: 25, color: pomodoro.count < 2 ? Colors.grey : null,),
        SvgPicture.asset(Resources.pomodoroTimer, width: 25, height: 25, color: pomodoro.count < 3 ? Colors.grey : null,),
        SvgPicture.asset(Resources.pomodoroTimer, width: 25, height: 25, color: pomodoro.count < 4 ? Colors.grey : null,),
        SvgPicture.asset(Resources.pomodoroTimer, width: 25, height: 25, color: pomodoro.count != 5 && pomodoro.count < 5 ? Colors.grey : null,),
    ];


    return _pomodoro;
  }


  // Get pomodoro setting (user)
  PomodoroSetting pomoSettings = PomodoroSetting();

  Future userPomodoroSettings(userId)
   async {
     print(userId);
    emit(GetUserPomodoroSettingsLoadingState());
    FirebaseFirestore.instance.collection("users").doc(userId).get().then((value) {
      pomoSettings = PomodoroSetting.fromMap(value.data()!['pomo_settings']!);
      emit(GetUserPomodoroSettingsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUserPomodoroSettingsErrorState());
    });
  }

  Future updatePomodoroSettings(context, userId, update, {
    duration
  }) async {
    emit(UpdateUserPomodoroSettingsLoadingState());

    var column;
    if(update == "workDuration") {
      column = "work_duration";
    // CacheHelper.saveData(key: 'pomodoroDuration', value: duration);
    } else if (update == "shortBreak") {
      column = "short_break";
    } else if (update == "longBreak") {
      column = "long_break";
    } else if (update == "longBreakInterval") {
      column = "sessions_before_long_break";
    }

    await FirebaseFirestore.instance.collection("users").doc(userId).update({'pomo_settings.$column': update == "longBreakInterval" ? duration : duration.inMinutes}).then((value) {
      if(update == "workDuration") {
        pomoSettings.work = duration;
      } else if (update == "shortBreak") {
        pomoSettings.shortBreak = duration;
      } else if (update == "longBreak") {
        pomoSettings.longBreak = duration;
      } else if (update == "longBreakInterval") {
        pomoSettings.sessionsBeforeLongBreak = duration;
      }
      emit(UpdateUserPomodoroSettingsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(UpdateUserPomodoroSettingsErrorState());
    });
    emit(ChangedPomodoroDuration());
  }
}