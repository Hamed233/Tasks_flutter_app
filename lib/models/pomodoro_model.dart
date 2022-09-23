import '../providers/pomodoro_bloc/pomodoro_cubit.dart';

class Pomodoro {
  Duration targetTime;
  Status status;
  int count;

  Pomodoro({
    required this.targetTime,
    required this.status,
    required this.count,
  });

  void setParam({Duration? time, Status? status}) {
    this.targetTime = time!;
    this.status = status!;
  }
}