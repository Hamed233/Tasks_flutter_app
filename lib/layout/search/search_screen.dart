import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manage_life_app/layout/notes_screen/note_item.dart';
import 'package:manage_life_app/layout/projects_screen/projects/presentation/widgets/project_list_item.dart';
import 'package:manage_life_app/layout/tasks_screens/list_of_tasks.dart';
import 'package:manage_life_app/models/project_model.dart';
import 'package:manage_life_app/modules/widgets/state_widgets.dart';
import 'package:manage_life_app/providers/project_bloc/project_cubit.dart';
import 'package:manage_life_app/providers/project_bloc/project_states.dart';
import 'package:manage_life_app/routes/argument_bundle.dart';
import 'package:manage_life_app/providers/note_bloc/note_bloc.dart';
import 'package:manage_life_app/providers/task_bloc/task_bloc.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatelessWidget {

  final ArgumentBundle bundle;

  SearchScreen({
    Key? key,
    required this.bundle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var searchController = TextEditingController();
    if(bundle.identifier == "tasks") {
      return BlocConsumer<TaskCubit, TaskStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasksCubit = TaskCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: mainColor,
              elevation: 0,
              titleSpacing: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(context),
              ),
              title: Container(
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(5)),
                width: double.infinity,
                height: 40,
                margin: const EdgeInsetsDirectional.only(end: 14.0),
                child: Center(
                  child: TextFormField(
                    controller: searchController,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)?.search,
                      prefixIcon: Icon(
                        Icons.search,
                        color: mainColor,
                      ),
                      focusColor: mainColor,
                      border: InputBorder.none,
                    ),
                    cursorColor: mainColor,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Enter text to search';
                      }
                      return null;
                    },

                    onChanged: (String text) {
                        TaskCubit.get(context).search(text);
                    },

                  ),
                ),
              ),

            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    if (state is SearchTaskLoadingState) Center(child: CircularProgressIndicator()),
                    SizedBox(height: 5.0,),
                    if (state is RetrieveTaskDataFromDatabase)
                      ConditionalBuilder(
                          condition: tasksCubit.searchList.length > 0,
                          builder: (context) { 
                            return Column(
                            children: List.generate(
                              tasksCubit.searchList.length,
                                  (index) {
                                return ListOfTasks(bundle: ArgumentBundle(extras: tasksCubit.searchList[index],),);
                              },
                            ),
                          );
                          },
                          fallback: (context) => SearchWidget(searchIn: "Tasks"))
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else if (bundle.identifier == "notes") {
      return BlocConsumer<NoteBloc, NoteStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var notesCubit = NoteBloc.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: mainColor,
              elevation: 0,
              titleSpacing: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(context),
              ),
              title: Container(
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(5)),
                width: double.infinity,
                height: 40,
                margin: const EdgeInsetsDirectional.only(end: 14.0),
                child: Center(
                  child: TextFormField(
                    controller: searchController,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)?.search,
                      prefixIcon: Icon(
                        Icons.search,
                        color: mainColor,
                      ),
                      focusColor: mainColor,
                      border: InputBorder.none,
                    ),
                    cursorColor: mainColor,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Enter text to search';
                      }
                      return null;
                    },

                    onChanged: (String text) {
                        NoteBloc.get(context).search(text);
                    },
                  ),
                ),
              ),

            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    if (state is SearchNoteLoadingState) Center(child: CircularProgressIndicator()),
                    SizedBox(height: 5.0,),
                    if (state is RetrieveNoteDataFromDatabase)
                      ConditionalBuilder(
                        condition: notesCubit.searchList.length > 0,
                        builder: (context) => Column(
                          children: List.generate(
                            notesCubit.searchList.length,
                                (index) {
                              return NoteItem(note: notesCubit.searchList[index],);
                            },
                          ),
                        ),
                        fallback: (context) => SearchWidget(searchIn: "Notes")),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else if (bundle.identifier == "projects") {
      return BlocConsumer<ProjectCubit, ProjectStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var projectsCubit = ProjectCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: mainColor,
              elevation: 0,
              titleSpacing: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(context),
              ),
              title: Container(
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(5)),
                width: double.infinity,
                height: 40,
                margin: const EdgeInsetsDirectional.only(end: 14.0),
                child: Center(
                  child: TextFormField(
                    controller: searchController,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)?.search,
                      prefixIcon: Icon(
                        Icons.search,
                        color: mainColor,
                      ),
                      focusColor: mainColor,
                      border: InputBorder.none,
                    ),
                    cursorColor: mainColor,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Enter text to search';
                      }
                      return null;
                    },

                    onChanged: (String text) {
                        projectsCubit.search(text);
                    },
                  ),
                ),
              ),

            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    if (state is SearchProjectLoadingState) Center(child: CircularProgressIndicator()),
                    SizedBox(height: 5.0,),
                    if (state is RetrieveProjectDataFromDatabase)
                      ConditionalBuilder(
                        condition: ProjectCubit.get(context).searchList.length > 0,
                        builder: (context) => Column(
                          children: List.generate(
                            ProjectCubit.get(context).searchList.length,
                                (index) {
                                  Project project = ProjectCubit.get(context).searchList[index];
                                  return ProjectListItem(
                                    project: project,
                                  );
                            },
                          ),
                        ),
                        fallback: (context) => SearchWidget(searchIn: "Notes")),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return BlocConsumer<TaskCubit, TaskStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasksCubit = TaskCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: mainColor,
            elevation: 0,
            titleSpacing: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(context),
            ),
            title: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              width: double.infinity,
              height: 40,
              margin: const EdgeInsetsDirectional.only(end: 14.0),
              child: Center(
                child: TextFormField(
                  controller: searchController,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)?.search,
                    prefixIcon: Icon(
                      Icons.search,
                      color: mainColor,
                    ),
                    focusColor: mainColor,
                    border: InputBorder.none,
                  ),
                  cursorColor: mainColor,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Enter text to search';
                    }
                    return null;
                  },

                  onChanged: (String text) {
                    TaskCubit.get(context).search(text);
                  },

                ),
              ),
            ),

          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  if (state is SearchTaskLoadingState) Center(child: CircularProgressIndicator()),
                  SizedBox(height: 5.0,),
                  if (state is RetrieveTaskDataFromDatabase)
                    ConditionalBuilder(
                      condition: tasksCubit.searchList.length > 0,
                      builder: (context) { 
                        return Column(
                        children: List.generate(
                          tasksCubit.searchList.length,
                              (index) {
                            return ListOfTasks(bundle: ArgumentBundle(extras: tasksCubit.searchList[index]));
                          },
                        ),
                      );
                      },
                      fallback: (context) => SearchWidget(searchIn: "Notes")),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
