part of 'task_bloc.dart';

abstract class TaskStates {}

class TaskInitial extends TaskStates {}

class TaskLoading extends TaskStates {}

class TaskSuccess extends TaskStates {}

class TaskStream extends TaskStates {}

class OnGoingTaskStream extends TaskStates {}

class CompletedTaskStream extends TaskStates {}

class TaskByCategoryStream extends TaskStates {}

class TaskFailure extends TaskStates {}

class ToggleViewTasksType extends TaskStates {}
class GettingTaskDataLoading extends TaskStates {}
class GettingFolderDataLoading extends TaskStates {}
class GettingTasksFolderDataLoading extends TaskStates {}
class DoneCheckForDeadlineOfTasks extends TaskStates {}

class GetTaskDate extends TaskStates {}
class IsPriorityChanged extends TaskStates {}
class GetFolder extends TaskStates {}
class GetProjectTagged extends TaskStates {}
class GetNewSort extends TaskStates {}
class GetNewSortLoading extends TaskStates {}
class TaskRating extends TaskStates {}
class GetTaskTime extends TaskStates {}
class SelectedDuration extends TaskStates {}
class SelectedDurationLoading extends TaskStates {}
class DoneTask extends TaskStates {}
class TasksToggleView extends TaskStates {}
class ChangeIconFolder extends TaskStates {}
class ColorOfFolderChangeTapped extends TaskStates {}

// Database
class CreateTaskDatabaseLoading extends TaskStates {}
class CreatedTaskDBSuccessful extends TaskStates {}
class GettingTasksLoading extends TaskStates {}
class RetrieveTasksFromDatabase extends TaskStates {}
class TasksNotFounded extends TaskStates {}
class RetrieveTaskDataFromDatabase extends TaskStates {}
class RetrieveFolderDataFromDatabase extends TaskStates {}
class RetrieveProjectFoldergedDataFromDatabase extends TaskStates {}
class GettingProjectFoldergedDataLoading extends TaskStates {}
class GettingProjectsFoldergedLoading extends TaskStates {}
class RetrieveProjectsFoldergedDataSuccess extends TaskStates {}

class RetrieveTasksFolderDataFromDatabase extends TaskStates {}
class GettingTasksProjectDataLoading extends TaskStates {}
class RetrieveTasksProjectDataFromDatabase extends TaskStates {}
class ErrorWhenRetrieveTaskDataFromDatabase extends TaskStates {}
class TaskInsertedSuccessfully extends TaskStates {}
class TaskArchived extends TaskStates {}
class UnArchiveTask extends TaskStates {}
class TaskDeleted extends TaskStates {}
class SearchTaskLoadingState extends TaskStates {}
class SearchTaskSuccessState extends TaskStates {}
class SearchTaskErrorState extends TaskStates {}
class ToggleAsDoneTask extends TaskStates {}
class GettingFoldersLoading extends TaskStates {}
class RetrieveFoldersData extends TaskStates {}

