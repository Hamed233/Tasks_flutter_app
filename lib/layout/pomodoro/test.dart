

// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:manage_life_app/api/notification_api.dart';
// import 'package:manage_life_app/layout/tasks_screens/countdown-page.dart';
// import 'package:manage_life_app/providers/network/local/cache_helper.dart';
// import 'package:manage_life_app/shared/components/constants.dart';
// import 'package:manage_life_app/shared/styles/colors.dart';
// import 'package:manage_life_app/shared/utiles/helper.dart';
// import 'package:percent_indicator/percent_indicator.dart';


// import 'dart:async';

// enum Status {
//   work,
//   shortBreak,
//   longBreak,
// }

// class Pomodoro {
//   Duration targetTime;
//   Status status;
//   int count;

//   Pomodoro({
//     required this.targetTime,
//     required this.status,
//     required this.count,
//   });

//   void setParam({Duration? time, Status? status}) {
//     this.targetTime = time!;
//     this.status = status!;
//   }
// }

// class PomodoroTechnique extends StatefulWidget {
//   @override
//   _PomodoroTechniqueState createState() => _PomodoroTechniqueState();
// }


// class _PomodoroTechniqueState extends State<PomodoroTechnique> {
//   late Stopwatch _sw;
//   Timer? _timer;
//   Duration _timeLeft = Duration();
//   Duration _newTimeLeft = Duration();
//   Pomodoro _pomodoro =
//       Pomodoro(targetTime: kWorkDuration, status: Status.work, count: 0);
//   bool pomodoroIsDone = false;
//   var test;
  


//   @override
//   void initState() {
//     final getTime = CacheHelper.getData(key: "time");
//     print(getTime);
//     _pomodoro.targetTime = kWorkDuration;
//     test = DateTime.now().add(Duration(minutes: 10));
//     _sw = Stopwatch();
//     _timer = Timer.periodic(Duration(milliseconds: 50), _callback);
//     print(_timer);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _timer!.cancel();
//     _timer = null;
    
//     super.dispose();
//   }


  

//   void _callback(Timer timer) {
//     if (_sw.elapsed > _pomodoro.targetTime) {
//       setState(() {
//         _changeNextStatus();
//       });
//       return;
//     }

//   _newTimeLeft = _pomodoro.targetTime - _sw.elapsed;
//     if (_newTimeLeft.inSeconds != _timeLeft.inSeconds) {
//       setState(() {
//         _timeLeft = _newTimeLeft;
//       });
//     }
//   }

//   void _changeNextStatus() {
//     _sw.stop();
//     _sw.reset();
//     if (_pomodoro.status == Status.work) {
//       _pomodoro.count++;
//       if (_pomodoro.count % longBreakAfter == 0) {
//         _pomodoro.setParam(time: Duration(minutes: kLongBreakDuration), status: Status.longBreak);
//         NotificationAPI.showNotification(
//           title: "You have completed 5 Pomodoro!",
//           body: "Let's take a long break now!",
//           payload: "test",
//         );
        
//         playBreakPomodoroAlarm();
//       } else {
//         _pomodoro.setParam(time: Duration(minutes: kShortBreakDuration), status: Status.shortBreak);
//         NotificationAPI.showNotification(
//           title: "Pomodoro Time Done!",
//           body: "Let's take a short break!",
//           payload: "test",
//         );
//         // Use here TTS instead of notifications
//         playBreakPomodoroAlarm();
//       }
//     } else {
//       _pomodoro.setParam(time: kWorkDuration, status: Status.work);
//       NotificationAPI.showNotification(
//         title: "Break Finished!",
//         body: "Let's start!",
//         payload: "test2",
//       );
      
//       playWorkPomodoroAlarm();
//       // Use here TTS

//     }
//   }

//   void _resetButtonPressed() {
//     if (!_sw.isRunning) {
//       setState(() {
//         _sw.reset();
//       });
//     }
//   }

//   void _buttonPressed() {
//     setState(() {
//       if (_sw.isRunning) {
//         _sw.stop();
//       } else {
//         _sw.start();
//       }
//     });
//   }

//   Widget displayTimeString() {
//     String minutes = (_timeLeft.inMinutes % 60).toString().padLeft(2, '0');
//     String seconds = (_timeLeft.inSeconds % 60).toString().padLeft(2, '0');
//     return Text("$minutes:$seconds", 
//       style: TextStyle(
//         fontSize: 90.0,
//         color: Colors.white
//       ));
//   }

//   Widget displayPomodoroStatus() {
//     String text;
//     if (_pomodoro.status == Status.work) {
//       text = kWorkLabel;
//     } else if (_pomodoro.status == Status.shortBreak) {
//       text = kShortBreakLabel;
//     } else {
//       text = kLongBreakLabel;
//     }
//     return Text(text, 
//       style: TextStyle(
//         fontSize: 23.0,
//         color: Colors.white
//       )
//     );
//   }

//   Color _getColor() {
//     if (_pomodoro.status == Status.work) {
//       return mainColor;
//     } else if (_pomodoro.status == Status.shortBreak) {
//       return Colors.green;
//     } else {
//       return Colors.red;
//     }
//   }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _getColor(),
//       appBar: AppBar(
//         backgroundColor: _getColor(),
//         leading: IconButton(
//           icon: Icon(
//             Icons.keyboard_arrow_down,
//             color: Colors.white,
//             size: 30,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           IconButton(onPressed: () {},
//            icon: Icon(
//              Icons.settings,
//              color: Colors.white,
//              size: 27,
//             ),
//            ),
          
//         ],
//         title: Icon(
//           Icons.scale_rounded,
//           color: Colors.white,
//           size: 27,
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: Container(
//               width: double.infinity,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   SizedBox(height: 30,),
//                   // Text(
//                     // "${_pomodoro.count.toString()}/$targetInterval",
//                   //   style: TextStyle(fontSize: 40.0),
//                   // ),
//                   Container(
//                     width: 150,
//                     padding: EdgeInsetsDirectional.only(
//                       start: 20,
//                       end: 20,
//                       top: 10,
//                       bottom: 10,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadiusDirectional.circular(40),
//                       border: Border.all(
//                         color: Colors.white,
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: _pomodoroWidget(),
//                     ),
//                   ),
//                   SizedBox(height: 30,),
//                   CircularPercentIndicator(
//                     radius: 150.0,
//                     lineWidth: 10.0,
//                     percent: (_newTimeLeft.inSeconds / _pomodoro.targetTime.inSeconds),
//                     center: displayTimeString(),
//                     progressColor: Color.fromARGB(151, 147, 147, 147),
//                     arcBackgroundColor: Colors.white,
//                     arcType: ArcType.FULL,
//                   ),
//                   displayPomodoroStatus(),
//                   SizedBox(height: 20,),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: 150,
//                         padding: EdgeInsetsDirectional.only(
//                           start: 20,
//                           end: 20,
//                           top: 10,
//                           bottom: 10,
//                         ),
//                         decoration: BoxDecoration(
//                           color: kWorkDuration != _newTimeLeft ? Colors.white : null,
//                           borderRadius: BorderRadiusDirectional.circular(40),
//                           border: Border.all(
//                             color: Colors.white,
//                           ),
//                         ),
                        
//                         child: InkWell(
//                           onTap: () => _buttonPressed(),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 _sw.isRunning ? Icons.pause : Icons.play_arrow,
//                                 color: kWorkDuration != _newTimeLeft ? _getColor() : Colors.white,
//                                 size: 40,
//                               ),
//                               Text(
//                                 _sw.isRunning ? "Pause" : (kWorkDuration != _newTimeLeft ? "Continue" : "Play"),
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: kWorkDuration != _newTimeLeft ? _getColor() : Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       if(!_sw.isRunning)
//                         SizedBox(width: 10,),
//                       if(!_sw.isRunning && kWorkDuration != _newTimeLeft)
//                         Container(
//                           width: 150,
//                           padding: EdgeInsetsDirectional.only(
//                             start: 20,
//                             end: 20,
//                             top: 10,
//                             bottom: 10,
//                           ),
//                           decoration: BoxDecoration(
//                             color: _getColor(),
//                             borderRadius: BorderRadiusDirectional.circular(40),
//                             border: Border.all(
//                               color: Colors.white,
//                             ),
//                           ),
//                           child: InkWell(
//                             onTap: () => _resetButtonPressed(),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.refresh,
//                                   color: Colors.white,
//                                   size: 40,
//                                 ),
//                                 Text(
//                                   "Reset",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
                        
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//       ),
//     );
//   }

//   List<SvgPicture> _pomodoroWidget() { 
//       var pomodoro = [
//           SvgPicture.asset(Resources.pomodoroTimer, width: 25, height: 25, color: _pomodoro.count <= 0 ? Colors.grey : null,),
//           SvgPicture.asset(Resources.pomodoroTimer, width: 25, height: 25, color: _pomodoro.count < 2 ? Colors.grey : null,),
//           SvgPicture.asset(Resources.pomodoroTimer, width: 25, height: 25, color: _pomodoro.count < 3 ? Colors.grey : null,),
//           SvgPicture.asset(Resources.pomodoroTimer, width: 25, height: 25, color: _pomodoro.count < 4 ? Colors.grey : null,),
//           SvgPicture.asset(Resources.pomodoroTimer, width: 25, height: 25, color: _pomodoro.count != 5 && _pomodoro.count < 5 ? Colors.grey : null,),
//       ];

//       return pomodoro;
//   }

//     AudioPlayer audioPlayer = AudioPlayer();
//     AudioCache audioCache =  AudioCache(prefix: "assets/audios/");
    
//     Future playWorkPomodoroAlarm() async {
//       await audioCache.play("work-alarm.mp3");
//     }

//     Future playBreakPomodoroAlarm() async {
//       await audioCache.play("break-alarm.mp3");
//     }
    
//     String formatDuration(Duration d) {
//       String f(int n) {
//         return n.toString().padLeft(2, '0');
//       }

//       // We want to round up the remaining time to the nearest second
//       d += Duration(microseconds: 999999);
//       return "${f(d.inMinutes)}:${f(d.inSeconds % 60)}";
//     }
// }