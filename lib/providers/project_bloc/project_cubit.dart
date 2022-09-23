import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_life_app/models/project_model.dart';
import 'package:manage_life_app/providers/helpers/database_helper.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/providers/project_bloc/project_states.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:sqflite/sqflite.dart';

class ProjectCubit extends Cubit<ProjectStates> {
  ProjectCubit() : super(ProjectInitial());

  static ProjectCubit get(context) => BlocProvider.of(context);  

  Color? projectColor;
  var indexOfCurrentColor = 0;

  void colorChangeTapped(int indexOfColor) {
    projectColor = colors[indexOfColor];
    indexOfCurrentColor = indexOfColor;
    emit(ColorOfProjectChangeTapped());
  }


  List projectData = [];
  Future getProjectDataFromDB(projectId) async {

    emit(GettingProjectDataLoading());
    
    Database db = await DatabaseHelper.instance.db;
    final List<Map<String, dynamic>> projectMapList = await db.query(DatabaseHelper.instance.projectsTable, where: 'id = ?', whereArgs: [projectId]);
    projectData = [];

    projectMapList.forEach((data) {
      projectData.add(data);
    });
      
    emit(RetrieveProjectDataFromDatabase());
  }

  List<Project> archivedProjects = [];
  List<Project> allProjects = [];

  Future getArchivedProjectsList() async {
    
    emit(GettingArchivedProjectsLoading());
    
    Database db = await DatabaseHelper.instance.db;

    archivedProjects = [];

    final List<Map<String, dynamic>> archivedProjectsMapList = await db.query(DatabaseHelper.instance.projectsTable, where: 'is_archived = ?', whereArgs: [1]);

    archivedProjectsMapList.forEach((noteArchivedMap) {
      archivedProjects.add(Project.fromMap(noteArchivedMap));
    });

    emit(GettingArchivedProjectsSuccessfully());
  }

  Future getProjectsList({sortBy = "id DESC"}) async {
    
    emit(GettingAllProjectsLoading());
    
    Database db = await DatabaseHelper.instance.db;

    allProjects = [];

    final List<Map<String, dynamic>> projectsMapList = await db.query(DatabaseHelper.instance.projectsTable, where: 'is_archived = ?', whereArgs: [0], orderBy: sortBy);

    projectsMapList.forEach((noteMap) {
      allProjects.add(Project.fromMap(noteMap));
    });

    print(projectsMapList);

    emit(GettingProjectsSuccessfully());
  }

  String? projectsSortType = CacheHelper.getData(key: 'projectsSortType');
  void sortBy(_sortType)  {
    emit(ProjectsNewSortLoading());
    CacheHelper.saveData(
      key: 'projectsSortType',
      value: _sortType,
    );
    projectsSortType = CacheHelper.getData(key: 'projectsSortType');
    getProjectsList(sortBy: projectsSortType);
    emit(ProjectsNewSortSuccess());
  }

  List<Project> searchList = [];
  // Search tasks
  Future search(String text) async {
    emit(SearchProjectLoadingState());

    Database db = await DatabaseHelper.instance.db;
    db.rawQuery('SELECT * FROM projects_tbl WHERE is_archived = ? AND project_title LIKE ? OR project_description LIKE ?', ["0", '%$text%', '%$text%']).then((value) {
      emit(SearchProjectSuccessState());
      searchList = [];
      value.forEach((element) {
        searchList.add(Project.fromMap(element));
      });
      emit(RetrieveProjectDataFromDatabase());
    }).catchError((error) {
      print(error.toString());
      emit(SearchProjectErrorState());
    });
  }
}