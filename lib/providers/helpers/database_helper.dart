import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:manage_life_app/models/note_model.dart';
import 'package:manage_life_app/models/notification_model.dart';
import 'package:manage_life_app/models/project_model.dart';
import 'package:manage_life_app/models/folder_model.dart';
import 'package:manage_life_app/models/task_model.dart';
import 'package:manage_life_app/providers/general_app_cubit/app_general_cubit.dart';
import 'package:manage_life_app/providers/task_bloc/task_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:manage_life_app/api/notification_api.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DatabaseHelper {

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static late Database _db;

  // Tasks Table
  String tasksTable = 'tasks_tbl';
  String colId = 'id';
  String colTitle = 'task_title';
  String colDescription = 'task_description';
  String colStartDate = 'task_start_date';
  String colDeadline = 'task_deadline';
  String colStartTime = 'task_start_time';
  String colEndTime = 'task_end_time';
  String colPriority = 'priority';
  String colStatus = 'status';
  String colIsArchived = 'is_archived';
  String colFolderTagged = 'folder_folderged';
  String colProjectTagged = 'project_folderged';

  // Categories/folders Table
  String foldersTable = 'folders_tbl';
  String colTagId = 'id';
  String colTagTitle = 'folder_title';
  String colTagContent = 'folder_content';
  String colTagIcon = 'folder_icon';
  String folderColor = 'folder_color';
  String folderColorIndex = 'folder_color_index';
  String isBuiltIn = 'is_built_in';

  // Notifications Table
  String notificationsTable = 'notifications_tbl';
  String colNotificationId = 'id';
  String colNotificationTitle = 'title';
  String colNotificationbody = 'body';
  String colNotificationTag = 'folder_notification';
  String colNotificationStartDate = 'start_date';
  String colNotificationEndDate = 'end_date';
  String colNotificationStartTime = 'start_time';
  String colNotificationEndTime = 'end_time';
  String colNotificationPayload = 'payload';
  String colNotificationIsOpen = 'is_open';

  // notes Table
  String notesTable      = 'notes_tbl';
  String colNoteId       = 'id';
  String colNoteTitle    = 'note_title';
  String noteDescription = 'note_description';
  String colNoteDate     = 'note_date';
  String colNoteColor      = 'note_color';
  String colIndexOfColor  = 'index_of_color';
  String colNoteIsArchived = 'is_archived';

  // projects Table
  String projectsTable    = 'projects_tbl';
  String colProjectId     = 'id';
  String colProjectTitle  = 'project_title';
  String colProjectDescription = 'project_description';
  String colProjectCreatedAt     = 'project_created_at';
  String colProjectColor        = 'project_color';
  String colProjectIndexOfColor      = 'index_of_color';
  String colProjectIsArchived   = 'is_archived';
  String colProjectStatus     = 'status';
  

  Future<Database> get db async {
    _db = await _initDb();
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + '___mlsnjmm_tasks.db';
    final todoListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $tasksTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colStartDate TEXT, $colDeadline TEXT, $colStartTime TEXT, $colEndTime TEXT, $colPriority FLOAT, $colStatus INTEGER, $colIsArchived INTEGER, $colProjectTagged INTEGER FOREGIN KEY,  $colFolderTagged INTEGER FOREGIN KEY NULL)');
    await db.execute(
        'CREATE TABLE $foldersTable ($colTagId INTEGER PRIMARY KEY AUTOINCREMENT, $colTagTitle TEXT, $colTagContent TEXT, $colTagIcon INTEGER, $folderColor INTEGER, $folderColorIndex INTEGER, $isBuiltIn TEXT)');
    await db.execute(
        'CREATE TABLE $notificationsTable ($colNotificationId INTEGER PRIMARY KEY AUTOINCREMENT, $colNotificationTitle TEXT, $colNotificationbody TEXT, $colNotificationTag TEXT, $colNotificationStartDate TEXT, $colNotificationEndDate TEXT, $colNotificationStartTime TEXT, $colNotificationEndTime TEXT, $colNotificationPayload TEXT, $colNotificationIsOpen INTEGER)');
    await db.execute(
        'CREATE TABLE $notesTable ($colNoteId INTEGER PRIMARY KEY AUTOINCREMENT, $colNoteTitle TEXT, $noteDescription TEXT, $colNoteDate TEXT, $colNoteColor INTEGER, $colIndexOfColor INTEGER, $colNoteIsArchived INTEGER)');
    await db.execute(
        'CREATE TABLE $projectsTable ($colNoteId INTEGER PRIMARY KEY AUTOINCREMENT, $colProjectTitle TEXT, $colProjectDescription TEXT, $colProjectCreatedAt TEXT, $colProjectColor INTEGER, $colIndexOfColor INTEGER, $colProjectIsArchived INTEGER, $colProjectStatus TEXT)');
    // Add Plan Automatically
    FolderModel staticTasks = FolderModel(folder_title: "Static Tasks", folder_content: "Static Tasks", folder_color: 0, folder_color_index: 0,folder_icon: 0, is_built_in: "true");
    await db.insert(foldersTable, staticTasks.toMap());
    FolderModel folderDay = FolderModel(folder_title: "Day Plan", folder_content: "Day Plan", folder_color: 0, folder_color_index: 0,folder_icon: 0, is_built_in: "true");
    await db.insert(foldersTable, folderDay.toMap());
    FolderModel folderWeek = FolderModel(folder_title: "Week Plan", folder_content: "Week Plan", folder_color: 0, folder_color_index: 0,folder_icon: 0, is_built_in: "true");
    await db.insert(foldersTable, folderWeek.toMap());
    FolderModel folderMonth = FolderModel(folder_title: "Month Plan", folder_content: "Month Plan", folder_color: 0, folder_color_index: 0,folder_icon: 0, is_built_in: "true");
    await db.insert(foldersTable, folderMonth.toMap());
    FolderModel folderHalfYear = FolderModel(folder_title: "Half-Year Plan", folder_content: "Half-Year Plan", folder_color: 0, folder_color_index: 0,folder_icon: 0, is_built_in: "true");
    await db.insert(foldersTable, folderHalfYear.toMap());
    FolderModel folderYear = FolderModel(folder_title: "Year Plan", folder_content: "Year Plan", folder_color: 0, folder_color_index: 0,folder_icon: 0, is_built_in: "true");
    await db.insert(foldersTable, folderYear.toMap());
  }

  // --------------- Tasks ---------------
  Future<int> insertDataToTable(context, {Task? task, FolderModel? folder, NotificationModel? notification, Note? note, Project? project}) async {
    Database db = await this.db;
    if(task != null) {
      final int result = await db.insert(tasksTable, task.toMap());

      final DateTime currentDateTime = new DateTime.now();
      final startDateTimeAndTime = task.task_start_date + " " + task.task_start_time;
      final endDateTimeAndTime = task.task_deadline + " " + task.task_end_time;
      DateTime sdt = DateFormat("dd, MMMM yyyy HH:mm a").parse(startDateTimeAndTime);
      DateTime edt = DateFormat("dd, MMMM yyyy HH:mm a").parse(endDateTimeAndTime);


      if(sdt.isAfter(currentDateTime) && currentDateTime != sdt) {
          var random = Random();
          var n1 = random.nextInt(16);
          var n2 = random.nextInt(15);
          if (n2 >= n1) n2 += 1;


          NotificationAPI.showScheduleNotification(context,
            id: n2,
            title: task.task_title,
            body: AppLocalizations.of(context)!.notificationForStartTask,
            // body: "Due Date (" + task.task_start_date.toString() + " -> " +  task.task_deadline.toString() + " )",
            // folder_notification: task.folder_title,
            startScheduleDate: sdt,
            endScheduleDate: edt,
            start_time: task.task_start_time,
            payload: n2.toString(),
          ).then((value) {
              NotificationModel notificationModel = NotificationModel(
                title: task.task_title, 
                body: AppLocalizations.of(context)!.notificationForStartTask, 
                // folder_notification: task.folder_title, 
                start_date: task.task_start_date, 
                end_date: task.task_deadline, 
                start_time:  task.task_start_time, 
                end_time:  task.task_end_time, 
                payload: n2.toString(),
                is_open: 0,
              );

              DatabaseHelper.instance.insertDataToTable(context, notification: notificationModel);
          });

          // NotificationAPI.showScheduleNotification(
          //   id: n2,
          //   title: task.task_title,
          //   body: "Reminder: You shoud finish this task after 30 minutes from Now",
          //   folder_notification: task.folder_title,
          //   startScheduleDate: sdt,
          //   endScheduleDate: edt,
          //   start_time: task.task_start_time,
          //   payload: n2.toString(),
          //   remindeForDeadline: true,
          // );

          // NotificationModel deadlineNotificationModel = NotificationModel(
          //   title: task.task_title, 
          //   body: "Reminder: You shoud finish this task after 30 minutes from Now",
          //   folder_notification: task.folder_title, 
          //   start_date: task.task_start_date, 
          //   end_date: task.task_deadline, 
          //   start_time:  task.task_start_time, 
          //   payload: n2.toString()
          // );

          // Workmanager().registerOneOffTask(
          //   "TestTask",
          //   "TestTask",
          //   inputData: {"test":"done"},
          // ).then((value) {
          //   DatabaseHelper.instance.insertDataToTable(notification: notificationModel);
          // });
          
          // --------- Note: Timer Not work if app is locked
          // Timer(sdt.difference(DateTime.now()), () {
          //    DatabaseHelper.instance.insertDataToTable(context, notification: notificationModel);
          //   //  DatabaseHelper.instance.insertDataToTable(notification: deadlineNotificationModel);
          //    AppCubit().getAllNotifications();
          // });
      }
      
      return result;
    } else if (folder != null) {
      final int result = await db.insert(foldersTable, folder.toMap());
      return result;
    } else if (notification != null) {
      final int result = await db.insert(notificationsTable, notification.toMap());
      return result;
    } else if (note != null) {
      final int result = await db.insert(notesTable, note.toMap());
      return result;
    } else if (project != null) {
      final int result = await db.insert(projectsTable, project.toMap());
      return result;
    }

    return 0;
  }

  Future<int> updateTable({Task? task, FolderModel? folder, Note? note, Project? project}) async {
    Database db = await this.db;
    if(task != null) {
      final int result = await db.update(tasksTable, task.toMap(),
      where: '$colId = ?', whereArgs: [task.id]);
      return result;
    } else if (folder != null) {
      final int result = await db.update(foldersTable, folder.toMap(),
      where: '$colTagId = ?', whereArgs: [folder.id]);
      return result;
    } else if (note != null) {
      final int result = await db.update(notesTable, note.toMap(),
      where: '$colNoteId = ?', whereArgs: [note.id]);
      return result;
    } else if (project != null) {
      final int result = await db.update(projectsTable, project.toMap(),
      where: '$colProjectId = ?', whereArgs: [project.id]);
      return result;
    } 

    return 0;
  }

  Future<int> deleteFromTable(String? table, int? id, {forFolderTasks = false}) async {
    Database db = await this.db;
    if(table == "tasks") {
      final int result = await db.delete(tasksTable, where: forFolderTasks ? '$colFolderTagged = ?' : '$colId = ?', whereArgs: [id]);
      return result;
    } else if (table == "folders") {
      final int result = await db.delete(foldersTable, where: '$colTagId = ?', whereArgs: [id]);
      return result;
    } else if (table == "notifications") {
      final int result = await db.delete(notificationsTable, where: '$colNotificationId = ?', whereArgs: [id]);
      return result;
    } else if (table == "notes") {
      final int result = await db.delete(notesTable, where: '$colNoteId = ?', whereArgs: [id]);
      return result;
    } else if (table == "projects") {
      final int result = await db.delete(projectsTable, where: '$colProjectId = ?', whereArgs: [id]);
      return result;
    }
    return 0;
  }


}
