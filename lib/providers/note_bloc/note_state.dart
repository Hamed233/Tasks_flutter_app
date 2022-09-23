part of 'note_bloc.dart';

abstract class NoteStates {}

class NoteInitial extends NoteStates {}

class ToggleViewNotesType extends NoteStates {}
class GettingNoteDataLoading extends NoteStates {}
class RetrieveNoteDataFromDatabase extends NoteStates {}
class ErrorWhenRetrieveNoteDataFromDatabase extends NoteStates {}

class RetrieveAllNotesFromDatabase extends NoteStates {
  List notes;

  RetrieveAllNotesFromDatabase(this.notes);
}
class AppUpdateDatabaseState extends NoteStates {}

class ArchiveNoteState extends NoteStates {}
class UnArchiveNoteState extends NoteStates {}
class DeleteNoteState extends NoteStates {}

class GettingNotesLoading extends NoteStates {}
class GettingNotesSuccessfully extends NoteStates {}
class GettingArchivedNotesSuccessfully extends NoteStates {}
class GettingArchivedNotesLoading extends NoteStates {}
class CreateDatabaseLoading extends NoteStates {}
class NotesNotFounded extends NoteStates {}
class NotesFounded extends NoteStates {}
class ColorOfNoteChanged extends NoteStates {}
class ColorOfNoteChangeTapped extends NoteStates {}

class NoteAddedSuccessfully extends NoteStates {
  final Note? note;

  NoteAddedSuccessfully(this.note);
}

class NoteAddedFailure extends NoteStates {
  final String message;

  NoteAddedFailure(this.message);
}

class CreatedNoteDBSuccessful extends NoteStates {}
class AppInsertDatabaseState extends NoteStates {}

// Search
class SearchNoteLoadingState extends NoteStates {}
class SearchNoteSuccessState extends NoteStates {}
class SearchNoteErrorState extends NoteStates {}
