import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:manage_life_app/models/note_model.dart';
import 'package:manage_life_app/providers/helpers/database_helper.dart';
import 'package:manage_life_app/providers/note_bloc/note_bloc.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/components/default_form_field.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/styles/themes.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoteSheet extends StatelessWidget {

  bool isUpdate;
  int noteId;
  Note? note;

  NoteSheet(this.isUpdate, this.noteId);

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
    NoteBloc cubit = NoteBloc.get(context);
    var noteIndex;
    var isArchived = 0;
    List noteData = [];

    return BlocConsumer<NoteBloc, NoteStates>(
      listener: (context, state) {
        if(state is RetrieveNoteDataFromDatabase) {}
      },
      builder: (context, state) {
        if(isUpdate) {
          noteData = cubit.noteData.toList();
          if(noteData.length != 0 && state is! ColorOfNoteChangeTapped) {
            noteIndex = noteData[0]['index_of_color'];
            noteColor = Color(noteData[0]['note_color']);
            titleController = TextEditingController()..text = noteData[0]["note_title"].toString();
            descriptionController = TextEditingController()..text = noteData[0]["note_description"].toString();
            isArchived = noteData[0]['is_archived'];
          }
        }

        return Material(
          color: noteColor != null && state is! ColorOfNoteChangeTapped ? noteColor : cubit.noteColor,
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
                                      Note model = Note(
                                        note_title: noteData[0]['note_title'],
                                        note_description: noteData[0]['note_description'],
                                        note_date: noteData[0]['note_date'],
                                        note_color: noteData[0]['note_color'],
                                        index_of_color: noteData[0]['index_of_color'],
                                        is_archived: 1,
                                      );

                                      model.id = noteId;
                                      
                                      
                                        DatabaseHelper.instance.updateTable(note: model).then((value) {
                                          cubit.getArchivedNotesList();
                                          cubit.getNotesList();
                                          Navigator.pop(context);
                                          Helper.showCustomSnackBar(context, content: "Note Archived!", bgColor: Colors.green, textColor: Colors.white);
                                      });
                                    } else {
                                     Note model = Note(
                                        note_title: noteData[0]['note_title'],
                                        note_description: noteData[0]['note_description'],
                                        note_date: noteData[0]['note_date'],
                                        note_color: noteData[0]['note_color'],
                                        index_of_color: noteData[0]['index_of_color'],
                                        is_archived: 0,
                                      );

                                      model.id = noteId;

                                        DatabaseHelper.instance.updateTable(note: model).then((value) {
                                          cubit.getArchivedNotesList();
                                          cubit.getNotesList();
                                          Navigator.pop(context);
                                          Helper.showCustomSnackBar(context, content: "Note Unarchived!", bgColor: Colors.green, textColor: Colors.white);
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
                                    DatabaseHelper.instance.deleteFromTable("notes", noteId).then((value) {
                                      cubit.getNotesList();
                                      Navigator.pop(context);
                                      Helper.showCustomSnackBar(context,
                                        content:
                                            AppLocalizations.of(context)!.noteDeleted,
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
                                isUpdate ? 'Edit Note' : 'Add Note',
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
                                    Note note = Note(
                                      note_title: titleController.text,
                                      note_description:  descriptionController.text,
                                      note_date: DateFormat('yMd').format(DateTime.now()),
                                      index_of_color: cubit.indexOfCurrentColor,
                                      note_color: cubit.noteColor != null ? cubit.noteColor!.value : 4294967295,
                                      is_archived: noteData[0]['is_archived']
                                    );

                                    note.id = noteId;

                                    DatabaseHelper.instance.updateTable(note: note).then((value) {
                                        cubit.getNotesList();
                                        Navigator.pop(context);
                                        Helper.showCustomSnackBar(context, content: "Note Updated Successfully!", bgColor: Colors.green, textColor: Colors.white);
                                    });
                                  } else {
                                    Note model = Note(
                                      note_title: titleController.text,
                                      note_description:  descriptionController.text,
                                      note_date: DateFormat('yMd').format(DateTime.now()),
                                      index_of_color: cubit.indexOfCurrentColor,
                                      note_color: cubit.noteColor != null ? cubit.noteColor!.value : 4294967295,
                                      is_archived: 0,
                                    );

                                    DatabaseHelper.instance.insertDataToTable(context, note: model).then((value) {
                                      cubit.getNotesList();
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
                state is! GettingNoteDataLoading ? Padding(
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
                              label: 'Note Title',
                              autoFocus: true,
                              focusedColorBorder: cubit.indexOfCurrentColor == 0 ? mainColor : Colors.white38,
                              hintText: 'note title',
                              labelColor: Colors.grey[800],
                              type: TextInputType.text,
                              prefixColorIcon: cubit.indexOfCurrentColor == 0 ? mainColor : Colors.grey[800],
                              prefix: Icons.note_outlined,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your title Note';
                                }
                                return null;
                              },
                              borderColor: borderColor,
                            ),
                            SizedBox(height: 10),
                            DefaultFormField(
                              controller: descriptionController,
                              label: 'Note Description',
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
                                                child: checkColor(cubit, index, noteIndex, state),
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

  Widget? checkColor(cubit, index, noteIndex, state) {
    if(isUpdate && index == noteIndex && state is! ColorOfNoteChangeTapped) {
      return _check;
    } else {
      if(cubit.indexOfCurrentColor == index && state is ColorOfNoteChangeTapped) {
        return _check;
      }
    }

    return null;
  }
}
