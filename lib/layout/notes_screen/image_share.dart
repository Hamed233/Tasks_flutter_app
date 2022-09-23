import 'package:flutter/material.dart';
import 'package:manage_life_app/models/note_model.dart';
import 'package:manage_life_app/shared/components/animation.dart';
import 'package:manage_life_app/shared/components/app_icon.dart';
import 'package:manage_life_app/shared/components/constants.dart';
import 'package:manage_life_app/shared/styles/themes.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';

class ImageShare extends StatelessWidget {
  final ScrollController scrollController;
  final Note note;

  ImageShare({required this.scrollController, required this.note});

  Color accentColor = Colors.grey;
  final gradientColors = <Color>[];
  GlobalKey previewContainer = new GlobalKey();
  ImageShareColor? imageShareColor;
  ImageShareTextColor? imageShareTextColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        controller: scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Theme.of(context).cardColor,
            automaticallyImplyLeading: false,
            title: Text(
              'Share image (Preview)',
              style: Theme.of(context).textTheme.headline1,
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          imagePreview(context, note),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ShareFilesAndScreenshotWidgets().shareScreenshot(
            previewContainer,
            1024,
            "mission - note - ${note.id}",
            "mission_note_${note.id}.png",
            "image/png",
            text: "mission - note",
          );
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(
          Icons.ios_share,
        ),
      ),
    );
  }

  Widget imagePreview(context, noteData) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    final size = width < height ? width : height;
    final note = noteData;

    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        RepaintBoundary(
          key: previewContainer,
          child: Center(
            child: Container(
              width: size,
              child: Card(
                color: Color(note.note_color!),
                elevation: 2.0,
                child: Container(
                  decoration: imageShareColor == ImageShareColor.gradient
                      ? BoxDecoration(gradient: getGradientColor())
                      : BoxDecoration(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 30.0,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: AppIcon(
                          size: 40.0,
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            bottom: 20.0,
                          ),
                        ),
                      ),
                      createHeroNoteAnimation(
                        note: note,
                        isMobile: true,
                        screenWidth: size - 20.0,
                        screenHeight: size - 20.0,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 60.0,
                        child: Divider(
                          thickness: 2.0,
                          height: 40.0,
                          color: accentColor,
                        ),
                      ),
                      Opacity(
                        opacity: 0.9,
                        child: Text(
                          note.note_description!,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      
                      Opacity(
                        opacity: 0.9,
                        child: Text(
                          note.note_date!,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Gradient getGradientColor() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: gradientColors,
    );
  }

}
