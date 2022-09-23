import 'dart:math';

import 'package:flutter/material.dart';
import 'package:manage_life_app/models/note_model.dart';
import 'package:manage_life_app/shared/components/fade_in_y.dart';
import 'package:simple_animations/simple_animations.dart';


/// Create a widget animating a note's name.
/// Decides which animation is most suited for the note.
Widget createHeroNoteAnimation({
  Note? note,
  double? screenWidth,
  double? screenHeight,
  TextStyle? style,
  bool isMobile = false,
}) {
  screenHeight = screenHeight ?? screenWidth;

  final noteName = note!.note_title;
  final denominator = dividerNumber(
    isMobile: isMobile,
    screenWidth: screenWidth!,
    screenHeight: screenHeight!,
  );

  final fontSize = hero(note.note_title!) / denominator;

  if (style == null) {
    style = TextStyle(
      fontSize: fontSize,
    );
  } else {
    style = style.merge(TextStyle(
      fontSize: fontSize,
    ));
  }

  if (noteName!.contains(',')) {
    return createPunctuationAnimation(
      style: style,
      note: note,
      punctuation: ', ',
      screenWidth: screenWidth,
    );
  }

  if (noteName.contains('. ')) {
    return createPunctuationAnimation(
      style: style,
      note: note,
      punctuation: '. ',
      screenWidth: screenWidth,
    );
  }

  if (noteName.contains('; ')) {
    return createPunctuationAnimation(
      style: style,
      note: note,
      punctuation: '; ',
      screenWidth: screenWidth,
    );
  }

  if (noteName.length > 90) {
    return createLengthAnimation(
      style: style,
      note: note,
      screenWidth: screenWidth,
    );
  }

  return CustomAnimation(
    duration: Duration(seconds: 1),
    tween: Tween(begin: 0.0, end: 1.0),
    builder: (context, child, double value) {
      return Opacity(opacity: value, child: child);
    },
    child: Text(
      note.note_title!,
      style: style,
    ),
  );
}

double dividerNumber({
  double? screenWidth,
  double? screenHeight,
  bool isMobile = false,
}) {
  if (isMobile) {
    return 800 / min(screenWidth!, screenHeight!);
  }

  return 1452 / screenWidth!;
}

/// Create animations according to the note's punctuation.
Widget createPunctuationAnimation({
  Note? note,
  String? punctuation,
  double? screenWidth,
  TextStyle? style,
}) {
  final noteName = note!.note_title;

  final indexes = <int>[];
  bool hasNext = true;

  while (hasNext) {
    final index = noteName!.indexOf(punctuation!);

    if (indexes.contains(index)) {
      hasNext = false;
    } else {
      indexes.add(index);
    }
  }

  int delayFactor = 0;

  final children = noteName!.split(' ').map((word) {
    word += ' ';

    if (word.endsWith(punctuation!)) {
      delayFactor++;
    }

    return FadeInY(
      endY: 0.0,
      beginY: 10.0,
      delay: Duration(milliseconds: delayFactor * 100),
      child: Text(
        word,
        style: style,
      ),
    );
  });

  return Wrap(
    children: <Widget>[
      ...children,
    ],
  );
}

/// Create animations according to the note's length.
Widget createLengthAnimation(
    {Note? note, double? screenWidth, TextStyle? style}) {
  final noteName = note!.note_title;

  final half = noteName!.length ~/ 2;
  final rightHalf = noteName.indexOf(' ', half);

  int index = 0;
  int delayFactor = 0;

  final children = noteName.split(' ').map((word) {
    word += ' ';

    if (rightHalf > index) {
      delayFactor++;
    }

    index++;

    return FadeInY(
      endY: 0.0,
      beginY: 10.0,
      delay: Duration(milliseconds: delayFactor * 100),
      child: Text(
        word,
        style: style,
      ),
    );
  });

  return Wrap(
    children: <Widget>[
      ...children,
    ],
  );
}

double hero(String text) {
  final length = text.length;

  if (length < 100) { return 80.0; }
  else if (length < 200) { return 60.0; }
  else if (length < 400) { return 40.0; }

  return 30.0;
}