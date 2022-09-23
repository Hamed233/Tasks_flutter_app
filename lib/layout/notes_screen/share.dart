import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:manage_life_app/layout/notes_screen/image_share.dart';
import 'package:manage_life_app/models/note_model.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

/// Interface for share to external sources.
class ShareActions {

  static void shareNote({
    required BuildContext context,
    required Note note,
  }) {
    shareNoteMobile(
      note: note,
      context: context,
    );
  }

  static void shareNoteMobile({
    required BuildContext context,
    required Note note,
  }) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                mainAxisAlignment: MainAxisAlignment.center,
                
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Share as?",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  Divider(color: Colors.grey,),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            shareTextMobile(context: context, note: note);
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadiusDirectional.circular(10),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.text_fields_rounded,
                                  size: 40,
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  'Text',
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                       Expanded(
                         child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) => ImageShare(
                                scrollController: ModalScrollController.of(context)!,
                                note: note,
                            ));                     
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadiusDirectional.circular(10),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 40,
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  'Image',
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                       ),
                    ],
                  ),
                  SizedBox(height: 15,),
              ]),
            ),
          ),
        );
      },
    );
  }

  static void shareTextMobile({
    required BuildContext context,
    required Note note,
  }) {
    final RenderObject? box = context.findRenderObject();
    final noteName = note.note_title!;
    final noteDescription = note.note_description ?? '';
    // final referenceName = note.reference?.name ?? '';

    String sharingText = noteName;

    if (noteDescription.length > 0) {
      sharingText += '\n$noteDescription';
    }

    Share.share(
      sharingText,
      subject: 'Note (${note.id}) | mission',
      // sharePositionOrigin: box?.localToGlobal(Offset.zero) & box?.size,
    );
  }

  
}
