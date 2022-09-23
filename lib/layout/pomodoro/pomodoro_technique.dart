
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manage_life_app/api/notification_api.dart';
import 'package:manage_life_app/layout/tasks_screens/countdown-page.dart';
import 'package:manage_life_app/providers/general_app_cubit/app_general_cubit.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/providers/pomodoro_bloc/pomodoro_cubit.dart';
import 'package:manage_life_app/providers/pomodoro_bloc/pomodoro_states.dart';
import 'package:manage_life_app/providers/task_bloc/task_bloc.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:percent_indicator/percent_indicator.dart';


import 'dart:async';

class PomodoroTechnique extends StatelessWidget {

  // late Stopwatch _sw;
  Timer? _timer;
  // Duration _timeLeft = Duration();
  // Duration _newTimeLeft = Duration();
  // Pomodoro _pomodoro =
  //     Pomodoro(targetTime: kWorkDuration, status: Status.work, count: 0);
  // bool pomodoroIsDone = false;


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PomodoroCubit(),
      child: BlocConsumer<PomodoroCubit, PomodoroStates>(
        listener: (context, state) {},
        builder: (context, state) 
        {
          PomodoroCubit pomodoroCubit = PomodoroCubit.get(context);
        _timer = Timer.periodic(Duration(milliseconds: 50), pomodoroCubit.callback);
    
          return Scaffold(
          backgroundColor: pomodoroCubit.getColor(),
          appBar: AppBar(
            backgroundColor: pomodoroCubit.getColor(),
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Helper.showPomodoroSettingsBottomSheet(context);
                },
               icon: Icon(
                 Icons.settings,
                 color: Colors.white,
                 size: 27,
                ),
               ),
              
            ],
            title: Icon(
              Icons.scale_rounded,
              color: Colors.white,
              size: 27,
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 30,),
                      // Text(
                        // "${_pomodoro.count.toString()}/$targetInterval",
                      //   style: TextStyle(fontSize: 40.0),
                      // ),
                      Container(
                        width: 150,
                        padding: EdgeInsetsDirectional.only(
                          start: 20,
                          end: 20,
                          top: 10,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadiusDirectional.circular(40),
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: pomodoroCubit.pomodoroWidget(),
                        ),
                      ),
                      SizedBox(height: 30,),
                      CircularPercentIndicator(
                        radius: 150.0,
                        lineWidth: 10.0,
                        percent: (pomodoroCubit.newTimeLeft.inSeconds / pomodoroCubit.pomodoro.targetTime.inSeconds),
                        center: pomodoroCubit.displayTimeString(),
                        progressColor: Color.fromARGB(151, 147, 147, 147),
                        arcBackgroundColor: Colors.white,
                        arcType: ArcType.FULL,
                      ),
                      pomodoroCubit.displayPomodoroStatus(),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            padding: EdgeInsetsDirectional.only(
                              start: 20,
                              end: 20,
                              top: 10,
                              bottom: 10,
                            ),
                            decoration: BoxDecoration(
                              color: kWorkDuration != pomodoroCubit.newTimeLeft ? Colors.white : null,
                              borderRadius: BorderRadiusDirectional.circular(40),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            
                            child: InkWell(
                              onTap: () => pomodoroCubit.pomodoroButtonPressed(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    pomodoroCubit.sw.isRunning ? Icons.pause : Icons.play_arrow,
                                    color: kWorkDuration != pomodoroCubit.newTimeLeft ? pomodoroCubit.getColor() : Colors.white,
                                    size: 40,
                                  ),
                                  Text(
                                    pomodoroCubit.sw.isRunning ? "Pause" : (kWorkDuration != pomodoroCubit.newTimeLeft ? "Continue" : "Play"),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: kWorkDuration != pomodoroCubit.newTimeLeft ? pomodoroCubit.getColor() : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if(!pomodoroCubit.sw.isRunning)
                            SizedBox(width: 10,),
                          if(!pomodoroCubit.sw.isRunning && kWorkDuration != pomodoroCubit.newTimeLeft)
                            Container(
                              width: 150,
                              padding: EdgeInsetsDirectional.only(
                                start: 20,
                                end: 20,
                                top: 10,
                                bottom: 10,
                              ),
                              decoration: BoxDecoration(
                                color: pomodoroCubit.getColor(),
                                borderRadius: BorderRadiusDirectional.circular(40),
                                border: Border.all(
                                  color: Colors.white,
                                ),
                              ),
                              child: InkWell(
                                onTap: () => pomodoroCubit.resetPomodoro(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    Text(
                                      "Reset",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                        ],
                      ),
                    ],
                  ),
                ),
          ),
        );
        }
      ),
    );
  }


}
