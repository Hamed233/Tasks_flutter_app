import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_life_app/models/note_model.dart';
import 'package:manage_life_app/providers/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../../shared/components/constants.dart';

part 'note_state.dart';

enum viewType {
  List,
  Staggered
}

class NoteBloc extends Cubit<NoteStates> {
  NoteBloc() : super(NoteInitial());

  static NoteBloc get(context) => BlocProvider.of(context);

  var notesViewType;
  Note? noteModel;
  Database? database;

  void toggleViewType(){
    if(notesViewType == viewType.List) {
      notesViewType = viewType.Staggered;
      emit(ToggleViewNotesType());
    } else {
      notesViewType = viewType.List;
      emit(ToggleViewNotesType());
    }
  }


  Color? noteColor;
  var indexOfCurrentColor = 0;

  void colorChangeTapped(int indexOfColor) {
    noteColor = colors[indexOfColor];
    indexOfCurrentColor = indexOfColor;
    emit(ColorOfNoteChangeTapped());
  }

  List<Note> allNotes = [];
  List<Note> archivedNotes = [];

  Future getNotesList() async {
    
    emit(GettingNotesLoading());
    
    Database db = await DatabaseHelper.instance.db;

    allNotes = [];

    final List<Map<String, dynamic>> notesMapList = await db.query(DatabaseHelper.instance.notesTable, where: 'is_archived = ?', whereArgs: [0]);

    print(notesMapList);
    notesMapList.forEach((noteMap) {
      allNotes.add(Note.fromMap(noteMap));
    });

    emit(GettingNotesSuccessfully());
  }

  Future getArchivedNotesList() async {
    
    emit(GettingArchivedNotesLoading());
    
    Database db = await DatabaseHelper.instance.db;

    archivedNotes = [];

    final List<Map<String, dynamic>> archivedNotesMapList = await db.query(DatabaseHelper.instance.notesTable, where: 'is_archived = ?', whereArgs: [1]);

    print(archivedNotesMapList);
    archivedNotesMapList.forEach((noteArchivedMap) {
      archivedNotes.add(Note.fromMap(noteArchivedMap));
    });

    emit(GettingArchivedNotesSuccessfully());
  }

  Future<List<Map<String, dynamic>>> getMapSpecificNote(noteId) async {
    Database db = await DatabaseHelper.instance.db;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM ${DatabaseHelper.instance.notesTable} WHERE id = ${noteId}');
    return result;
  }

  List noteData = [];
  Future getNoteDataFromDB(noteId) async {

    final List<Map<String, dynamic>> noteMapList = await getMapSpecificNote(noteId);
    noteData = [];

    emit(GettingNoteDataLoading());

    noteMapList.forEach((tagMap) {
      noteData.add(tagMap);
    });
      
    emit(RetrieveNoteDataFromDatabase());
  }

  List<Note> searchList = [];
  // Search notes
  Future search(String text) async {
    emit(SearchNoteLoadingState());

    Database db = await DatabaseHelper.instance.db;
    db.rawQuery('SELECT * FROM notes_tbl WHERE note_title LIKE ? OR note_description LIKE ?', ['%$text%', '%$text%']).then((value) {
      emit(SearchNoteSuccessState());
      searchList = [];
      value.forEach((element) {
        searchList.add(Note.fromMap(element));
      });
      emit(RetrieveNoteDataFromDatabase());
    }).catchError((error) {
      print(error.toString());
      emit(SearchNoteErrorState());
    });
  }

  // updateNote({required noteTitle, required noteDescription, required noteDate, required noteColor, required indexOfColor, required noteId}) async {
  //   database!.rawUpdate('UPDATE notes SET note_title = ?, note_description = ?, note_date = ?, note_color = ?, index_of_color = ? WHERE id = ?',
  //       ['$noteTitle', '$noteDescription', '$noteDate', noteColor, indexOfColor, noteId]).then((value) {
  //     getDataFromDB(database);
  //     emit(AppUpdateDatabaseState());
  //   });
  // }

  // deleteNoteFromDatabase(int id) async {
  //   database!.rawDelete('DELETE FROM notes WHERE id = ?', [id]).then((value) {
  //     getDataFromDB(database);
  //     emit(DeleteNoteState());
  //   });
  // }

  // archiveNote(int id) async {
  //   database!.rawUpdate('UPDATE notes SET is_archived = 1 WHERE id = ?', [id]).then((value) {
  //     getDataFromDB(database);
  //     emit(ArchiveNoteState());
  //   });
  // }

  // unArchiveNote(int id) async {
  //   database!.rawUpdate('UPDATE notes SET is_archived = 0 WHERE id = ?', [id]).then((value) {
  //     getDataFromDB(database);
  //     emit(UnArchiveNoteState());
  //   });
  // }

  // void createDatabase() {

  //   emit(CreateDatabaseLoading());

  //   openDatabase(
  //     'DB_notes.db',
  //     version: 1,
  //     onCreate: (database, version) {
  //       database
  //           .execute(
  //           'CREATE TABLE notes (id INTEGER PRIMARY KEY, note_title TEXT, note_description TEXT, note_date TEXT, note_color INTEGER, index_of_color INTEGER, is_archived INTEGER)')
  //           .then((value) => print('Table Created'))
  //           .catchError((error) {
  //         print('Error When Creating Table ${error.toString()}');
  //       });
  //     },
  //     onOpen: (database) {
  //       getDataFromDB(database);
  //       print('$database database opened');
  //     },
  //   ).then((value) {
  //     database = value;
  //     emit(CreatedNoteDBSuccessful());
  //   });
  // }

  // // Get All Date from db
  // void getDataFromDB(database) async {

  //   newNotes = [];
  //   archivedNotes = [];

  //   emit(GettingNotesLoading());

  //   database.rawQuery('SELECT * FROM notes').then((value) {
  //     if(value != null) {
  //       emit(NotesFounded());
  //       value.forEach((element) {
  //         if (element['is_archived'] == '0') {
  //           newNotes.add(element);
  //         } else {
  //           archivedNotes.add(element);
  //         }
  //       });
  //       emit(RetrieveAllNotesFromDatabase(newNotes));
  //     } else {
  //       emit(NotesNotFounded());
  //     }

  //   });
  // }

  // List<dynamic> noteData = [];
  // // Get Specific Note Date from db
  // void getNoteDataFromDB(noteId) async {

  //   noteData = [];

  //   database!.rawQuery('SELECT * FROM notes WHERE id = ?', ['$noteId']).then((value) {
  //     emit(GettingNoteDataLoading());
  //       value.forEach((element) {
  //         noteData.add(element);
  //       });
  //       emit(RetrieveNoteDataFromDatabase());
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(ErrorWhenRetrieveNoteDataFromDatabase());
  //   });
  // }

  // insertNoteToDatabase({required noteTitle, noteDescription, required noteDate, int? noteColor, indexOfColor}) async {
  //   await database!.transaction((txn) async {
  //     txn.rawInsert(
  //         'INSERT INTO notes (note_title, note_description, note_date, note_color, index_of_color, is_archived) VALUES ("$noteTitle", "$noteDescription", "$noteDate", $noteColor, $indexOfColor, "0")')
  //         .then((value) {
  //       getDataFromDB(database);
  //       print('$value Inserted Successfully');
  //       emit(AppInsertDatabaseState());
  //     }).catchError((error) {
  //       print('Error When inserting Table ${error.toString()}');
  //     });
  //   });

  // }

  // List<Map> searchList = [];
  // // Search Notes
  // void search(String text) {
  //   emit(SearchNoteLoadingState());

  //   searchList = [];

  //   database!.rawQuery('SELECT * FROM notes WHERE note_title LIKE ? OR note_description LIKE ?', ['%$text%', '%$text%']).then((value) {
  //     emit(SearchNoteSuccessState());
  //     value.forEach((element) {
  //       searchList.add(element);
  //     });
  //     emit(RetrieveNoteDataFromDatabase());
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(SearchNoteErrorState());
  //   });
  // }

}
