import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_life_app/models/pomodoro_setting_model.dart';
import 'package:manage_life_app/layout/pomodoro/settings/widgets/pomodoro_duration.dart';
import 'package:manage_life_app/layout/pomodoro/settings/widgets/pomodoro_long_break_duration.dart';
import 'package:manage_life_app/layout/pomodoro/settings/widgets/pomodoro_long_break_interval.dart';
import 'package:manage_life_app/layout/pomodoro/settings/widgets/pomodoro_short_break_duration.dart';
import 'package:manage_life_app/providers/general_app_cubit/app_general_cubit.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/providers/pomodoro_bloc/pomodoro_cubit.dart';
import 'package:manage_life_app/providers/pomodoro_bloc/pomodoro_states.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SettingsPomodoro extends StatelessWidget {

  late Duration _workDuration;
  late Duration _shortBreak;
  late Duration _longBreak;
  int? _longBreakInterval;
  bool? loaded;
  bool? processing;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PomodoroCubit, PomodoroStates>(
      listener: (context, state) {},
      builder: (context, state) {
        // if(userRepo.fsUser != null && !loaded) {
        //   PomodoroSetting pomodoroSetting = PomodoroSetting();
        //             _workDuration = pomodoroSetting.work!;
        // _shortBreak = pomodoroSetting.shortBreak!;
        // _longBreak = pomodoroSetting.longBreak!;
        // _longBreakInterval = pomodoroSetting.sessionsBeforeLongBreak;
        //   loaded = true;
        // // }

        var data = AppCubit.get(context).userData;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            leading: Container(),
            title: Text(
              "Pomodoro Settings",
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            centerTitle: true,
            elevation: 0.0,
            actions: [
              defaultTextButton(function: () => Navigator.pop(context), text: "Done"),
            ],
          ),
          body: Container(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 15.0,
                end: 15.0,
                top: 25.0,
                bottom: 25.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _settingBuilder(context, "task_duration", "Pomodoro Duration", "${data?.pomo_settings?.work?.inMinutes} minutes"),
                  SizedBox(height: 10,),
                  _settingBuilder(context, "short_break", "Short Break Duration", "${data?.pomo_settings?.shortBreak?.inMinutes} minutes"),
                  SizedBox(height: 10,),
                  _settingBuilder(context, "long_break", "Long Break Duration", "${data?.pomo_settings?.longBreak?.inMinutes} minutes"),
                  SizedBox(height: 10,),
                  _settingBuilder(context, "short_break_interval", "Long Break Interval", "${data?.pomo_settings?.sessionsBeforeLongBreak} work sessions"),
                ]
              )
            ),
          ),
        );
      }
    );
  }

  Widget _settingBuilder(context, onTapFor, title, info) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
          showCupertinoModalBottomSheet(
            expand: false,
            context: context,
            enableDrag: true,
            topRadius: Radius.circular(20),
            backgroundColor: Colors.transparent,
            builder: (context) {
              if(onTapFor == "task_duration") {
                return PomodoroDurationWidget();
              } else if (onTapFor == "short_break") {
                return PomodoroShortBreakDurationWidget();
              } else if (onTapFor == "long_break") {
                return PomodoroLongBreakDurationWidget();
              } else if (onTapFor == "short_break_interval") {
                return PomodoroLongBreakIntervalWidget();
              } 
              
              return PomodoroDurationWidget();
            },
          );
        
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(10),
          color: Theme.of(context).cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              Spacer(),
              Text(
                info,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: 5,),
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.grey,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
