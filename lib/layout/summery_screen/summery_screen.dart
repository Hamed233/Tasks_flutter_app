import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:manage_life_app/providers/general_app_cubit/app_general_cubit.dart';
import 'package:manage_life_app/providers/general_app_cubit/states.dart';
import 'package:manage_life_app/routes/page_path.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/styles/colors.dart';

class SummeryScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var actionsHidden = AppCubit.get(context).actionsHidden;
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 10,
              end: 10,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(Resources.tasksActive, width: 20, height: 25),
                    SizedBox(width: 5,),
                    Text(
                      "Tasks",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    boxBuilder(context, Icons.all_inbox_outlined, "All Tasks", "33", HexColor("#474956"), PagePath.tasksOfCategoryScreen, "all",),
                    SizedBox(width: 5.0,),
                    boxBuilder(context, Icons.play_for_work, "Inprogress", "5", HexColor("#61cfed"), PagePath.tasksOfCategoryScreen, "inprogress",),
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    boxBuilder(context, Icons.done, "Done", "67", HexColor("#5cce99"), PagePath.tasksOfCategoryScreen, "done",),
                    SizedBox(width: 5.0,),
                    boxBuilder(context, Icons.archive, "Archived", "34", HexColor("#7d83c5"), PagePath.tasksOfCategoryScreen, "archived",),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Icon(
                      Icons.event_note,
                      color: mainColor,
                    ),
                    SizedBox(width: 5,),
                    Text(
                      "Events",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    boxBuilder(context, Icons.update, "Upcoming", "34", HexColor("#e14658"), PagePath.tasksOfCategoryScreen, "upcoming",),
                    SizedBox(width: 5.0,),
                    boxBuilder(context, Icons.event_available, "Attended", "67", HexColor("#5cce99"), PagePath.tasksOfCategoryScreen, "attended",),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Icon(
                      Icons.note_outlined,
                      color: mainColor,
                    ),
                    SizedBox(width: 5,),
                    Text(
                      "Reminders",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    boxBuilder(context, Icons.note_outlined, "Reminders", "34", HexColor("#b01c58"), PagePath.tasksOfCategoryScreen, "reminders",),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}