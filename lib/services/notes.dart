import 'package:uuid_type/uuid_type.dart';

import '../dao/notes.dart';
import '../models/note.dart';

import '../models/user_note.dart';

import '../dao/cloud_storage.dart';
import '../theme/note_theme.dart';

enum SortBy {
  lastModified,
  title,
}

enum SortOrder {
  ascending,
  descending,
}

class NotesService {
  static Future<List<UserNote>> getNotes(
      SortBy sortBy, SortOrder sortOrder) async {
    List<UserNote> userNotes = await NotesDAO.getAllNotes();
    List<Map<String, dynamic>> notesData = userNotes.map((userNote) => userNote.toMap()).toList();

    if (sortBy == SortBy.lastModified) {
      if (sortOrder == SortOrder.descending) {
        notesData.sort((a, b) => (dateFormat.parse(b[sortBy.name]))
            .compareTo(dateFormat.parse(a[sortBy.name])));
      } else {
        notesData.sort((a, b) => (dateFormat
            .parse(a[sortBy.name])
            .compareTo(dateFormat.parse(b[sortBy.name]))));
      }
    } else if (sortOrder == SortOrder.descending) {
      notesData.sort((a, b) => (b[sortBy.name]).compareTo(a[sortBy.name]));
    } else {
      notesData.sort((a, b) => (a[sortBy.name]).compareTo(b[sortBy.name]));
    }

    userNotes = notesData.map((noteData) => UserNote(id: noteData['id'], title: noteData['title'], color: noteData['color'], lastModified: noteData['lastModified'], accessRights: noteData['accessRights'])).toList();
    return userNotes;
  }

  static Future<void> insertNote(Note note) async {
    await NotesDAO.insertNote(note);
    await CloudStorage.insertNote(note);
  }

  static Future<void> updateNote(Note note) async {
    await NotesDAO.updateNote(note);
    await CloudStorage.insertNote(note);
  }

  static Future<void> deleteNote(List<Uuid> selectedNoteIds) async {
    for (Uuid id in selectedNoteIds) {
      await NotesDAO.deleteNote(id);
      await CloudStorage.deleteNote(id);
    }
  }
}
