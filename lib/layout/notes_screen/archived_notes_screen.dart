import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manage_life_app/layout/notes_screen/note_item.dart';
import 'package:manage_life_app/layout/search/search_screen.dart';
import 'package:manage_life_app/providers/note_bloc/note_bloc.dart';
import 'package:manage_life_app/shared/components/components.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:manage_life_app/routes/argument_bundle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../routes/page_path.dart';

class ArchiveNotesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteBloc, NoteStates>(
        listener: (context, state) {},
        builder: (context, state) {
          
          var notesViewType = NoteBloc.get(context).notesViewType;
          var archivedNotes = NoteBloc.get(context).archivedNotes;
    
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              elevation: 0,
              backgroundColor: mainColor,
              title: Text(
                AppLocalizations.of(context)!.archivedNotes,
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              titleSpacing: 0,
              shadowColor: Colors.transparent,
              actions: [
                IconButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    PagePath.searchScreen,
                    arguments: ArgumentBundle(extras: "Notes Search", identifier: 'notes'),
                  ),
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => NoteBloc.get(context).toggleViewType(),
                  icon: Icon(
                    NoteBloc.get(context).notesViewType == viewType.List ?  Icons.developer_board : Icons.view_headline,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
                child: ConditionalBuilder(
                  condition: state is GettingNotesLoading || state is! GettingArchivedNotesLoading,
                  builder: (context) => Container(
                    child: ConditionalBuilder(
                      condition: archivedNotes.length > 0,
                      builder: (context) => Padding(
                        padding: paddingForView(context),
                        child: StaggeredGrid.count(
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 4.0,
                          crossAxisCount: notesViewType == viewType.List ? 1 : MediaQuery.of(context).size.width > 600 ? 3:2,
                          children: List.generate(
                            archivedNotes.length,
                                (index) {
                              return NoteItem(note: archivedNotes[index],);
                            },
                          ),
                        ),
                      ),
                      fallback: (context) => Center(
                        child: SvgPicture.asset(Resources.empty, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * .75,),),
                    ),
                  ),
                  fallback: (context) => Center(child: CircularProgressIndicator(color: mainColor,), heightFactor: 15,),
                )
            ),
          );
        }
    );
  }


  EdgeInsets paddingForView(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double padding ;
    double top_bottom = 8;
    if (width > 500) {
      padding = ( width ) * 0.05 ; // 5% padding of width on both side
    } else {
      padding = 8;
    }
    return EdgeInsets.only(left: padding, right: padding, top: top_bottom, bottom: top_bottom);
  }
}