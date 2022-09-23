import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:manage_life_app/providers/note_bloc/note_bloc.dart';
import 'package:manage_life_app/providers/task_bloc/task_bloc.dart';
import 'package:manage_life_app/shared/components/default_form_field.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/styles/themes.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';

class MoreDetailsSheet extends StatelessWidget {

  MoreDetailsSheet();

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? datePicked;
  var noteColor;
  Color borderColor = Color(0xffd3d3d3);
  Color foregroundColor = Color(0xff595959);
  var _check = Icon(Icons.check);


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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          }, 
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),  
                            textAlign: TextAlign.start,
                          )
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(start: 110.0),
                            child: Text(
                              "Options",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Helper.showSortByBottomSheet(context);
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
                              Icon(
                                Icons.sort
                              ),
                              SizedBox(width: 7,),
                              Text(
                                "Sort By",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      },
    );
  }
}
