import 'package:auto_animated/auto_animated.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:manage_life_app/layout/search/search_screen.dart';
import 'package:manage_life_app/layout/tasks_screens/list_of_tasks.dart';
import 'package:manage_life_app/models/task_model.dart';
import 'package:manage_life_app/modules/widgets/state_widgets.dart';
import 'package:manage_life_app/modules/widgets/wide_app_bar.dart';
import 'package:manage_life_app/routes/argument_bundle.dart';
import 'package:manage_life_app/providers/task_bloc/task_bloc.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/styles/themes.dart';
import 'package:manage_life_app/shared/utiles/extensions.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';

import '../../routes/page_path.dart';

class TaskItems extends StatelessWidget {

  final ArgumentBundle bundle;

  TaskItems({required this.bundle});

  var title;
  var tasks;

  @override
  Widget build(BuildContext context) {
    var typeOfTasks = bundle.identifier;
    var tagName = bundle.extras;
    
    return BlocConsumer<TaskCubit, TaskStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var taskCubit = TaskCubit.get(context);
          if(typeOfTasks == "all_tasks") {
            title = Text("All Tasks", style: TextStyle(color: Colors.white));
            tasks = taskCubit.allTasksList;
          } else if (typeOfTasks == "static") {
            title = Text("Static Tasks", style: TextStyle(color: Colors.white));
            tasks = taskCubit.staticTasksList;
          } else if (typeOfTasks == "inprogress") {
            title = Text("Inprogress Tasks", style: TextStyle(color: Colors.white));
            tasks = taskCubit.inProgressTasksList;
          } else if (typeOfTasks == "priority") {
            title = Text("Priority Tasks", style: TextStyle(color: Colors.white));
            tasks = taskCubit.priorityTasksList;
          } else if (typeOfTasks == "might") {
            title = Text("Might Tasks", style: TextStyle(color: Colors.white));
            tasks = taskCubit.mightTasksList;
          } else if (typeOfTasks == "done") {
            title = Text("Done Tasks", style: TextStyle(color: Colors.white));
            tasks = taskCubit.doneTasksList;
          } else if (typeOfTasks == "archived") {
            title = Text("Archived Tasks", style: TextStyle(color: Colors.white));
            tasks = taskCubit.archivedTasksList;
          } else if (typeOfTasks == "day") {
            title = Text("Day Plan", style: TextStyle(color: Colors.white));
            tasks = taskCubit.dayPlan;
          } else if (typeOfTasks == "week") {
            title = Text("Week Plan", style: TextStyle(color: Colors.white));
            tasks = taskCubit.weekPlan;
          } else if (typeOfTasks == "month") {
            title = Text("Month Plan", style: TextStyle(color: Colors.white));
            tasks = taskCubit.monthPlan;
          } else if (typeOfTasks == "half_year") {
            title = Text("Half-Year Plan", style: TextStyle(color: Colors.white));
            tasks = taskCubit.halfYearPlan;
          } else if (typeOfTasks == "year") {
            title = Text("Year Plan", style: TextStyle(color: Colors.white));
            tasks = taskCubit.yearPlan;
          } else if (typeOfTasks == "project") {
            tasks = taskCubit.tasksOfProjectData;
            title = Text("Project Tasks", style: TextStyle(color: Colors.white));
          } else {
            tasks = taskCubit.tasksFolderData;
            title = Text("Tasks Taged ( " + tagName + " )", style: TextStyle(color: Colors.white));
          }

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                    Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              elevation: 0,
              backgroundColor: mainColor,
              title: title,
              titleSpacing: 0,
              shadowColor: Colors.transparent,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        PagePath.searchScreen,
                        arguments: ArgumentBundle(extras: "Tasks Search", identifier: 'tasks'),
                      );
                    },
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                ),
                IconButton(
                    onPressed: () {
                      taskCubit.tasksToggleView();
                    },
                    icon: Icon(
                      taskCubit.tasksListView ? Icons.view_headline : Icons.view_agenda_rounded,
                      color: Colors.white,
                    )
                ),

                IconButton(
                    onPressed: () {
                      Helper.showMoreDetailsBottomSheet(context);
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    )
                ),
                
              ],
            ),
            body: Container(
              child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: ConditionalBuilder(
                    condition: state is! GettingTasksLoading || state is! GetNewSortLoading || state is! CreateTaskDatabaseLoading || state is! ToggleAsDoneTask,
                    builder: (context) => Container(
                      child: ConditionalBuilder(
                        condition: tasks.length != 0,
                        builder: (context) => Column(
                          children: List.generate(
                            tasks.length,
                                (index) {
                              return ListOfTasks(bundle: ArgumentBundle(extras: tasks[index]),);
                            },
                          ),
                        ),
                        fallback: (context) => Center(
                          child: SvgPicture.asset(Resources.empty, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * .75,),),
                      ),
                    ),
                    fallback: (context) => Center(child: CircularProgressIndicator(color: mainColor,), heightFactor: 15,),
                  )
              ),
            ),
            floatingActionButton: FloatingActionButton(
                  backgroundColor: mainColor,
                  child: Icon(Icons.add),
                  onPressed: () {
                    if(isNumeric(typeOfTasks.toString())) {
                      Helper.showTaskBottomSheet(context, folderId: typeOfTasks);
                    } else {
                      Helper.showTaskBottomSheet(context);
                    }
                  }
              ),
          );
        }
    );
  }
}
