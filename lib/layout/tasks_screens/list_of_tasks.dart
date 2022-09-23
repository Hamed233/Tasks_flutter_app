import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:manage_life_app/api/notification_api.dart';
import 'package:manage_life_app/models/task_model.dart';
import 'package:manage_life_app/providers/general_app_cubit/app_general_cubit.dart';
import 'package:manage_life_app/providers/helpers/database_helper.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/providers/task_bloc/task_bloc.dart';
import 'package:manage_life_app/routes/argument_bundle.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_life_app/shared/styles/themes.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListOfTasks extends StatelessWidget {
  final ArgumentBundle bundle;

  ListOfTasks({
    Key? key,
    required this.bundle,
    // required this.category,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
  print(bundle.extras);
    return BlocConsumer<TaskCubit, TaskStates>(
        listener: (context, state) {},
        builder: (context, state) {

          Task task = bundle.extras;

          var taskCubit = TaskCubit.get(context);

          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: InkWell(
              onTap: () {
                // Helper.showTaskBottomSheet(context, taskId: task.id!, isUpdate: true);

                // NotificationAPI.showNotification(
                //   title: "Test",
                //   body: "Hello Noor",
                //   payload: 'sarah.abs', // user identifir
                // ).then((value) {
                //   taskCubit.speak(task.tag_title);
                // });

                
          Workmanager().registerOneOffTask(
            "TestTask",
            "TestTask",
            inputData: {"name" : "Hamed"},
            // initialDelay: Duration(minutes: 5), 
            //  DatabaseHelper.instance.insertDataToTable(notification: notificationModel);
          );

                // NotificationAPI.showScheduleNotification(
                //   title: "Test",
                //   body: "Hello Noor",
                //   payload: 'sarah.abs', // user identifir
                //   scheduleDate: DateTime.now().add(Duration(seconds: 60)),
                // ).then((value) {
                //   taskCubit.speak("هناك مهمة يجب عليك الإنتهاء منها الأن");
                // });
              },
              child: taskCubit.tasksListView
                  ? moreDetailsTaskView(context, task)
                  : lessDetailsTaskView(context, task),
            ),
          );
        });
  }

  void showNotification(taskCubit) {
    taskCubit.speak("هناك مهمة يجب عليك الإنتهاء منها الأن").then((value) {
      NotificationAPI.showNotification(
        title: "Test",
        body: "Hello Noor",
        payload: 'sarah.abs', // user identifir
      );
    });
  }

  Widget moreDetailsTaskView(context, task) => Padding(
        padding: const EdgeInsetsDirectional.only(
          top: 10,
          bottom: 10,
          start: 10,
          end: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(10),
                        bottomStart: Radius.circular(10),
                      ),
                    color: task.status == 0 ? AppTheme.inprogressTasksColor : AppTheme.doneTasksColor,
                  ),
                  width: 50,
                  height: 159,
                  child: Stack(
                    children: [
                      Positioned(
                        top: -7,
                        child: Checkbox(
                          key: Key(task.id.toString()),
                          // activeColor: Colors.black,
                          checkColor: Colors.white,
                          value: task.status == 1 ? true : false,
                          onChanged: (bool? val) {
                            task.status = val! ? 1 : 0;
                            DatabaseHelper.instance.updateTable(task: task);
                            TaskCubit.get(context).getTaskList(sortBy: CacheHelper.getData(key: "sortType"));
                            Helper.showCustomSnackBar(context,
                                content:
                                    AppLocalizations.of(context)!.task + " " + (task.status == 0 ? AppLocalizations.of(context)!.inprogress : AppLocalizations.of(context)!.done) + " " + AppLocalizations.of(context)!.now,
                                bgColor: task.status == 0
                                    ? AppTheme.inprogressTasksColor
                                    : AppTheme.doneTasksColor,
                                textColor: Colors.white);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.only(
                        // topStart: Radius.circular(10),
                        // bottomStart: Radius.circular(10),
                      ),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Slidable(
                      key: UniqueKey(),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        dismissible: DismissiblePane(onDismissed: () {
                          task.status = task.status == 0 ? 1 : 0;
                          DatabaseHelper.instance.updateTable(task:task);
                          TaskCubit.get(context).getTaskList(sortBy: CacheHelper.getData(key: "sortType"));
                        }),
                        children: [
                          SlidableAction(
                            onPressed: (BuildContext context) {
                              task.status = task.status == 0 ? 1 : 0;
                              DatabaseHelper.instance.updateTable(task:task);
                              TaskCubit.get(context).getTaskList(sortBy: CacheHelper.getData(key: "sortType"));
                            },
                            backgroundColor: Color(0xFF0392CF),
                            foregroundColor: Colors.white,
                            icon: Icons.save,
                            label: task.status == 1 ? AppLocalizations.of(context)!.undone : AppLocalizations.of(context)!.done,
                            flex: 1,
                          ),
                        ],
                      ),
                      // The end action pane is the one at the right or the bottom side.
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            // An action can be bigger than the others.
                            flex: 1,
                            onPressed: (BuildContext context) {
                              task.is_archived = task.is_archived == 0 ? 1 : 0;
                              DatabaseHelper.instance.updateTable(task:task);
                              TaskCubit.get(context).getTaskList(sortBy: CacheHelper.getData(key: "sortType"));
                              Helper.showCustomSnackBar(context,
                                  content:
                                      "${AppLocalizations.of(context)!.task} task.is_archived == 0 ? ${AppLocalizations.of(context)!.unarchive} : ${AppLocalizations.of(context)!.archive} ${AppLocalizations.of(context)!.now}!",
                                  bgColor: AppTheme.archivedTasksColor,
                                  textColor: Colors.white);
                            },
                            backgroundColor: AppTheme.archivedTasksColor,
                            foregroundColor: Colors.white,
                            icon: Icons.archive,
                            label:
                                task.is_archived == 0 ? 'Archive' : "Unarchive",
                          ),
                          SlidableAction(
                            flex: 1,
                            onPressed: (BuildContext context) {
                              DatabaseHelper.instance.deleteFromTable("tasks", task.id);
                              TaskCubit.get(context).getTaskList(sortBy: CacheHelper.getData(key: "sortType"));
                              Helper.showCustomSnackBar(context,
                                  content: AppLocalizations.of(context)!.taskDeleted,
                                  bgColor: Colors.red,
                                  textColor: Colors.white);
                            },
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: AppLocalizations.of(context)!.delete,
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          // border: Border(
                          //   right: BorderSide(color: mainColor, width: 3),
                          // ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            task.task_title,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 17,
                                              decoration: task.status == 1
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                              color: task.status == 1
                                                  ? Colors.grey
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        Container(child: priorityBuilder(task.priority)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      task.task_description!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey,
                                        decoration: task.status == 1
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Wrap(
                                    children: [
                                      Container(
                                        padding: EdgeInsetsDirectional.only(
                                            start: 5,
                                            end: 5,
                                            top: 2,
                                            bottom: 2),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: AppTheme.perano,
                                            )),
                                        child: Row(
                                          children: [
                                            Icon(Icons.tag,
                                                color: AppTheme.perano,
                                                size: 15),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              "tag",
                                                style: TextStyle(
                                                    color: AppTheme.perano,
                                                    fontSize: 15)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Container(
                                        padding: EdgeInsetsDirectional.only(
                                            start: 5,
                                            end: 5,
                                            top: 2,
                                            bottom: 2),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: (task.status == 1
                                                  ? AppTheme.doneTasksColor
                                                  : AppTheme.inprogressTasksColor),
                                            )),
                                        child: Row(
                                          children: [
                                            Icon(
                                                task.status == 1
                                                    ? Icons.done_all
                                                    : Icons.timelapse,
                                                color: (task.status == 1
                                                    ? AppTheme.doneTasksColor
                                                    : AppTheme
                                                        .inprogressTasksColor),
                                                size: 15),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                                task.status == 1
                                                    ? AppLocalizations.of(context)!.done
                                                    : AppLocalizations.of(context)!.inprogress,
                                                style: TextStyle(
                                                    color: (task.status == 1
                                                        ? AppTheme
                                                            .doneTasksColor
                                                        : AppTheme
                                                            .inprogressTasksColor),
                                                    fontSize: 15)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      if (task.is_archived == 1)
                                        Container(
                                          padding: EdgeInsetsDirectional.only(
                                              start: 5,
                                              end: 5,
                                              top: 2,
                                              bottom: 2),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color:
                                                    AppTheme.archivedTasksColor,
                                              )),
                                          child: Row(
                                            children: [
                                              Icon(Icons.archive_outlined,
                                                  color: AppTheme
                                                      .archivedTasksColor,
                                                  size: 15),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Text(AppLocalizations.of(context)!.archived,
                                                  style: TextStyle(
                                                      color: AppTheme
                                                          .archivedTasksColor,
                                                      fontSize: 15)),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.date_range,
                                      size: 15, color: mainColor),
                                  SizedBox(width: 8),
                                  Text(AppLocalizations.of(context)!.from.toUpperCase(), style: AppTheme.text3),
                                  Text(" " + task.task_start_date.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.grey,
                                      )),
                                  Text(" ${AppLocalizations.of(context)!.to.toUpperCase()} ", style: AppTheme.text3),
                                  Text(task.task_deadline.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.grey,
                                      )),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.timer, size: 15, color: mainColor),
                                  SizedBox(width: 8),
                                  Text(AppLocalizations.of(context)!.from.toUpperCase(), style: AppTheme.text3),
                                  Text(" " + task.task_start_time,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.grey,
                                      )),
                                  Text(" ${AppLocalizations.of(context)!.to.toUpperCase()} ", style: AppTheme.text3),
                                  Text(task.task_end_time,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.grey,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget lessDetailsTaskView(context, task) => Container(
    color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 60,
                  child: Stack(
                    children: [
                      Positioned(
                        top: -7,
                        child: Checkbox(
                          key: Key(task.id.toString()),
                          activeColor: mainColor,
                          checkColor: Colors.white,
                          value: task.status == 1 ? true : false,
                          onChanged: (bool? val) {
                            task.status = val! ? 1 : 0;
                            DatabaseHelper.instance.updateTable(task:task);
                            TaskCubit.get(context).getTaskList(sortBy: CacheHelper.getData(key: "sortType"));
                            Helper.showCustomSnackBar(context,
                                content:
                                    AppLocalizations.of(context)!.task + " " + (task.status == 0 ? AppLocalizations.of(context)!.inprogress : AppLocalizations.of(context)!.done) + " " + AppLocalizations.of(context)!.now,
                                bgColor: task.status == 0
                                    ? AppTheme.inprogressTasksColor
                                    : AppTheme.doneTasksColor,
                                textColor: Colors.white);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Slidable(
                      key: UniqueKey(),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        dismissible: DismissiblePane(onDismissed: () {
                          if (task.status == 0) {
                            task.status = 1;
                          } else {
                            task.status = 0;
                          }
                          DatabaseHelper.instance.updateTable(task:task);
                          TaskCubit.get(context).getTaskList(sortBy: CacheHelper.getData(key: "sortType"));
                        }),
                        children: [
                          SlidableAction(
                            onPressed: (BuildContext context) {
                              task.is_archived = task.is_archived == 0 ? 1 : 0;                            
                              DatabaseHelper.instance.updateTable(task:task);
                              TaskCubit.get(context).getTaskList(sortBy: CacheHelper.getData(key: "sortType"));
                            },
                            backgroundColor: AppTheme.doneTasksColor,
                            foregroundColor: Colors.white,
                            icon: Icons.save,
                            label: task.status == 1 ? AppLocalizations.of(context)!.undone : AppLocalizations.of(context)!.done,
                            flex: 1,
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            // An action can be bigger than the others.
                            flex: 1,
                            onPressed: (BuildContext context) {
                              task.is_archived = task.is_archived == 0 ? 1 : 0;                            
                              DatabaseHelper.instance.updateTable(task:task);
                              TaskCubit.get(context).getTaskList(sortBy: CacheHelper.getData(key: "sortType"));
                               Helper.showCustomSnackBar(context,
                                content:
                                    "${AppLocalizations.of(context)!.task} ${task.is_archived == 0 ? AppLocalizations.of(context)!.unarchive : AppLocalizations.of(context)!.archived} ${AppLocalizations.of(context)!.now}}!",
                                bgColor: AppTheme.archivedTasksColor,
                                textColor: Colors.white);
                            },
                            backgroundColor: AppTheme.archivedTasksColor,
                            foregroundColor: Colors.white,
                            icon: Icons.archive,
                            label:
                                task.is_archived == 0 ? AppLocalizations.of(context)!.archive : AppLocalizations.of(context)!.unarchive,
                          ),
                          SlidableAction(
                            flex: 1,
                            onPressed: (BuildContext context) {
                              DatabaseHelper.instance.deleteFromTable("tasks", task.id);
                              TaskCubit.get(context).getTaskList(sortBy: CacheHelper.getData(key: "sortType"));
                               Helper.showCustomSnackBar(context,
                                content:
                                    AppLocalizations.of(context)!.taskDeleted,
                                bgColor: Colors.red,
                                textColor: Colors.white);
                            },
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: AppLocalizations.of(context)!.delete,
                          ),
                        ],
                      ),
                      child: Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          task.task_title,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 17,
                                            decoration: task.status == 1
                                                ? TextDecoration.lineThrough
                                                : null,
                                            color: task.status == 1
                                                ? Colors.grey
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(child: priorityBuilder(task.priority)),
                                ],
                              )),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsetsDirectional.only(
                                        start: 5, end: 5, top: 1, bottom: 1),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: (task.status == 1
                                              ? AppTheme.doneTasksColor
                                              : AppTheme.inprogressTasksColor),
                                        )),
                                    child: Row(
                                      children: [
                                        Icon(
                                            task.status == 1
                                                ? Icons.done_all
                                                : Icons.timelapse,
                                            color: (task.status == 1
                                                ? AppTheme.doneTasksColor
                                                : AppTheme
                                                    .inprogressTasksColor),
                                            size: 15),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          task.status == 1
                                              ? AppLocalizations.of(context)!.done
                                              : AppLocalizations.of(context)!.inprogress,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: (task.status == 1
                                                  ? AppTheme.doneTasksColor
                                                  : AppTheme
                                                      .inprogressTasksColor),
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(Icons.date_range,
                                      size: 15, color: mainColor),
                                  SizedBox(width: 5),
                                  Text(
                                      task.task_deadline +
                                          " ${AppLocalizations.of(context)!.at} " +
                                          task.task_start_time,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTheme.text3),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            myDivider(),
          ],
        ),
      );
}
