
import 'package:flutter/material.dart';
import 'package:manage_life_app/layout/layout_of_app.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';


class Resources {
  // ICON BOTTOM NAVIGATION BAR ASSETS
  static const String dashboardActive = 'assets/svg/dashboard-active.svg';
  static const String dashboardInactive = 'assets/svg/dashboard-inactive.svg';

  static const String tasksActive = 'assets/svg/tasks-active.svg';
  static const String tasksInactive = 'assets/svg/tasks-inactive.svg';
  static const String tasksWhite = 'assets/svg/tasks-white.svg';

  static const String notesActive = 'assets/svg/notes-active.svg';
  static const String notesInactive = 'assets/svg/notes-inactive.svg';
  static const String notesWhite = 'assets/svg/notes-white.svg';

  static const String bagActive = 'assets/svg/bag_active.svg';
  static const String bagInactive = 'assets/svg/bag_inactive.svg';

  static const String calendarActive = 'assets/svg/calendar_active.svg';
  static const String calendarInactive = 'assets/svg/calendar_inactive.svg';

  static const String projectsActive = 'assets/svg/projects_active.svg';
  static const String projectsInactive = 'assets/svg/projects_inactive.svg';

  static const String avatarActive = 'assets/svg/avatar_active.svg';
  static const String avatarInactive = 'assets/svg/avatar_inactive.svg';

  static const String profileActive = 'assets/svg/profile_active.svg';
  static const String profileInactive = 'assets/svg/profile_inactive.svg';

  static const String cupActive = 'assets/svg/cup-active.svg';
  static const String cupInactive = 'assets/svg/cup-inactive.svg';

  // SVG ASSETS
  static const String icon_outlined = 'assets/svg/icon_outlined.svg';
  static const String tasksListWhite = 'assets/svg/tasks-list-white.svg';
  static const String on_board_1 = 'assets/svg/on_board_1.svg';
  static const String on_board_2 = 'assets/svg/on_board_2.svg';
  static const String on_board_3 = 'assets/svg/on_board_3.svg';
  static const String clock = 'assets/svg/clock.svg';
  static const String date = 'assets/svg/date.svg';
  static const String trash = 'assets/svg/trash.svg';
  static const String complete = 'assets/svg/complete.svg';
  static const String empty = 'assets/svg/empty.svg';
  static const String day = 'assets/svg/day.svg';
  static const String week = 'assets/svg/week.svg';
  static const String month = 'assets/svg/month.svg';
  static const String halfYear = 'assets/svg/half_year.svg';
  static const String year = 'assets/svg/year.svg';
  static const String staticTasks = 'assets/svg/static.svg';
  static const String basicTitle = 'assets/svg/basics.svg';
  static const String planTitle = 'assets/svg/plans.svg';
  static const String pomodoroTimer = 'assets/svg/pomodorotimer.svg';
  static const String pomodoroTimerGrey = 'assets/svg/pomodorotimer_grey.svg';
  
  // Social 
  static const String facebook = 'assets/svg/facebook.svg';
  static const String twitter = 'assets/svg/twitter.svg';
  static const String google = 'assets/svg/google.svg';

  // IMAGE ASSETS
  static const String avatarImage = 'assets/img/avatar.jpg';

// LOTTIE ASSETS
  static const String loading = 'assets/lottie/loading.json';
  // static const String empty = 'assets/lottie/empty.json';
  static const String error = 'assets/lottie/error.json';
  static const String search = 'assets/lottie/search.json';
  static const String garbage = 'assets/lottie/garbage.json';
  static const String thinking = 'assets/lottie/thinking.json';
}

class FormatDate {
  static const String monthDayYear = 'MMM dd, yyyy';
  static const String deadline = 'HH:mm, MMM dd, yyyy';
  static const String monthYear = 'MMMM, yyyy';
  static const String dayDate = 'EEE, dd';
}

const Icon kPlayClockButton = Icon(Icons.play_arrow_sharp);
const Icon kPauseClockButton = Icon(Icons.pause_sharp);

// Time constants
final kWorkDuration = Duration(minutes: 25);
final kShortBreakDuration = Duration(minutes: 5);
final kLongBreakDuration = Duration(minutes: 15);
final longBreakAfter = 3;
final targetInterval = 5;

// Text constants
const String kWorkLabel = 'Work';
const String kShortBreakLabel = 'Short break';
const String kLongBreakLabel = 'Long break';

const Map<int,String> days = {
  7: "Sunday",
  1: "Monday",
  2: "Tuesday",
  3: "Wednesday",
  4: "Thursday",
  5: "Friday",
  6: "Saturday",
};

const List<Duration> durations = [
  Duration(minutes: 5),
  Duration(minutes: 10),
  Duration(minutes: 15),
  Duration(minutes: 20),
  Duration(minutes: 25),
  Duration(minutes: 30),
  Duration(minutes: 35),
  Duration(minutes: 40),
  Duration(minutes: 45),
  Duration(minutes: 50),
  Duration(minutes: 52),
  Duration(minutes: 55),
  Duration(minutes: 60),
  Duration(minutes: 75),
  Duration(minutes: 90),
  Duration(minutes: 120),
  Duration(minutes: 150),
  Duration(minutes: 180),
];
const List<Duration> longBreakDurations = [
  Duration(minutes: 5),
  Duration(minutes: 10),
  Duration(minutes: 15),
  Duration(minutes: 17),
  Duration(minutes: 20),
  Duration(minutes: 25),
  Duration(minutes: 30),
  Duration(minutes: 35),
  Duration(minutes: 40),
  Duration(minutes: 45),
  Duration(minutes: 50),
  Duration(minutes: 60),
];
const List<Duration> shortBreakDurations = [
  Duration(minutes: 1),
  Duration(minutes: 2),
  Duration(minutes: 3),
  Duration(minutes: 4),
  Duration(minutes: 5),
  Duration(minutes: 6),
  Duration(minutes: 7),
  Duration(minutes: 8),
  Duration(minutes: 9),
  Duration(minutes: 10),
  Duration(minutes: 12),
  Duration(minutes: 15),
  Duration(minutes: 17),
  Duration(minutes: 20),
];

final colors = [
  Color(4294967295), // classic white
  Color(4294085505), // light pink
  Color(4294425858), // yellow
  Color(4294702198), // light yellow
  Color(4291690384), // light green
  Color(4289199851), // turquoise
  Color(4291555576), // light cyan
  Color(4289711098), // light blue
  Color(4292325116), // plum
  Color(4294692841), // misty rose
  Color(4293314985), // light brown
  Color(4293520110)  // light gray
];

enum TimerType {
  WORK,
  BREAK,
  LONG_BREAK,
}

enum ProjectStatus {
  ONGOING,
  COMPLETED,
  SUSPENDED
}

enum UserType {
  Student,
  Programmer,
  Freelancer,
  Entrepreneur,
  Default,
}


enum ImageShareColor {
  dark,
  light,
  colored,
  gradient,
}

enum ImageShareTextColor {
  auto,
  dark,
  light,
}

enum AniProps {
  color,
  height,
  opacity,
  translateX,
  translateY,
  width,
}

/// Twitter web intent API -> [hashtags] section.
/// More info at https://twitter.com/intent/tweet.
const twitterShareHashtags = "&hashtags=note,citation,fig_style";

/// Twitter web intent API.
/// More info at https://twitter.com/intent/tweet.
const baseTwitterShareUrl = "https://twitter.com/intent/tweet"
    "?via=fig_style&text=";

TimeOfDay wakeUpTime = TimeOfDay.now().replacing(hour: 7, minute: 00);
TimeOfDay sleepTime = TimeOfDay.now().replacing(hour: 21, minute: 00);
var currentLang = CacheHelper.getData(key: "current_lang");