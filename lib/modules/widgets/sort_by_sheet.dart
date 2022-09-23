import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/providers/note_bloc/note_bloc.dart';
import 'package:manage_life_app/providers/task_bloc/task_bloc.dart';
import 'package:manage_life_app/shared/components/default_form_field.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/styles/themes.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';

class SortBySheet extends StatelessWidget {

  var currentSortType = CacheHelper.getData(key: "sortType");

  @override
  Widget build(BuildContext context) {
    TaskCubit cubit = TaskCubit.get(context);

    return BlocConsumer<TaskCubit, TaskStates>(
      listener: (context, state) {
      },
      builder: (context, state) {
        
        return Material(
          color: Colors.grey[200],
          child: SingleChildScrollView(
            child: Container(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            TaskCubit.get(context).sortBy(currentSortType);
                          }, 
                          child: Text(
                            "Cancel",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),  
                          )
                        ),
                        Spacer(),
                        Text(
                          "Sort By",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Helper.showMoreDetailsBottomSheet(context);
                          }, 
                          child: Text(
                            "Done",
                          style: TextStyle(
                            fontSize: 16,
                          ),  
                          )
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  _sortTypeBuilder(context, "Name"),
                  _sortTypeBuilder(context, "New"),
                  _sortTypeBuilder(context, "Oldest"),
                  _sortTypeBuilder(context, "Priority"),
                ],
              ),
            ),
          ),
        );

      },
    );
  }

  Widget _sortTypeBuilder(context, type) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 15,
        end: 15,
        top: 5,
        bottom: 5,
      ),
      child: InkWell(
        onTap: () {
          TaskCubit.get(context).sortBy(type);
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(10),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                if(TaskCubit.get(context).sortType == type)
                  Icon(
                    Icons.check,
                    color: mainColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
