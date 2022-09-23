import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:manage_life_app/models/project_model.dart';
import 'package:manage_life_app/models/project_model.dart';
import 'package:manage_life_app/providers/helpers/database_helper.dart';
import 'package:manage_life_app/providers/project_bloc/project_cubit.dart';
import 'package:manage_life_app/providers/project_bloc/project_states.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/components/default_form_field.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/styles/themes.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddNewProjectSheet extends StatelessWidget {

  bool isUpdate;
  int projectId;
  Project? project;

  AddNewProjectSheet(this.isUpdate, this.projectId);

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? datePicked;
  var projectColor;
  Color borderColor = Color(0xffd3d3d3);
  Color foregroundColor = Color(0xff595959);
  var _check = Icon(Icons.check);


  @override
  Widget build(BuildContext context) {
    ProjectCubit cubit = ProjectCubit.get(context);
    var projectIndex;
    var isArchived = 0;
    List projectData = [];

    return BlocConsumer<ProjectCubit, ProjectStates>(
      listener: (context, state) {
      },
      builder: (context, state) {
        if(isUpdate) {
          projectData = cubit.projectData.toList();
          if(projectData.length != 0 && state is! ColorOfProjectChangeTapped) {
            projectIndex = projectData[0]['index_of_color'];
            projectColor = Color(projectData[0]['project_color']);
            titleController = TextEditingController()..text = projectData[0]["project_title"].toString();
            descriptionController = TextEditingController()..text = projectData[0]["project_description"].toString();
            isArchived = projectData[0]['is_archived'];
          }
        }

        return Material(
          color: projectColor != null && state is! ColorOfProjectChangeTapped ? projectColor : cubit.projectColor,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isUpdate)
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.green,
                              child: IconButton(
                                icon: Icon(
                                  isArchived == 0 ? Icons.archive : Icons.unarchive,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    if(isArchived == 0) {
                                      Project model = Project(
                                        project_title: projectData[0]['project_title'],
                                        project_description: projectData[0]['project_description'],
                                        project_created_at: projectData[0]['project_date'],
                                        project_color: projectData[0]['project_color'],
                                        index_of_color: projectData[0]['index_of_color'],
                                        is_archived: 1,
                                      );

                                      model.id = projectId;
                                      
                                        DatabaseHelper.instance.updateTable(project: model).then((value) {
                                          cubit.getArchivedProjectsList();
                                          cubit.getProjectsList();
                                          Navigator.pop(context);
                                          Helper.showCustomSnackBar(context, content: "Project Archived!", bgColor: Colors.green, textColor: Colors.white);
                                      });
                                    } else {
                                      Project model = Project(
                                        project_title: projectData[0]['project_title'],
                                        project_description: projectData[0]['project_description'],
                                        project_created_at: projectData[0]['project_date'],
                                        project_color: projectData[0]['project_color'],
                                        index_of_color: projectData[0]['index_of_color'],
                                        is_archived: 0,
                                        status: ProjectStatus.ONGOING.name,
                                      );

                                      model.id = projectId;

                                        DatabaseHelper.instance.updateTable(project: model).then((value) {
                                          cubit.getArchivedProjectsList();
                                          cubit.getProjectsList();
                                          Navigator.pop(context);
                                          Helper.showCustomSnackBar(context, content: "Project Unarchived!", bgColor: Colors.green, textColor: Colors.white);
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                          SizedBox(width: 5,),
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
                                    DatabaseHelper.instance.deleteFromTable("projects", projectId).then((value) {
                                      cubit.getProjectsList();
                                      Navigator.pop(context);
                                      Helper.showCustomSnackBar(context,
                                        content: "Project Deleted",
                                        bgColor: Colors.red,
                                        textColor: Colors.white);
                                    });
                                  }
                                },
                              ),
                            ),
                          Spacer(),
                          Center(
                            child: Text(
                                isUpdate ? 'Edit Project' : 'Add Project',
                                style: AppTheme.headline3
                            ),
                          ),
                          Spacer(),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: mainColor,
                            child: IconButton(
                              icon: Icon(
                                isUpdate ? Icons.check : Icons.arrow_upward,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  if(isUpdate) {
                                    Project project = Project(
                                      project_title: titleController.text,
                                      project_description:  descriptionController.text,
                                      index_of_color: cubit.indexOfCurrentColor,
                                      project_color: cubit.projectColor != null ? cubit.projectColor!.value : 4294967295,
                                      is_archived: isArchived,
                                    );

                                    project.id = projectId;

                                    DatabaseHelper.instance.updateTable(project: project).then((value) {
                                        cubit.getProjectsList();
                                        Navigator.pop(context);
                                        Helper.showCustomSnackBar(context, content: "Project Updated Successfully!", bgColor: Colors.green, textColor: Colors.white);
                                    });
                                  } else {
                                    Project model = Project(
                                      project_title: titleController.text,
                                      project_description:  descriptionController.text,
                                      project_created_at: DateTime.now().toString(),
                                      index_of_color: cubit.indexOfCurrentColor,
                                      project_color: cubit.projectColor != null ? cubit.projectColor!.value : 4294967295,
                                      is_archived: 0,
                                      status: ProjectStatus.ONGOING.name,
                                    );

                                    DatabaseHelper.instance.insertDataToTable(context, project: model).then((value) {
                                      cubit.getProjectsList();
                                      titleController.clear();
                                      descriptionController.clear();
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
                state is! GettingProjectDataLoading ? Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(height: 20),
                            DefaultFormField(
                              controller: titleController,
                              label: 'Project Title',
                              autoFocus: true,
                              focusedColorBorder: cubit.indexOfCurrentColor == 0 ? mainColor : Colors.white38,
                              hintText: 'project title',
                              labelColor: Colors.grey[800],
                              type: TextInputType.text,
                              prefixColorIcon: cubit.indexOfCurrentColor == 0 ? mainColor : Colors.grey[800],
                              prefix: Icons.layers,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your title Project';
                                }
                                return null;
                              },
                              borderColor: borderColor,
                            ),
                            SizedBox(height: 10),
                            DefaultFormField(
                              controller: descriptionController,
                              label: 'Project Description',
                              focusedColorBorder: cubit.indexOfCurrentColor == 0 ? mainColor : Colors.white38,
                              type: TextInputType.text,
                              prefixColorIcon: cubit.indexOfCurrentColor == 0 ? mainColor : Colors.grey[800],
                              labelColor: Colors.grey[800],
                              minLines: 4,
                              maxLines: 6,
                              prefix: Icons.description_outlined,
                              borderColor: borderColor,
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              height: 44,
                              width: MediaQuery.of(context).size.width,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children:
                                List.generate(colors.length, (index)
                                {
                                  return GestureDetector(
                                      onTap: () {
                                        cubit.colorChangeTapped(index);
                                      },
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 6, right: 6),
                                          child: Container(
                                              child: new CircleAvatar(
                                                child: checkColor(cubit, index, projectIndex, state),
                                                foregroundColor: foregroundColor,
                                                backgroundColor: colors[index],
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
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ) : Padding(
                  padding: const EdgeInsets.only(bottom: 50, top: 30),
                  child: Center(child: CircularProgressIndicator(color: mainColor,),),
                ),
              ],
            ),
          ),
        );

      },
    );
  }

  Widget? checkColor(cubit, index, projectIndex, state) {
    if(isUpdate && index == projectIndex && state is! ColorOfProjectChangeTapped) {
      return _check;
    } else {
      if(cubit.indexOfCurrentColor == index && state is ColorOfProjectChangeTapped) {
        return _check;
      }
    }

    return null;
  }
}
