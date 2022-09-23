import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manage_life_app/layout/notes_screen/archived_notes_screen.dart';
import 'package:manage_life_app/layout/notes_screen/note_item.dart';
import 'package:manage_life_app/layout/search/search_screen.dart';
import 'package:manage_life_app/providers/note_bloc/note_bloc.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../routes/argument_bundle.dart';
import '../../routes/page_path.dart';

class NotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteBloc, NoteStates>(
      listener: (context, state) {
        if (state is GettingNotesLoading) {}
      },
      builder: (context, state) {
        var noteBloc = NoteBloc.get(context);
        var notesViewType = noteBloc.notesViewType;
        var notes = noteBloc.allNotes;
        var numOfArchivedNotes = "0";

        if (noteBloc.archivedNotes.length != 0) {
          if (noteBloc.archivedNotes.length >= 9) {
            numOfArchivedNotes = "+9";
          } else {
            numOfArchivedNotes = noteBloc.archivedNotes.length.toString();
          }
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: mainColor,
            elevation: 0,
            leading: CircleAvatar(
              child: SvgPicture.asset(
                Resources.notesWhite,
                width: 25,
                height: 25,
              ),
              radius: 50,
              backgroundColor: Colors.transparent,
            ),
            titleSpacing: 0,
            title: Text(
              AppLocalizations.of(context)!.stickyNotes,
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      PagePath.searchScreen,
                      arguments: ArgumentBundle(
                          extras: "Notes Search", identifier: 'notes'),
                    );
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 25,
                  )),
              InkWell(
                onTap: () => navigateTo(context, ArchiveNotesScreen()),
                child: IconButton(
                  onPressed: () {
                    navigateTo(context, ArchiveNotesScreen());
                  },
                  icon: Stack(
                    children: <Widget>[
                      const Icon(Icons.archive_outlined, color: Colors.white,),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            numOfArchivedNotes,
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              
              IconButton(
                onPressed: () => NoteBloc.get(context).toggleViewType(),
                icon: Icon(
                  NoteBloc.get(context).notesViewType == viewType.List
                      ? Icons.developer_board
                      : Icons.view_headline,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ConditionalBuilder(
                condition: state is GettingNotesLoading ||
                    state is! GettingArchivedNotesLoading,
                builder: (context) => Container(
                  child: ConditionalBuilder(
                    condition: notes.length != 0,
                    builder: (context) => Padding(
                      padding: paddingForView(context),
                      child: StaggeredGrid.count(
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                        crossAxisCount: notesViewType == viewType.List
                            ? 1
                            : MediaQuery.of(context).size.width > 600
                                ? 3
                                : 2,
                        children: List.generate(
                          notes.length,
                          (index) {
                            return NoteItem(
                              note: notes[index],
                            );
                          },
                        ),
                      ),
                    ),
                    fallback: (context) => Center(
                      child: SvgPicture.asset(
                        Resources.empty,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .75,
                      ),
                    ),
                  ),
                ),
                fallback: (context) => Center(
                  child: CircularProgressIndicator(
                    color: mainColor,
                  ),
                  heightFactor: 15,
                ),
              )),
        );
      },
    );
  }

  EdgeInsets paddingForView(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding;
    double top_bottom = 8;
    if (width > 500) {
      padding = (width) * 0.05; // 5% padding of width on both side
    } else {
      padding = 8;
    }
    return EdgeInsets.only(
        left: padding, right: padding, top: top_bottom, bottom: top_bottom);
  }
}
