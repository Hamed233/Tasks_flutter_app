import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:manage_life_app/models/project_model.dart';
import 'package:manage_life_app/modules/widgets/confirm_dialog.dart';
import 'package:manage_life_app/providers/helpers/database_helper.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/providers/project_bloc/project_cubit.dart';
import 'package:manage_life_app/providers/task_bloc/task_bloc.dart';
import 'package:manage_life_app/routes/argument_bundle.dart';
import 'package:manage_life_app/routes/page_path.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/styles/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';

class ProjectListItem extends StatelessWidget {
  final Project? project;

  const ProjectListItem({Key? key,
   required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProjectCubit cubit = ProjectCubit.get(context);
    return InkWell(
      onTap: () {
        TaskCubit.get(context).getTasksOfProjectDataFromDB(project?.id);
            Navigator.pushNamed(
              context,
              PagePath.peojectDetailsScreen,
              arguments: ArgumentBundle(extras: project?.id, identifier: "project"),
            );
        },
      child: Column(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 35,
                  child: Text(
                    "⬤ ",
                    style: TextStyle(
                        color: Color(project!.project_color!))),
                ),
                Expanded(
                  child: Slidable(
                    key: UniqueKey(),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      dismissible: DismissiblePane(onDismissed: () {
                        if (project?.status == ProjectStatus.ONGOING.name) {
                          project?.status = ProjectStatus.COMPLETED.name;
                        } else {
                          project?.status = ProjectStatus.ONGOING.name;
                        }
                        DatabaseHelper.instance.updateTable(project: project);
                        ProjectCubit.get(context).getProjectsList(sortBy: CacheHelper.getData(key: "projectsSortType"));
                      }),
                      children: [
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            project?.status = project?.status == ProjectStatus.COMPLETED.name ? ProjectStatus.ONGOING.name : ProjectStatus.COMPLETED.name;                            
                            DatabaseHelper.instance.updateTable(project:project);
                            ProjectCubit.get(context).getProjectsList(sortBy: CacheHelper.getData(key: "projectsSortType"));
                          },
                          backgroundColor: project?.status == "ONGOING" ? AppTheme.doneTasksColor : AppTheme.inprogressTasksColor,
                          foregroundColor: Colors.white,
                          icon: project?.status == "COMPLETED" ? Icons.timelapse : Icons.done_all,
                          label: project?.status == "ONGOING" ? "Complete" : "Ongoing",
                          flex: 1,
                        ),
                
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            Helper.showAddProjectBottomSheet(context, isUpdate: true, projectId: project!.id);
                          },
                          backgroundColor: project!.project_color! != 4294967295 ? Color(project!.project_color!) : Colors.amber,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: "edit",
                          flex: 1,
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          // An action can be bigger than the others.
                          flex: 1,
                          onPressed: (BuildContext context) {
                            project?.is_archived = project?.is_archived == 0 ? 1 : 0;                            
                            DatabaseHelper.instance.updateTable(project:project);
                            ProjectCubit.get(context).getProjectsList(sortBy: CacheHelper.getData(key: "projectsSortType"));
                              Helper.showCustomSnackBar(context,
                              content:
                                  "${AppLocalizations.of(context)!.projects} ${project?.is_archived == 0 ? AppLocalizations.of(context)!.unarchive : AppLocalizations.of(context)!.archived} ${AppLocalizations.of(context)!.now}}!",
                              bgColor: AppTheme.archivedTasksColor,
                              textColor: Colors.white);
                          },
                          backgroundColor: AppTheme.archivedTasksColor,
                          foregroundColor: Colors.white,
                          icon: Icons.archive,
                          label:
                              project?.is_archived == 0 ? AppLocalizations.of(context)!.archive : AppLocalizations.of(context)!.unarchive,
                        ),
                        SlidableAction(
                          flex: 1,
                          onPressed: (BuildContext context) async {
                            bool delete = await showDialog(
                                context: context,
                                builder: (_) => ConfirmDialog(
                                      title: "Are you sure?",
                                      content: "Once deleted it cannot be return it!",
                                    ));
                            if (delete) {
                              print(project?.id);
                              DatabaseHelper.instance.deleteFromTable("projects", project?.id);
                              cubit.getProjectsList(sortBy: CacheHelper.getData(key: "projectsSortType"));
                                Helper.showCustomSnackBar(context,
                                content: "Project Deleted",
                                bgColor: Colors.red,
                                textColor: Colors.white);
                              }
                          },
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: AppLocalizations.of(context)!.delete,
                        ),
                      ],
                    ),
                    child: Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        project!.project_title!,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 17,
                                          decoration: project?.status == ProjectStatus.COMPLETED.name
                                              ? TextDecoration.lineThrough
                                              : null,
                                          color: project?.status == ProjectStatus.COMPLETED.name
                                              ? Colors.grey
                                              : null,
                                        ),
                                      ),
                                      Spacer(),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: EdgeInsetsDirectional.only(
                                                start: 5, end: 5, top: 1, bottom: 1),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: (project?.status ==  ProjectStatus.COMPLETED.name
                                                      ? AppTheme.doneTasksColor
                                                      : AppTheme.inprogressTasksColor),
                                                )),
                                            child: Row(
                                              children: [
                                                Icon(
                                                    project?.status == ProjectStatus.COMPLETED.name
                                                        ? Icons.done_all
                                                        : Icons.timelapse,
                                                    color: (project?.status == ProjectStatus.COMPLETED.name
                                                        ? AppTheme.doneTasksColor
                                                        : AppTheme
                                                            .inprogressTasksColor),
                                                    size: 15),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  project?.status ==  ProjectStatus.COMPLETED.name
                                                      ? AppLocalizations.of(context)!.done
                                                      : AppLocalizations.of(context)!.inprogress,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: (project?.status ==  ProjectStatus.COMPLETED.name
                                                          ? AppTheme.doneTasksColor
                                                          : AppTheme
                                                              .inprogressTasksColor),
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                        ),
                                    
                                    ],
                                  ),
                                ),
                              ],
                            )),
                            
                            
                                // Spacer(),
                                // Icon(Icons.date_range,
                                //     size: 15, color: mainColor),
                                // SizedBox(width: 5),
                                // Text(
                                //     "Created at" + project!.project_created_at.toString(),
                                //     overflow: TextOverflow.ellipsis,
                                //     style: AppTheme.text3),
                              ],
                            ),
                      ),
                          
                        ),
                      
                      ),
                    ),
                ],
              ),
          ),
          myDivider(),
        ],
      ),
    );
  }
}