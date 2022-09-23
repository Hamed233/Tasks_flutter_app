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

class AddNewFolderSheet extends StatelessWidget {
  bool isUpdate;
  int folderId;
  var _check = Icon(Icons.check);

  AddNewFolderSheet(this.isUpdate, this.folderId);

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cubit = TaskBloc.TaskCubit.get(context);
    var folderData;
    var folderIcon;
    var folderColor;
    print(isUpdate);
    Color borderColor = Color(0xffd3d3d3);
    Color foregroundColor = Color(0xff595959);
    
    return BlocConsumer<TaskCubit, TaskStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var folderColorIndex;
        print(cubit.folderData.length);
        if (isUpdate && cubit.folderData.length != 0) {
            folderData = cubit.folderData;
            titleController = state is! ColorOfFolderChangeTapped && state is! ChangeIconFolder ? TextEditingController(text: folderData[0]['folder_title'].toString()) : titleController;
            folderColorIndex = folderData[0]['index_of_color'] != null ? folderData[0]['index_of_color'] : cubit.indexOfCurrentColor;
            folderColor = state is! ColorOfFolderChangeTapped && state is! ChangeIconFolder ? Color(folderData[0]['folder_color']) : cubit.folderColor;
            folderIcon = state is! ChangeIconFolder && state is! ColorOfFolderChangeTapped ? IconData(folderData[0]['folder_icon'], fontFamily: "MaterialIcons") : cubit.folderIcon;
        } else {
          folderColorIndex = cubit.indexOfCurrentColor;
          folderColor = cubit.colors[folderColorIndex];
          folderIcon = cubit.folderIcon;
        }

        return Material(
          child: SafeArea(
            top: false,
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                color: Theme.of(context).cardColor,
                child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 50,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (isUpdate)
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.red,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.delete_forever,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                if (formKey.currentState!.validate()) {
                                                  DatabaseHelper.instance.deleteFromTable(
                                                      "tasks", folderId, forFolderTasks: true
                                                  ).then((value) {
                                                    DatabaseHelper.instance.deleteFromTable(
                                                      "folders", folderId
                                                    );
                                                    TaskCubit.get(context).getFoldersList();
                                                    TaskCubit.get(context).getTaskList(sortBy: CacheHelper.getData(key: "sortType"));
                                                    Navigator.pop(context);
                                                    Helper.showCustomSnackBar(context, content: "Folder & Tasks Foldered Deleted!", bgColor: Colors.red, textColor: Colors.white);
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        Spacer(),
                                        Center(
                                          child: Text(
                                              isUpdate
                                                  ? 'Edit Folder'
                                                  : 'Add New Folder',
                                              style: Theme.of(context).textTheme.headline3),
                                        ),
                                        Spacer(),
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundColor: mainColor,
                                          child: IconButton(
                                            icon: Icon(
                                              isUpdate
                                                  ? Icons.check
                                                  : Icons.arrow_upward,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                if (isUpdate) {
                                                  FolderModel folderModel = FolderModel(
                                                    folder_title: titleController.text,
                                                    folder_content: "",
                                                    folder_icon: cubit.folderIcon!.codePoint,
                                                    folder_color: folderColor.value,
                                                    folder_color_index: folderColorIndex
                                                  );

                                                  folderModel.id = folderId;

                                                  DatabaseHelper.instance.updateTable(folder: folderModel).then((value) {
                                                    cubit.getFoldersList();
                                                    titleController.clear();
                                                    Navigator.pop(context);
                                                    Helper.showCustomSnackBar(context, content: "Folder Inserted Successfully!", bgColor: Colors.green, textColor: Colors.white);
                                                  });

                                                } else {
                                                  FolderModel folderModel = FolderModel(
                                                    folder_title: titleController.text,
                                                    folder_content: '',
                                                    folder_icon: cubit.folderIcon!.codePoint,
                                                    folder_color: cubit.folderColor.value,
                                                    folder_color_index: folderColorIndex
                                                  );
                                                  print(cubit.folderIcon!.codePoint);

                                                  DatabaseHelper.instance.insertDataToTable(context, folder: folderModel).then((value) {
                                                    cubit.getFoldersList();
                                                    titleController.clear();
                                                    Helper.showCustomSnackBar(context, content: "Folder Inserted Successfully!", bgColor: Colors.green, textColor: Colors.white);
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
                              Container(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          SizedBox(height: 20),
                                          DefaultFormField(
                                            controller: titleController,
                                            label: 'Folder Title',
                                            autoFocus: isUpdate ? false : true,
                                            focusedColorBorder: mainColor,
                                            hintText: 'Folder title',
                                            labelColor: Theme.of(context).textTheme.bodyText2!.color,
                                            hintColor: Theme.of(context).textTheme.bodyText2!.color,
                                            type: TextInputType.text,
                                            prefixColorIcon: folderColor,
                                            prefix: folderIcon,
                                            validate: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your title Folder';
                                              }
                                              return null;
                                            },
                                            borderColor: Colors.grey,
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            'Folder Icon',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          SizedBox(
                                            height: 44,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: List.generate(
                                                  cubit.icons.length, (index) {
                                                return GestureDetector(
                                                    onTap: () {
                                                      cubit.changeIconFolder(index);
                                                    },
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 6,
                                                                right: 6),
                                                        child: Container(
                                                            child: new CircleAvatar(
                                                              child: Icon(cubit.icons[index],
                                                              ),
                                                            ),
                                                            width: 38.0,
                                                            height: 38.0,
                                                            padding: const EdgeInsets.all(1.0), // border width
                                                            decoration: new BoxDecoration(
                                                              color: mainColor, // border color
                                                              shape: BoxShape.circle,
                                                            ))));
                                              }),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                           
                                           Text(
                                            'Folder Color',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          SizedBox(
                                            height: 44,
                                            width: MediaQuery.of(context).size.width,
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children:
                                              List.generate(cubit.colors.length, (index)
                                              {
                                                return GestureDetector(
                                                    onTap: () {
                                                      cubit.colorChangeTapped(index);
                                                    },
                                                    child: Padding(
                                                        padding: EdgeInsets.only(left: 6, right: 6),
                                                        child: Container(
                                                            child: new CircleAvatar(
                                                              child: checkColor(cubit, index, folderColorIndex, state),
                                                              foregroundColor: foregroundColor,
                                                              backgroundColor: cubit.colors[index],
                                                            ),
                                                            width: 38.0,
                                                            height: 38.0,
                                                            padding: const EdgeInsets.all(1.0), // border width
                                                            decoration: new BoxDecoration(
                                                              color: borderColor, // border color
                                                              shape: BoxShape.circle,
                                                            )
                                                        ) )
                                                );

                                              })
                                              ,),
                                          ),
                                        ],
                                      ),
                                    )
                                
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

    Widget? checkColor(cubit, index, noteIndex, state) {
    if(isUpdate && index == noteIndex && state is! ColorOfFolderChangeTapped) {
      return _check;
    } else {
      if(cubit.indexOfCurrentColor == index && state is ColorOfFolderChangeTapped) {
        return _check;
      }
    }

    return null;
  }
}
