import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:manage_life_app/layout/notes_screen/share.dart';
import 'package:manage_life_app/models/note_model.dart';
import 'package:manage_life_app/providers/note_bloc/note_bloc.dart';
import 'package:manage_life_app/shared/utiles/helper.dart';
import 'package:manage_life_app/shared/utiles/utils.dart';

class NoteItem extends StatelessWidget {
  Note? note;
  double? _fontSize;

  NoteItem({this.note});

  @override
  Widget build(BuildContext context) {
    _fontSize = _determineFontSizeForContent();
    var noteColor = note!.note_color != null ? note!.note_color : 4294967295;

    Widget notesWithDate;

    if(NoteBloc.get(context).notesViewType == viewType.List) {
      notesWithDate = Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .70,
            child: AutoSizeText(
              note!.note_description!,
              style: TextStyle(fontSize: _fontSize),
              maxLines: 10,
              textScaleFactor: 1.5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Spacer(),
          Text(
            note!.note_date!,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      );
    } else {
      notesWithDate = AutoSizeText(
        note!.note_description!,
        style: TextStyle(fontSize: _fontSize),
        maxLines: 10,
        textScaleFactor: 1.5,
        overflow: TextOverflow.ellipsis,
      );
    }

    return InkWell(
      onTap: () {
        Helper.showNoteBottomSheet(context, isUpdate: true, noteId: note!.id!);
      },
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
              border: Color(noteColor!) == Colors.white ? Border.all(color: CentralStation.borderColor) : null,
              color: Color(noteColor),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AutoSizeText(
                      note!.note_title!,
                      style: TextStyle(fontSize: _fontSize,fontWeight: FontWeight.bold),
                      maxLines: note!.note_title!.length == 0 ? 1 : 3,
                      textScaleFactor: 1.5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          Icons.share,
                          color: Color(noteColor),
                          size: 17,
                        ),
                        onPressed: () {
                          ShareActions.shareNote(
                            context: context,
                            note: note!,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                notesWithDate,
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _determineFontSizeForContent() {
    int charCount = note!.note_description!.length + note!.note_title!.length ;
    double fontSize = 20 ;
    if (charCount > 110 ) { fontSize = 12; }
    else if (charCount > 80) {  fontSize = 14;  }
    else if (charCount > 50) {  fontSize = 16;  }
    else if (charCount > 20) {  fontSize = 18;  }


    return fontSize;
  }
}