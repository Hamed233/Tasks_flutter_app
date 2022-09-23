import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manage_life_app/layout/projects_screen/projects/presentation/widgets/project_list_item.dart';
import 'package:manage_life_app/models/project_model.dart';
import 'package:manage_life_app/modules/widgets/bordered_container.dart';
import 'package:manage_life_app/modules/widgets/confirm_dialog.dart';
import 'package:manage_life_app/providers/project_bloc/project_cubit.dart';
import 'package:manage_life_app/providers/project_bloc/project_states.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:provider/provider.dart';

class ProjectList extends StatelessWidget {

  final String? typeOfProjects;
  ProjectList({required this.typeOfProjects});

  @override
  Widget build(BuildContext context) {
    
    var projectCubit = ProjectCubit.get(context);

    return BlocConsumer<ProjectCubit, ProjectStates>(
      listener: (state, context) {},
      builder: (state, context) {
        var lengthOfProjects = 0;
        var dataOfProjects = null;
        if(typeOfProjects == "allProjects") {
            lengthOfProjects = projectCubit.allProjects.length;
            dataOfProjects = projectCubit.allProjects;
        } else if (typeOfProjects == "archivedProjects") {
            lengthOfProjects = projectCubit.archivedProjects.length;
            dataOfProjects = projectCubit.archivedProjects;
        }
        return Container(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ConditionalBuilder(
              condition: state is! GettingAllProjectsLoading || state is! ProjectsNewSortLoading || state is! GettingProjectDataLoading,
              builder: (context) => Container(
                padding: EdgeInsetsDirectional.only(
                  start: 10,
                ),
                child: ConditionalBuilder(
                  condition: lengthOfProjects != 0,
                  builder: (context) => Column(
                    children: List.generate(
                        lengthOfProjects,
                        (index) {
                          Project project = dataOfProjects[index];
                          return ProjectListItem(
                            project: project,
                          );
                        },
                      ),
                    ),
                  fallback: (context) => Center(
                        child: SvgPicture.asset(Resources.empty, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * .75,),),
              
                ),
              ),
              fallback: (context) => Center(child: CircularProgressIndicator(color: mainColor,), heightFactor: 15,),
            ),
          ),
        );
      },
    );
  }
}
