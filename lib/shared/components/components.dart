import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manage_life_app/layout/pomodoro/test.dart';
import 'package:manage_life_app/layout/tasks_screens/countdown-page.dart';
import 'package:manage_life_app/layout/tasks_screens/folder_screen.dart';
import 'package:manage_life_app/layout/pomodoro/pomodoro_technique.dart';
import 'package:manage_life_app/layout/tasks_screens/task_items.dart';
import 'package:manage_life_app/models/folder_model.dart';
import 'package:manage_life_app/providers/general_app_cubit/app_general_cubit.dart';
import 'package:manage_life_app/providers/general_app_cubit/states.dart';
import 'package:manage_life_app/providers/helpers/database_helper.dart';
import 'package:manage_life_app/providers/locale_provider.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/providers/task_bloc/task_bloc.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/styles/themes.dart';
import 'package:manage_life_app/shared/utiles/extensions.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:manage_life_app/routes/argument_bundle.dart';
import 'package:provider/provider.dart';
import '../../routes/page_path.dart';

// Navigate component
void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(
  context,
  widget,
) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) {
        return false;
      },
    );

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

// Default Button
Widget defaultTextButton({
  required Function()? function,
  required String text,
  IconData? icon,
}) =>
    TextButton(
      onPressed: function,
      child: Row(
        children: [
          Text(
            text.toUpperCase(),
            style: TextStyle(
              color: mainColor,
              fontSize: 15
            ),
          ),
          SizedBox(width: 1,),
          Icon(
            icon,
            color: mainColor,
            size: 15,
          ),
        ],
      ),
    );

// Divider component
Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );

// Add different things button
Widget actionsButtons() => Stack(
      children: [
        Positioned(
          right: 10,
          bottom: 70,
          child: Container(
            width: 70,
            height: 180,
            child: ListView(
              children: [
                CircleAvatar(
                    radius: 26,
                    backgroundColor: mainColor,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.add_task,
                          color: Colors.white,
                        ))),
                const SizedBox(
                  height: 5,
                ),
                CircleAvatar(
                    radius: 26,
                    backgroundColor: mainColor,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.note_outlined,
                          color: Colors.white,
                        ))),
                const SizedBox(
                  height: 5,
                ),
                CircleAvatar(
                    radius: 26,
                    backgroundColor: mainColor,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.event,
                          color: Colors.white,
                        ))),
              ],
            ),
          ),
        ),
      ],
    );

// Box Builder for boxes
Widget boxBuilder(context, icon, title, number, boxColor, route, data, {is_icon = true, arrow_icon_color, borderColor, titleContainerColor}) {
  return Expanded(
    child: InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        route,
        arguments: ArgumentBundle(extras: data),
      ),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(10),
          color: boxColor,
          border: Border.all(
            color: borderColor != null ? borderColor : boxColor,
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  is_icon ? Icon(
                    icon,
                    color: Colors.white,
                    size: 40,
                  ) : icon,
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(15),
                      color: titleContainerColor != null ? titleContainerColor : Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: titleContainerColor != null ? Colors.white : boxColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Icon(
                    Icons.double_arrow,
                    color: arrow_icon_color != null ? arrow_icon_color : Colors.white70,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircleAvatar(
                    backgroundColor: titleContainerColor != null ? titleContainerColor : Colors.white,
                    child: Text(
                      number, // Here check if number greater or equal than 1000 add +
                      style: TextStyle(
                        color: titleContainerColor != null ? Colors.white : boxColor,
                        fontSize: 20,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Widget listTasks(
    BuildContext context,
    icon,
    bool isSVG,
    bool isBackground,
    String title,
    int number,
    Color? primaryColor,
    Color borderColor,
    route,
    data,
    double margin) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(
        context,
        route,
        arguments: ArgumentBundle(extras: data),
      );
    },
    child: Container(
      margin: EdgeInsetsDirectional.only(start: margin),
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: isBackground ? 0 : 2,
        ),
        borderRadius: BorderRadiusDirectional.all(
          Radius.circular(10),
        ),
        color: isBackground ? primaryColor : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            isSVG
                ? icon
                : Icon(
                    icon,
                    size: 30,
                    color: Colors.white,
                  ),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: isBackground ? Colors.white : borderColor,
              ),
            ),
            Spacer(),
            CircleAvatar(
              child: Text(
                number.toString(),
                style: TextStyle(
                  color: isBackground ? primaryColor : Colors.white,
                ),
              ),
              backgroundColor: isBackground ? Colors.white : borderColor,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget priorityStar = Icon(
  Icons.star,
  color: Colors.amber,
  size: 15,
);

Widget priorityBuilder(priority) {
  if (priority == 1) {
    priorityStar = Icon(
      Icons.star,
      color: Colors.amber,
      size: 15,
    );
    return priorityStar;
  } else if (priority == 2) {
    priorityStar = Row(
      children: [
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15,
        ),
        SizedBox(width: 3),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15,
        ),
      ],
    );
    return priorityStar;
  } else if (priority == 3) {
    priorityStar = Row(
      children: [
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15,
        ),
        SizedBox(width: 3),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15,
        ),
        SizedBox(width: 3),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15,
        ),
      ],
    );
    return priorityStar;
  } else if (priority == 4) {
    priorityStar = Row(
      children: [
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15,
        ),
        SizedBox(width: 3),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15,
        ),
        SizedBox(width: 3),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15,
        ),
        SizedBox(width: 3),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15,
        ),
      ],
    );
    return priorityStar;
  } else if (priority == 5) {
    priorityStar = Row(
      children: [
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15,
        ),
        SizedBox(width: 3),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15,
        ),
        SizedBox(width: 3),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15,
        ),
        SizedBox(width: 3),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15,
        ),
        SizedBox(width: 3),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 15,
        ),
      ],
    );
    return priorityStar;
  } else {
    priorityStar = Icon(
      Icons.star,
      color: Colors.amber,
      size: 15,
    );
    return priorityStar;
  }
}

Widget folderBuilder(context, FolderModel folder, {isAdd = false}) {
  return Padding(
    padding: const EdgeInsetsDirectional.only(bottom: 8.0),
    child: Slidable(
      key: UniqueKey(),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {
              Helper.showAddFolderBottomSheet(context, folderId: folder.id!, isUpdate: true);
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
            flex: 1,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {
          DatabaseHelper.instance.deleteFromTable("folders", folder.id);
          TaskCubit.get(context).getFoldersList();
        }),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {
              DatabaseHelper.instance.deleteFromTable(
                  "tasks", folder.id, forFolderTasks: true
              ).then((value) {
                DatabaseHelper.instance.deleteFromTable(
                  "folders", folder.id
                );
                TaskCubit.get(context).getFoldersList();
                TaskCubit.get(context).getTaskList(sortBy: CacheHelper.getData(key: "sortType"));
                Helper.showCustomSnackBar(context, content: "Folder & Tasks Foldered Deleted!", bgColor: Colors.red, textColor: Colors.white);
              });
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.save,
            label: 'Delete',
            flex: 1,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          if(!isAdd) {
            TaskCubit.get(context).getTasksOfFolderDataFromDB(folder.id);
            Navigator.pushNamed(
              context,
              PagePath.folderScreen,
              arguments: ArgumentBundle(extras: folder),
            );
          } else {
            Helper.showAddFolderBottomSheet(context);
          }
        },
        child: Container(
          padding: EdgeInsetsDirectional.only(
            top: 5,
            bottom: 5,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: !isAdd ? Color(folder.folder_color) : Colors.amber,
              width: 1,
            ),
            borderRadius: BorderRadiusDirectional.all(
              Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  isAdd ? Icons.add : IconData(folder.folder_icon, fontFamily: 'MaterialIcons'),
                  color: !isAdd ? Color(folder.folder_color) : Colors.amber,
                  size: 25,
                ),
                SizedBox(width: 10,),
                Text(
                  isAdd ? "Add New Folder..." : folder.folder_title!,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ]
              ),
          ),
        ),
      ),
    ),
  );
}

Widget loginAndRegisterWithBuilder(context, state, websiteSvg, loginWith) {
  return Expanded(
    child: InkWell(
      onTap: () {
        if(loginWith == "fb") {
          AppCubit.get(context).loginWithFB();
        } else if (loginWith == "google") {
          AppCubit.get(context).googleLogin();
        } else if (loginWith == "twitter") {
          AppCubit.get(context).loginWithTwitter();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(10),
          border: Border.all(
            color: Color.fromARGB(255, 216, 216, 216),
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 10.0,
            bottom: 10.0,
          ),
          child: state is! SignInWithTwitterLoading || state is! SignInWithFBLoading || state is! SignInWithGoogleLoading ? SvgPicture.asset(
                  websiteSvg,
                  width: 30,
                  height: 30,) : Center(child: CircularProgressIndicator(),),
        ),
      ),
    ),
  );
}

Widget whoAreYouBuilder(context, whoIs, {width,  cubit}) {
  int selectedValue = cubit.selectedValueOfWhoIs;

  if(whoIs == UserType.Student.name) {
    selectedValue = 1;
  } else if (whoIs == UserType.Freelancer.name) {
    selectedValue = 2;
  } else if (whoIs == UserType.Programmer.name) {
    selectedValue = 3;
  } else if (whoIs == UserType.Entrepreneur.name) {
    selectedValue = 4;
  } 

  print(selectedValue);

  return Container(
      padding: EdgeInsetsDirectional.only(
        start: 10,
        end: 10,
        top: 5,
        bottom: 5,
      ),
      width: width != null ? width : MediaQuery.of(context).size.width * .80,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(10),
        border: Border.all(
          color: Color.fromARGB(255, 201, 200, 200),
          width: 1,
        ),
        color: Theme.of(context).cardColor
      ),
      child: DropdownButton(
        underline: Container(width: 0,),
        isExpanded: true,
        borderRadius: BorderRadius.circular(10),
        dropdownColor: Theme.of(context).cardColor,
        onTap: () => Helper.unfocus(),
        onChanged: (int? value) {
          cubit.getSelectedValueOfWhoIs(value);
        },
        items: [
          DropdownMenuItem(
            value: 1,
            child: Text(
              UserType.Student.name.toString(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          DropdownMenuItem(
            value: 2,
            child: Text(
              UserType.Freelancer.name.toString(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          DropdownMenuItem(
            value: 3,
            child: Text(
              UserType.Programmer.name.toString(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          DropdownMenuItem(
            value: 4,
            child: Text(
              UserType.Entrepreneur.name.toString(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          DropdownMenuItem(
            value: 5,
            child: Text(
              UserType.Default.name.toString(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
        style: AppTheme.text1.withBlack,
        value: selectedValue,
      ),
    );
}

bool isNumeric(String? str) {
    if(str == null) {
      return false;
    }
    return double.tryParse(str) != null;
}

Widget chartBuilder(context, dataMap, colorsList) => Container(
  height: 200,
  child: PieChart(
    dataMap: dataMap,
    animationDuration: Duration(milliseconds: 800),
    chartLegendSpacing: 32,
    chartRadius: MediaQuery.of(context).size.width / 3.2,
    colorList: colorsList,
    initialAngleInDegree: 0,
    chartType: ChartType.ring,
    ringStrokeWidth: 32,
    centerText: "Tasks",
    chartValuesOptions: ChartValuesOptions(
      showChartValueBackground: true,
      showChartValues: true,
      showChartValuesInPercentage: true,
      showChartValuesOutside: true,
    ),
  ),
);

Widget mainFloatingBTN(context) {
    return SpeedDial(
      activeIcon: Icons.close,
      animatedIconTheme: IconThemeData(size: 22),
      icon: Icons.add,
      backgroundColor: mainColor,
      foregroundColor: Colors.white,
      visible: true,
      overlayColor: Color.fromARGB(0, 0, 0, 0),
      curve: Curves.bounceIn,
      children: [
            SpeedDialChild(
            child: Icon(
              Icons.timer,
              color: Colors.white,
            ),
            backgroundColor: Colors.green,
            onTap: () {
              navigateTo(context, PomodoroTechnique());
            },
            label: 'Pomodoro',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.green),
                SpeedDialChild(
                child: Icon(Icons.notes, color: Colors.white,),
                backgroundColor: Colors.amber,
                onTap: () { 
                  Helper.showNoteBottomSheet(context);
                },
                label: 'Note',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Colors.amber),
            // FAB 2
            SpeedDialChild(
                child: SvgPicture.asset(Resources.tasksWhite, width: 25, height: 23),
                backgroundColor: mainColor,
                onTap: () { 
                  Helper.showTaskBottomSheet(context);
                },
                label: 'Task',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: mainColor),
            
            SpeedDialChild(
                child: Icon(Icons.layers, color: Colors.white,),
                backgroundColor: mainColor,
                onTap: () { 
                  Helper.showAddProjectBottomSheet(context);
                },
                label: 'Project',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: mainColor),
      ],
    );
  }

