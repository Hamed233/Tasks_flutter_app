import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_life_app/layout/projects_screen/projects/presentation/widgets/project_list.dart';
import 'package:manage_life_app/providers/project_bloc/project_cubit.dart';
import 'package:manage_life_app/providers/project_bloc/project_states.dart';
import 'package:manage_life_app/routes/argument_bundle.dart';
import 'package:manage_life_app/routes/page_path.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AechievedProjectsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: mainColor,
            elevation: 0,
            leading: Icon(Icons.layers, color: Colors.white,),
            titleSpacing: 0,
            title: Text(AppLocalizations.of(context)!.archievedProjects, style: TextStyle(color: Colors.white),),
            actions: [
              IconButton(onPressed: () {
                      Navigator.pushNamed(
                        context,
                        PagePath.searchScreen,
                        arguments: ArgumentBundle(extras: "Projects Search", identifier: 'projects'),
                      );
              }, icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 25,
              )),
              // IconButton(
              //   onPressed: () => NoteBloc.get(context).toggleViewType(),
              //   icon: Icon(
              //     NoteBloc.get(context).notesViewType == viewType.List ?  Icons.developer_board : Icons.view_headline,
              //     color: Colors.white,
              //     size: 25,
              //   ),
              // ),
            ],
          ),
          body: ProjectList(typeOfProjects: "archivedProjects"),
        );
      }
    );
  }
}