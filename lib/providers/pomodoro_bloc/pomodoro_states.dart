abstract class PomodoroStates {}
class PomodoroInitial extends PomodoroStates {}
class PomodoroStoped extends PomodoroStates {}
class PomodoroStarted extends PomodoroStates {}
class PomodoroReseted extends PomodoroStates {}
class PomodoroChangeNextStatus extends PomodoroStates {}
class UpdateTimeLeft extends PomodoroStates {}
class ChangedPomodoroDuration extends PomodoroStates {}
class GetUserPomodoroSettingsLoadingState extends PomodoroStates {}
class GetUserPomodoroSettingsSuccessState extends PomodoroStates {}
class GetUserPomodoroSettingsErrorState extends PomodoroStates {}
class UpdateUserPomodoroSettingsSuccessState extends PomodoroStates {}
class UpdateUserPomodoroSettingsErrorState extends PomodoroStates {}
class UpdateUserPomodoroSettingsLoadingState extends PomodoroStates {}
