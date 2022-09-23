import 'dart:convert';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as editor;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manage_life_app/layout/search/search_screen.dart';
import 'package:manage_life_app/layout/tasks_screens/list_of_tasks.dart';
import 'package:manage_life_app/layout/tasks_screens/task_items.dart';
import 'package:manage_life_app/main.dart';
import 'package:manage_life_app/models/folder_model.dart';
import 'package:manage_life_app/routes/argument_bundle.dart';
import 'package:manage_life_app/providers/helpers/database_helper.dart';
import 'package:manage_life_app/providers/task_bloc/task_bloc.dart';
import 'package:manage_life_app/routes/page_path.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FolderScreen extends StatelessWidget {
  final ArgumentBundle bundle;

  FolderScreen({required this.bundle, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController titleController = TextEditingController();
    editor.QuillController contentController = editor.QuillController(document: editor.Document()..insert(0, 'Write your details...'), selection: const TextSelection.collapsed(offset: 0));

    FolderModel folder = bundle.extras;

    return BlocConsumer<TaskCubit, TaskStates>(
      listener: (context, state) {},
      builder: (context, state) { 

        var taskCubit = TaskCubit.get(context);

        if(folder.folder_title!.isNotEmpty) {
          titleController.text = folder.folder_title!;
        }

        if(folder.folder_content != "") {
          var myJSON = jsonDecode(folder.folder_content!);
          contentController = editor.QuillController(
              document: editor.Document.fromJson(myJSON),
              selection: TextSelection.collapsed(offset: 0));
          print(jsonDecode(folder.folder_content!));
        }
        return Scaffold(
        appBar: AppBar(
          leading: Icon(
             Icons.task,
              color: Colors.white,
              size: 25,
          ),
          elevation: 0,
          backgroundColor: mainColor,
          title: Text(AppLocalizations.of(context)!.appName, style: TextStyle(color: Colors.white),),
          titleSpacing: 0,
          shadowColor: Colors.transparent,
          actions: [
            InkWell(
                onTap: () { 
                  TaskCubit.get(context).getTasksOfFolderDataFromDB(folder.id);
                  Navigator.pushNamed(
                    context,
                    PagePath.tasksOfCategoryScreen,
                    arguments: ArgumentBundle(extras: folder.id, identifier: "folder"),
                  );
                },
                child: Stack(
                  // alignment: Alignment.topRight,
                    children: [
                      IconButton(onPressed: () {
                         TaskCubit.get(context).getTasksOfFolderDataFromDB(folder.id);
                          Navigator.pushNamed(
                            context,
                            PagePath.tasksOfCategoryScreen,
                            arguments: ArgumentBundle(extras: folder.id, identifier: "folder"),
                          ); 
                      }, icon: Icon(
                        Icons.task,
                        color: Colors.white,
                        size: 25,
                      )),
                      Positioned(
                          top: 5.0,
                          right: 3.0,
                          child: CircleAvatar(
                            child: Text(
                              taskCubit.tasksFolderData.length.toString(),
                              style: TextStyle(
                                color: mainColor,
                              ),
                            ),
                            backgroundColor: Colors.white,
                            radius: 11,
                          )),
                    ]
                ),
              ),
            IconButton(
              onPressed: () {
               if (formKey.currentState!.validate()) {
                FolderModel folderModel = FolderModel(
                  folder_title: titleController.text,
                  folder_content: jsonEncode(contentController.document.toDelta().toJson()),
                  folder_icon: folder.folder_icon,
                  folder_color: folder.folder_color,
                  folder_color_index: folder.folder_color_index
                );

                folderModel.id = folder.id;
        
                DatabaseHelper.instance.updateTable(folder: folderModel).then((value) {
                  TaskCubit.get(context).getFoldersList();
                  folder.folder_title = folderModel.folder_title;
                  titleController.text = folder.folder_title!;
                  folder.folder_content = folderModel.folder_content;
                  Helper.showCustomSnackBar(context, content: AppLocalizations.of(context)!.dataSavedSuccessfully, bgColor: Colors.green, textColor: Colors.white);
                });
               }
              },
              icon: state is! GettingFoldersLoading ? Icon(
                Icons.save,
                color: Colors.white,
              ) : CircularProgressIndicator(color: Colors.white, strokeWidth: 3.0,),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsetsDirectional.only(start: 8.0, end: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(10),
                  border: folder.folder_color != 0 ? Border.all(color: Color(folder.folder_color), width: 2) : Border.all(color: mainColor, width: 2),
                ),
                child: Row(
                  children: [
                    Icon(
                      folder.folder_icon != 0 ? IconData(folder.folder_icon, fontFamily: 'MaterialIcons') : Icons.folder,
                      color: folder.folder_color != 0 ? Color(folder.folder_color) : mainColor,
                      size: 30,
                    ),
                    SizedBox(width: 7,),
                    Expanded(
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          controller: titleController, 
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Folder title"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              Helper.showCustomSnackBar(context, content: AppLocalizations.of(context)!.pleaseEnterTitleTask, bgColor: Colors.red, textColor: Colors.white);
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30
                          ), 
                          cursorColor: Color(folder.folder_color), 
                          ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(10),
                      border: folder.folder_color != 0 ? Border.all(color: Color(folder.folder_color), width: 2) : Border.all(color: mainColor, width: 2),
                    ),
                  child: editor.QuillEditor(
                    controller: contentController,
                    focusNode: FocusNode(),
                    scrollController: ScrollController(),
                    scrollable: true,
                    padding: EdgeInsetsGeometry.lerp(EdgeInsetsDirectional.all(10), EdgeInsetsDirectional.all(10), 4)!,
                    autoFocus: true,
                    readOnly: false,
                    expands: true,
                    showCursor: true,
                  ),
                ),
              ),
            ),
            editor.QuillToolbar.basic(
              controller: contentController,
              showAlignmentButtons: true,
              showSmallButton: true,
              showCameraButton: false,
              showImageButton: false,
              showVideoButton: false,
              showLink: false,
            ),
          ],
        ),
        );
      },
    );
  }
}
