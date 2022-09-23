
import 'package:day_night_time_picker/lib/common/filter_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:manage_life_app/main.dart';
import 'package:manage_life_app/models/folder_model.dart';
import 'package:manage_life_app/models/task_model.dart';
import 'package:manage_life_app/providers/helpers/database_helper.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/providers/task_bloc/task_bloc.dart' as TaskBloc;
import 'package:manage_life_app/providers/task_bloc/task_bloc.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/components/default_form_field.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/styles/themes.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:manage_life_app/shared/utiles/extensions.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:time_range_picker/time_range_picker.dart';

import 'buttons.dart';
import 'state_widgets.dart';

class TaskSheet extends StatefulWidget {

  bool isUpdate;
  int taskId;

  TaskSheet(this.isUpdate, this.taskId);

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  State<TaskSheet> createState() => _TaskSheetState();
}

class _TaskSheetState extends State<TaskSheet> {
  Task? task;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final DateRangePickerController dateController = DateRangePickerController();

  @override
  void initState() {
    super.initState();
    titleController = new TextEditingController();
    descriptionController = new TextEditingController();
  }

  bool isCompleted = false;

  bool isPriority = false;

  double? rating;

  var currentTagName;

  var startDate;
  var endDate;
  var startTime;
  var endTime;
  double? priority;
  var status = 0;
  var isArchived = 0;
  var tag_id;
  var project_tagged;

  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    String plusOneHourFromNow = now.add(Duration(hours: 1)).format('hh:mm a').toString();
    String currentTime = new DateFormat('hh:mm a').format(now).toString();
    
    var cubit = TaskBloc.TaskCubit.get(context);
    List taskData = [];
    List tagData = [];

    return BlocConsumer<TaskCubit, TaskStates>(
      listener: (context, state) {},
      builder: (context, state) {

        var titleVal;

        if(widget.isUpdate) {
          taskData = cubit.taskData.toList();
          if(taskData.length != 0) {
            titleController = TextEditingController()..text = taskData[0]['task_title'].toString();
            descriptionController = TextEditingController()..text= taskData[0]["task_description"].toString();
            startDate = taskData[0]["task_start_date"];
            endDate = taskData[0]["task_deadline"];
            startTime = taskData[0]["task_start_time"];
            endTime = taskData[0]["task_end_time"];
            priority = state is! TaskRating ? taskData[0]["priority"] : cubit.taskRating;
            status = taskData[0]['status'] != null ? taskData[0]['status'] : 0;
            isArchived = taskData[0]['is_archived'] != null ? taskData[0]['is_archived'] : 0;
            endTime = taskData[0]["task_end_time"];
            currentTagName = taskData[0]['tag_title'];
            project_tagged = taskData[0]['project_tagged'];
          } 
        } else {
          // tagData = cubit.tagData.toList();
          // if(tagData.length != 0) {
          //   currentTagName = tagData[0]['tag_title'];
          // } else {
          //   currentTagName = "Tag";
          // }
          startDate = cubit.startDate;
          endDate = cubit.endDate;
          startTime = cubit.fromTime;
          endTime = cubit.toTime;
          priority = cubit.taskRating;
          tag_id = cubit.folderId;
        }



        return Material(
          child: SafeArea(
            top: false,
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                color: Theme.of(context).cardColor,
                child: state is GettingTaskDataLoading
                    ? Center(child: CircularProgressIndicator(color: mainColor,),)
                    : SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Form(
                          key: TaskSheet.formKey,
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 50,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (widget.isUpdate && status == 1)
                                          SvgPicture.asset(
                                            Resources.complete,
                                            width: 50,
                                            height: 40,),
                                        const SizedBox(width: 5,),
                                        if (widget.isUpdate)
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.green,
                                            child: IconButton(
                                              icon: Icon(
                                                isArchived == 0 ? Icons.archive : Icons.unarchive_outlined,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                if (TaskSheet.formKey.currentState!.validate()) {
                                                  if(isArchived == 0) {
                                                    task!.is_archived = 1;
                                                    DatabaseHelper.instance.updateTable(task: task!);
                                                    TaskCubit.get(context).getTaskList(sortBy: CacheHelper.getData(key: "sortType"));
                                                    Navigator.pop(context);
                                                    Helper.showCustomSnackBar(context, content: "Task Archived Successfully!", bgColor: mainColor, textColor: Colors.white);
                                                  } else {
                                                     task!.is_archived = 0;
                                                    DatabaseHelper.instance.updateTable(task: task!);
                                                    TaskCubit.get(context).getTaskList(sortBy: CacheHelper.getData(key: "sortType"));
                                                    Navigator.pop(context);
                                                    Helper.showCustomSnackBar(context, content: "Task Unarchived Successfully!", bgColor: mainColor, textColor: Colors.white);
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                        const SizedBox(width: 5,),
                                        if (widget.isUpdate)
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.red,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.delete_forever,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                if (TaskSheet.formKey.currentState!.validate()) {
                                                  DatabaseHelper.instance.deleteFromTable(
                                                      "tasks", widget.taskId
                                                  ).then((value) {
                                                    Navigator.pop(context);
                                                    Helper.showCustomSnackBar(context, content: "Task Deleted Successfully!", bgColor: Colors.red, textColor: Colors.white);
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        
                                        Spacer(),
                                        Center(
                                          child: Text(
                                              widget.isUpdate ? 'Edit Task' : 'Add Task',
                                              style: Theme.of(context).textTheme.headline3,
                                          ),
                                        ),
                                        Spacer(),
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundColor: mainColor,
                                          child: IconButton(
                                            icon: Icon(
                                              widget.isUpdate ? Icons.check : Icons.arrow_upward,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              if (TaskSheet.formKey.currentState!.validate()) {
                                                if(widget.isUpdate) {
                                                  Task task = Task(
                                                    task_title: titleController.text, 
                                                    task_description: descriptionController.text, 
                                                    task_start_date: startDate,
                                                    task_deadline: endDate,
                                                    task_start_time: startTime,
                                                    task_end_time: endTime,
                                                    priority: priority,
                                                    // folder_tagged: cubit.tagId,
                                                    project_tagged: cubit.projectTaggedId,
                                                  );

                                                  task.id = widget.taskId;
                                                  DatabaseHelper.instance.updateTable(task: task).then((value) {
                                                    descriptionController.clear();
                                                    titleController.clear();
                                                    cubit.getTaskList(sortBy: CacheHelper.getData(key: "sortType"));
                                                    Navigator.pop(context);
                                                    Helper.showCustomSnackBar(context, content: "Task Updated Successfully!", bgColor: Colors.green, textColor: Colors.white);
                                                  });

                                                } else {

                                                  Task task = Task(
                                                    task_title: titleController.text, 
                                                    task_description: descriptionController.text, 
                                                    task_start_date: startDate, 
                                                    task_deadline: endDate, 
                                                    task_start_time: startTime, 
                                                    task_end_time: endTime, 
                                                    priority: priority,
                                                    status: 0,
                                                    is_archived: 0, 
                                                    // folder_tagged: cubit.tagId, 
                                                    project_tagged: cubit.projectTaggedId,
                                                  );
                                          
                                                  DatabaseHelper.instance.insertDataToTable(context, task: task).then((value) {
                                                    cubit.getTaskList(sortBy: CacheHelper.getData(key: "sortType"));
                                                    titleController.clear();
                                                    descriptionController.clear();
                                                    cubit.fromTime = currentTime;
                                                    cubit.toTime = plusOneHourFromNow;
                                                    Helper.showCustomSnackBar(context, content: "Task Inserted Successfully!", bgColor: Colors.green, textColor: Colors.white);
                                                  });

                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              state is! GettingTaskDataLoading ? Container(
                                padding: EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const SizedBox(height: 20),
                                    DefaultFormField(
                                      controller: titleController,
                                      label: 'Task Title',
                                      autoFocus: widget.isUpdate ? false : true,
                                      focusedColorBorder: mainColor,
                                      hintText: 'Task title',
                                      labelColor: Theme.of(context).textTheme.bodyMedium!.color,
                                      hintColor: Theme.of(context).textTheme.bodyMedium!.color,
                                      type: TextInputType.text,
                                      prefixColorIcon: mainColor,
                                      prefix: Icons.task,
                                      validate: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your title Task';
                                        }
                                        return null;
                                      },
                                      borderColor: Colors.grey,
                                    ),
                                    const SizedBox(height: 10),
                                    DefaultFormField(
                                      controller: descriptionController,
                                      label: 'Task Description',
                                      onChange: (text) {
                                      },
                                      focusedColorBorder: mainColor,
                                      type: TextInputType.text,
                                      prefixColorIcon: mainColor,
                                      labelColor: Theme.of(context).textTheme.bodyMedium!.color,
                                      minLines: 2,
                                      maxLines: 6,
                                      prefix: Icons.description_outlined,
                                      borderColor: Colors.grey,
                                    ),
                                    const SizedBox(height: 10),
                                    if(cubit.isPriority)
                                      SizedBox(
                                        // height: 60,
                                        child: Row(
                                          children: [
                                            RatingBar.builder(
                                              initialRating: priority!,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: false,
                                              itemCount: 5,
                                              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (double rating) {
                                                cubit.getTaskRating(rating);
                                              },
                                            ),
                                            Spacer(),
                                            IconButton(
                                                onPressed: () {
                                                  cubit.isPriorityChanged();
                                                },
                                                icon: Icon(
                                                    Icons.cancel,
                                                  color: Colors.red,
                                                ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if(cubit.isPriority)
                                      const SizedBox(height: 10,),
                                    Container(
                                      height: 35,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [ 
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: Theme.of(context).cardColor,
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                padding: EdgeInsetsDirectional.only(top: 0, bottom: 0, start: 5, end: 8),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                                side: BorderSide(
                                                    color: Colors.grey.withOpacity(.3)),
                                                primary: Theme.of(context).textTheme.bodyText1?.color,
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  priorityBuilder(priority),
                                                  const SizedBox(width: 4,),
                                                  Text("Priority"),
                                                ],
                                              ),
                                              onPressed: () {
                                                cubit.isPriorityChanged();
                                                // showDialog(
                                                //   context: context,
                                                //   builder: (context) => AlertDialog(
                                                //     shape: RoundedRectangleBorder(
                                                //         borderRadius: BorderRadius.circular(4.0)
                                                //     ),
                                                //     content: Stack(
                                                //       alignment: Alignment.topCenter,
                                                //       clipBehavior: Clip.none,                                                                    children: [
                                                //       Container(
                                                //         height: 190,
                                                //         child: Padding(
                                                //           padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                                                //           child: Column(
                                                //             children: [
                                                //               Text('Priority', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                                //               const SizedBox(height: 10,),
                                                //               Center(
                                                //                 child: RatingBar.builder(
                                                //                   initialRating: priority!,
                                                //                   minRating: 1,
                                                //                   direction: Axis.horizontal,
                                                //                   allowHalfRating: false,
                                                //                   itemCount: 5,
                                                //                   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                //                   itemBuilder: (context, _) => Icon(
                                                //                     Icons.star,
                                                //                     color: Colors.amber,
                                                //                   ),
                                                //                   onRatingUpdate: (double rating) {
                                                //                     cubit.getTaskRating(rating);
                                                //                   },
                                                //                 ),
                                                //               ),
                                                //               const SizedBox(height: 30,),
                                                //               Container(
                                                //                 color: mainColor,
                                                //                 child: TextButton(
                                                //                     onPressed: () => Navigator.of(context).pop(),
                                                //                     child: Text('Ok', style: TextStyle(color: Colors.white),)
                                                //                 ),
                                                //               ),
                                                //             ],
                                                //           ),
                                                //         ),
                                                //       ),
                                                //       Positioned(
                                                //           top: -50,
                                                //           child: CircleAvatar(
                                                //             backgroundColor: mainColor,
                                                //             radius: 30,
                                                //             child: Icon(Icons.star, color: Colors.white, size: 50,),
                                                //           )
                                                //       ),
                                                //     ],
                                                //     ),
                                                //   ),
                                                // );
                                              },
                                            ),
                                            const SizedBox(width: 7,),
                                            // OutlinedButton(
                                            //   style: OutlinedButton.styleFrom(
                                            //     backgroundColor: Theme.of(context).cardColor,
                                            //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            //     padding: EdgeInsetsDirectional.only(top: 0, bottom: 0, start: 5, end: 8),
                                            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                            //     side: BorderSide(
                                            //         color: Colors.grey.withOpacity(.3)),
                                            //     primary: Theme.of(context).textTheme.bodyText1?.color,
                                            //   ),
                                            //     child: Row(
                                            //       mainAxisAlignment: MainAxisAlignment.start,
                                            //       children: [
                                            //         Icon(
                                            //           Icons.tag,
                                            //           color: mainColor,
                                            //           size: 15,
                                            //         ),
                                            //         const SizedBox(width: 4,),
                                            //         Center(
                                            //           child: Container(
                                            //             height: 25,
                                            //             child: DropdownButton(
                                            //               dropdownColor: Theme.of(context).cardColor,
                                            //               underline: Container(width: 0,),
                                            //               icon: Container(width: 0,),
                                            //               onTap: () => Helper.unfocus(),
                                            //               onChanged: (value) {
                                            //                 cubit.getTag(value);
                                            //               },
                                            //               items: cubit.allProjectsList
                                            //                   .map((e) {
                                            //                 return DropdownMenuItem(
                                            //                   value: e.id,
                                            //                   child: Text(
                                            //                     e.project_title!,
                                            //                     style: Theme.of(context).textTheme.bodyMedium
                                            //                   ),
                                            //                 );
                                            //               }).toList(),
                                            //               style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            //                 backgroundColor: Theme.of(context).cardColor,
                                            //               ),
                                            //               value: project_tagged,
                                            //             ),
                                            //           ),
                                            //         ),
                                            //       ],
                                            //     ),
                                            //   onPressed: () {

                                            //   },
                                            // ),
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: Theme.of(context).cardColor,
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                padding: EdgeInsetsDirectional.only(top: 0, bottom: 0, start: 5, end: 8),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                                side: BorderSide(
                                                    color: Colors.grey.withOpacity(.3)),
                                                primary: Theme.of(context).textTheme.bodyText1?.color,
                                              ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.layers,
                                                      color: mainColor,
                                                      size: 15,
                                                    ),
                                                    const SizedBox(width: 4,),
                                                    Center(
                                                      child: Container(
                                                        height: 25,
                                                        child: DropdownButton(
                                                          dropdownColor: Theme.of(context).cardColor,
                                                          underline: Container(width: 0,),
                                                          icon: Container(width: 0,),
                                                          onTap: () => Helper.unfocus(),
                                                          onChanged: (value) {
                                                            cubit.getProjectTagged(value);
                                                          },
                                                          items: cubit.allProjectsList
                                                              .map((e) {
                                                            return DropdownMenuItem(
                                                              value: e.id,
                                                              child: Text(
                                                                e.project_title!,
                                                                style: Theme.of(context).textTheme.bodyMedium
                                                              ),
                                                            );
                                                          }).toList(),
                                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                            backgroundColor: Theme.of(context).cardColor,
                                                          ),
                                                          value: cubit.projectTaggedId,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              onPressed: () {

                                              },
                                            ),
                                            const SizedBox(width: 7,),
                                            if(cubit.isSelectedDuration == false)
                                              OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  backgroundColor: Theme.of(context).cardColor,
                                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  padding: EdgeInsetsDirectional.only(top: 0, bottom: 0, start: 5, end: 8),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                                  side: BorderSide(
                                                      color: Colors.grey.withOpacity(.3)),
                                                  primary: Theme.of(context).textTheme.bodyText1?.color,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.date_range,
                                                      color: Colors.green,
                                                      size: 15,
                                                    ),
                                                    const SizedBox(width: 4,),
                                                    Text(
                                                      "${startDate != null && DateFormat('dd, MMMM yyyy').format(now).toString() != cubit.startDate ? startDate : "Today"}, ${startTime != null && startTime != cubit.toTime ? startTime : "Now"}",
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  cubit.selectedDuration();
                                                  print(cubit.isSelectedDuration);
                                                },
                                              ),
                                          ],
                                        ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    if(cubit.isSelectedDuration)
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if(cubit.isSelectedDuration)
                                            Row(
                                            children: [
                                              Icon(
                                                Icons.update_outlined,
                                                color: Colors.green,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 6,),
                                              Text(
                                                "Task Duration",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Spacer(),
                                              IconButton(
                                                  onPressed: () {
                                                    cubit.selectedDuration();
                                                  },
                                                  icon: Icon(
                                                      Icons.cancel,
                                                    color: Colors.red,
                                                  ),
                                              ),
                                            ],
                                          ),
                                          if(cubit.isSelectedDuration)
                                            const SizedBox(height: 10,),
                                          if(cubit.isSelectedDuration)
                                            Row(
                                              children: [
                                                Text(
                                                    "From: "
                                                ),
                                                const SizedBox(width: 2,),
                                                Expanded(
                                                  flex: 1,
                                                  child: DateButton(
                                                    onTap: () {
                                                      showDialog<Widget>(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return _datePicker(context, cubit);
                                                          });
                                                      
                                                    },
                                                    text: startDate != null ? startDate : "Start Date",
                                                    prefixWidget: Icon(
                                                        Icons.date_range,
                                                      color: Colors.green,
                                                      size: 15,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 5,),
                                                Text(
                                                    "To: "
                                                ),
                                                const SizedBox(width: 2,),
                                                Expanded(
                                                  flex: 1,
                                                  child: DateButton(
                                                    onTap: () {
                                                      showDialog<Widget>(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return _datePicker(context, cubit);
                                                          });
                                                    },
                                                    text: endDate != null ? endDate : "End Date",
                                                    prefixWidget: Icon(
                                                        Icons.date_range,
                                                      color: Colors.green,
                                                      size: 15,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                              ]),
                                          if(cubit.isSelectedDuration)
                                            const SizedBox(height: 10,),
                                          if(cubit.isSelectedDuration)
                                            Row(
                                              children: [
                                                Text(
                                                    "From: "
                                                ),
                                                const SizedBox(width: 2,),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    child: DateButton(
                                                      onTap: () {
                                                        // showTimeRangePicker(
                                                        //   context: context,
                                                        //   rotateLabels: false,
                                                        //   start: TimeOfDay(hour: now.hour, minute: now.minute),
                                                        //   end: TimeOfDay(hour: now.hour + 1, minute: now.minute),
                                                        //   onStartChange: (start) {
                                                        //     cubit.getTaskRangeTime(start: start.format(context));
                                                        //   },
                                                        //   onEndChange: (end) {
                                                        //     cubit.getTaskRangeTime(end: end.format(context));
                                                        //   },
                                                        //   use24HourFormat: false,
                                                        //   padding: 30,
                                                        //   strokeWidth: 20,
                                                        //   handlerRadius: 14,
                                                        //   strokeColor: mainColor,
                                                        //   selectedColor: mainColor,
                                                        //   backgroundColor: Colors.black.withOpacity(0.3),
                                                        //   ticks: 12,
                                                        //   ticksColor: Colors.white,
                                                        //   snap: true,
                                                        //   labels: [
                                                        //     "12 am",
                                                        //     "3 am",
                                                        //     "6 am",
                                                        //     "9 am",
                                                        //     "12 pm",
                                                        //     "3 pm",
                                                        //     "6 pm",
                                                        //     "9 pm"
                                                        //   ].asMap().entries.map((e) {
                                                        //     return ClockLabel.fromIndex(
                                                        //         idx: e.key, length: 8, text: e.value);
                                                        //   }).toList(),
                                                        //   labelOffset: -30,
                                                        //   labelStyle: TextStyle(
                                                        //       fontSize: 22,
                                                        //       color: Colors.grey,
                                                        //       fontWeight: FontWeight.bold),
                                                        //   timeTextStyle: TextStyle(
                                                        //       color: Colors.white70,
                                                        //       fontSize: 24,
                                                        //       fontStyle: FontStyle.italic,
                                                        //       fontWeight: FontWeight.bold),
                                                        //   activeTimeTextStyle: TextStyle(
                                                        //       color: Colors.grey,
                                                        //       fontSize: 26,
                                                        //       fontStyle: FontStyle.italic,
                                                        //       fontWeight: FontWeight.bold),
                                                        // );
                                                        _selectTime(context, cubit, true);
                                                      },
                                                      text: startTime != null ? startTime : currentTime,
                                                      prefixWidget: Icon(
                                                        Icons.timer,
                                                        color: Colors.green,
                                                        size: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 5,),
                                                Text(
                                                    "To: "
                                                ),
                                                const SizedBox(width: 2,),
                                                Expanded(
                                                  flex: 1,
                                                  child: DateButton(
                                                    onTap: () {
                                                      // showTimeRangePicker(
                                                      //   context: context,
                                                      //   rotateLabels: false,
                                                      //   start: TimeOfDay(hour: now.hour, minute: now.minute),
                                                      //   end: TimeOfDay(hour: now.hour + 1, minute: now.minute),
                                                      //   onStartChange: (start) {
                                                      //     cubit.getTaskRangeTime(start: start.format(context));
                                                      //   },
                                                      //   onEndChange: (end) {
                                                      //     cubit.getTaskRangeTime(end: end.format(context));
                                                      //   },
                                                      //   use24HourFormat: false,
                                                      //   padding: 30,
                                                      //   strokeWidth: 20,
                                                      //   handlerRadius: 14,
                                                      //   strokeColor: mainColor,
                                                      //   selectedColor: mainColor,
                                                      //   backgroundColor: Colors.black.withOpacity(0.3),
                                                      //   ticks: 12,
                                                      //   ticksColor: Colors.white,
                                                      //   snap: true,
                                                      //   labels: [
                                                      //     "12 am",
                                                      //     "3 am",
                                                      //     "6 am",
                                                      //     "9 am",
                                                      //     "12 pm",
                                                      //     "3 pm",
                                                      //     "6 pm",
                                                      //     "9 pm"
                                                      //   ].asMap().entries.map((e) {
                                                      //     return ClockLabel.fromIndex(
                                                      //         idx: e.key, length: 8, text: e.value);
                                                      //   }).toList(),
                                                      //   labelOffset: -30,
                                                      //   labelStyle: TextStyle(
                                                      //       fontSize: 22,
                                                      //       color: Colors.grey,
                                                      //       fontWeight: FontWeight.bold),
                                                      //   timeTextStyle: TextStyle(
                                                      //       color: Colors.white70,
                                                      //       fontSize: 24,
                                                      //       fontStyle: FontStyle.italic,
                                                      //       fontWeight: FontWeight.bold),
                                                      //   activeTimeTextStyle: TextStyle(
                                                      //       color: Colors.grey,
                                                      //       fontSize: 26,
                                                      //       fontStyle: FontStyle.italic,
                                                      //       fontWeight: FontWeight.bold),
                                                      // );
                                                      _selectTime(context, cubit, false);
                                                    },
                                                    text: endTime != null ? endTime : plusOneHourFromNow,
                                                    prefixWidget: Icon(
                                                      Icons.timer,
                                                      color: Colors.green,
                                                      size: 15,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                              ]),
                                        ],
                                      ),

                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ) : Padding (
                                padding: const EdgeInsets.only(bottom: 50, top: 30),
                                child: Center(child: CircularProgressIndicator(color: mainColor,),),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  _datePicker(context, cubit) {
    return Container(
      margin: EdgeInsetsDirectional.only(
          start: 10,
          end: 10,
          top: MediaQuery.of(context).size.height * 0.15,
          bottom: MediaQuery.of(context).size.height * 0.15
      ),
      child: SfDateRangePicker(
        controller: dateController,
        headerHeight: 80,
        backgroundColor: Colors.white,
        showActionButtons: true,
        selectionMode: DateRangePickerSelectionMode.range,
        showNavigationArrow: true,
        minDate: DateTime(2020),
        maxDate: DateTime(2040),
        initialSelectedDate: DateTime.now(),
        view: DateRangePickerView.month,
        selectionTextStyle: const TextStyle(color: Colors.white),
        selectionColor: mainColor,
        startRangeSelectionColor: mainColor,
        endRangeSelectionColor: mainColor,
        rangeSelectionColor: mainColor.withOpacity(.9),
        todayHighlightColor: mainColor,
        rangeTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        headerStyle: DateRangePickerHeaderStyle(
            backgroundColor: mainColor,
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              fontStyle: FontStyle.normal,
              fontSize: 25,
              letterSpacing: 5,
              color: Colors.white,
            )),
        monthViewSettings: DateRangePickerMonthViewSettings(
            dayFormat: 'EEE',
            viewHeaderStyle: DateRangePickerViewHeaderStyle(
                backgroundColor: Colors.grey[500],
                textStyle: TextStyle(fontSize: 14, letterSpacing: 4))),
        onSubmit: (Object? value) {
          Navigator.pop(context);
        },
        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) => cubit.getTaskDate(args),
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    );
  }


  _selectTime(BuildContext context, cubit, forStartTime) async {
      DateTime now = new DateTime.now();
      // Convert (Start & End) time from string to datetime
      DateTime startTimeAsDateTime = DateFormat.jm().parse(startTime);
      DateTime endTimeAsDateTime = DateFormat.jm().parse(endTime);
      // Convert (Start & End) time from datetime to string (As 24 hours) 
      String startTimeAs24Hours = DateFormat("HH:mm").format(startTimeAsDateTime);
      String endTimeAs24Hours = DateFormat("HH:mm").format(endTimeAsDateTime);
      // Finnaly: Convert (Start & End) time from string to TimeOfDay (As 24 hours) 
      TimeOfDay startTimeAsTimeOfDay = TimeOfDay.now().replacing(hour: int.parse(startTimeAs24Hours.split(' ').removeAt(0).split(":")[0]), minute: int.parse(startTimeAs24Hours.split(' ').removeAt(0).split(":")[1]));
      TimeOfDay endTimeAsTimeOfDay = TimeOfDay.now().replacing(hour: int.parse(endTimeAs24Hours.split(' ').removeAt(0).split(":")[0]), minute: int.parse(endTimeAs24Hours.split(' ').removeAt(0).split(":")[1]));
      
      TimeOfDay initialTime;
      
      if(forStartTime) {
        initialTime = startTime == null ? TimeOfDay(hour: now.hour, minute: now.minute) : startTimeAsTimeOfDay;
      } else {
        initialTime = endTime == null ? TimeOfDay(hour: now.hour + 1, minute: now.minute) : endTimeAsTimeOfDay;
      }
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: initialTime,
        initialEntryMode: TimePickerEntryMode.dial,
      );
      
      if(time != null && time != selectedTime) {
        forStartTime ? cubit.getTaskRangeTime(start: time.format(context)) : cubit.getTaskRangeTime(end: time.format(context));
      }
  }
}
