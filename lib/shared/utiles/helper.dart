import 'dart:io';
import 'package:auto_animated/auto_animated.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:manage_life_app/layout/pomodoro/settings/settings_tab.dart';
import 'package:manage_life_app/layout/projects_screen/projects/presentation/pages/add_new_project_sheet.dart';
import 'package:manage_life_app/layout/settings/account_settings.dart';
import 'package:manage_life_app/layout/settings/general_settings.dart';
import 'package:manage_life_app/layout/settings/settings.dart';
import 'package:manage_life_app/models/note_model.dart';
import 'package:manage_life_app/modules/widgets/add_new_folder_sheet.dart';
import 'package:manage_life_app/modules/widgets/event_sheet.dart';
import 'package:manage_life_app/modules/widgets/more_details_sheet.dart';
import 'package:manage_life_app/modules/widgets/note_sheet.dart';
import 'package:manage_life_app/modules/widgets/settings/languages.dart';
import 'package:manage_life_app/modules/widgets/settings/start_day_on.dart';
import 'package:manage_life_app/modules/widgets/sort_by_sheet.dart';
import 'package:manage_life_app/providers/general_app_cubit/app_general_cubit.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/providers/note_bloc/note_bloc.dart';
import 'package:manage_life_app/providers/project_bloc/project_cubit.dart';
import 'package:manage_life_app/providers/task_bloc/task_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:manage_life_app/modules/widgets/task_sheet.dart';
import 'package:manage_life_app/shared/styles/themes.dart';
import 'package:manage_life_app/shared/utiles/extensions.dart';

class Helper {
  static showCustomSnackBar(BuildContext context,
      {required String content, required Color bgColor, required Color textColor}) {
    final snackBar = SnackBar(
      content: Text(
        content,
        style: TextStyle(
          color: textColor,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: bgColor.withOpacity(0.7),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }



  static showNoteBottomSheet(
    BuildContext context, {bool isUpdate = false, int noteId = 0}) {
    if(isUpdate)
      NoteBloc.get(context).getNoteDataFromDB(noteId);
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      enableDrag: true,
      topRadius: Radius.circular(20),
      backgroundColor: Colors.transparent,
      builder: (context) => NoteSheet(isUpdate, noteId),
    );
  }

  static showMoreDetailsBottomSheet(
    BuildContext context) {
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      enableDrag: true,
      topRadius: Radius.circular(20),
      backgroundColor: Colors.transparent,
      builder: (context) => MoreDetailsSheet(),
    );
  }

  static showAccountSettingsBottomSheet(
    BuildContext context, userId) {

    if(userId != null)
      AppCubit.get(context).userInfo(userId);

    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      enableDrag: true,
      topRadius: Radius.circular(20),
      backgroundColor: Colors.transparent,
      builder: (context) => AccountSettingsScreen(),
    );
  }

  static showStartWeekOnBottomSheet(
    BuildContext context) {
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      enableDrag: true,
      topRadius: Radius.circular(20),
      backgroundColor: Colors.transparent,
      builder: (context) => StartWeekOn(),
    );
  }

  static showChooseLanguageBottomSheet(
    BuildContext context) {
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      enableDrag: true,
      topRadius: Radius.circular(20),
      backgroundColor: Colors.transparent,
      builder: (context) => Languages(),
    );
  }

  static showGeneralSettingsBottomSheet(
    BuildContext context) {
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      enableDrag: true,
      topRadius: Radius.circular(20),
      backgroundColor: Colors.transparent,
      builder: (context) => GeneralSettingsScreen(),
    );
  }

  static showSettingsSheet(
    BuildContext context) {
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      enableDrag: true,
      topRadius: Radius.circular(20),
      backgroundColor: Colors.transparent,
      builder: (context) => SettingsScreen(),
    );
  }

  static showSortByBottomSheet(
    BuildContext context) {
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      enableDrag: true,
      topRadius: Radius.circular(20),
      backgroundColor: Colors.transparent,
      builder: (context) => SortBySheet(),
    );
  }

    Duration durationOfTask = Duration.zero;

   static showTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: SizedBox.expand(
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.hm,
              minuteInterval: 1,
              secondInterval: 1,
              // initialTimerDuration: durationOfTask,
              onTimerDurationChanged: (newTime) {
                // setState(() => durationOfTask = newTime);
              },
            ),
          ),
        );
      },
    );
  }

  static showAddFolderBottomSheet(
      BuildContext context, {
        int folderId = 0,
        bool isUpdate = false,
      }) {
    if(isUpdate) {
      TaskCubit.get(context).getFolderDataFromDB(folderId);
    }

    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      enableDrag: true,
      topRadius: Radius.circular(20),
      backgroundColor: Colors.transparent,
      builder: (context) => AddNewFolderSheet(isUpdate, folderId),
    ).then((value) {
      TaskCubit().indexOfCurrentColor = 1;
    });
  }

  static showEventBottomSheet(
      BuildContext context, {event}) {

    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      enableDrag: true,
      topRadius: Radius.circular(20),
      backgroundColor: Colors.transparent,
      builder: (context) => AddEventScreen(event: event),
    ).then((value) {
      // TaskCubit().indexOfCurrentColor = 1;
    });
  }

  static showAddProjectBottomSheet(
      BuildContext context, {isUpdate = false, projectId = 0}) {
    if(isUpdate)
      ProjectCubit.get(context).getProjectDataFromDB(projectId);
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      enableDrag: true,
      topRadius: Radius.circular(20),
      backgroundColor: Colors.transparent,
      builder: (context) => AddNewProjectSheet(isUpdate, projectId),
    ).then((value) {

    });
  }

  static showPomodoroSettingsBottomSheet(
      BuildContext context) {
    var userId = CacheHelper.getData(key: "user_id");
    if(userId != null)
      AppCubit.get(context).userInfo(CacheHelper.getData(key: "user_id"));
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      enableDrag: true,
      topRadius: Radius.circular(20),
      backgroundColor: Colors.transparent,
      builder: (context) => SettingsPomodoro(),
    );
  }

  static showTaskBottomSheet(
      BuildContext context, {
        int taskId = 0,
        int folderId = 0,
        int? categoryId = 0,
        bool isUpdate = false,
      }) {
    if(isUpdate) {
      TaskCubit.get(context).isSelectedDuration = true;
      TaskCubit.get(context).getTaskDataFromDB(taskId);
    }
      
    TaskCubit.get(context).getProjectsList();

    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      enableDrag: true,
      topRadius: Radius.circular(20),
      backgroundColor: Colors.transparent,
      builder: (context) => TaskSheet(isUpdate, taskId),
    ).then((value) {
          
      // final DateTime now = new DateTime.now();
      // late String currentTime = new DateFormat('hh:mm a').format(now).toString();
      // late String plusOneHourFromNow = now.add(Duration(hours: 1)).format('hh:mm a').toString();
      
      TaskCubit.get(context).isSelectedDuration = false;
      TaskCubit.get(context).taskRating = 1;
      TaskCubit.get(context).folderId = 1;
      // TaskCubit.get(context).fromTime = currentTime;
      // TaskCubit.get(context).fromTime = plusOneHourFromNow;
      TaskCubit.get(context).getTasksOfFolderDataFromDB(folderId);
    });
  }

  static void unfocus() {
    WidgetsBinding.instance!.focusManager.primaryFocus?.unfocus();
  }

  static LiveOptions get options => LiveOptions(
    // Start animation after (default zero)
    delay: Duration(seconds: 0),

    // Show each item through (default 250)
    showItemInterval: Duration(milliseconds: 50),

    // Animation duration (default 250)
    showItemDuration: Duration(milliseconds: 100),

    // Animations starts at 0.05 visible
    // item fraction in sight (default 0.025)
    visibleFraction: 0.05,

    // Repeat the animation of the appearance
    // when scrolling in the opposite direction (default false)
    // To get the effect as in a showcase for ListView, set true
    reAnimateOnVisibility: false,

  );
}
