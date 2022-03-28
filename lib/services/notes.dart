import '../dao/notes.dart';
import '../models/note.dart';

class NotesService {
  static Future<List<Map<String, dynamic>>> getNotes() async {
    NotesDatabase notesDb = NotesDatabase();
    await notesDb.initDatabase();
    List<Map> notesList = await notesDb.getAllNotes();
    await notesDb.closeDatabase();
    List<Map<String, dynamic>> notesData = List<Map<String, dynamic>>.from(notesList);
    notesData.sort((a, b) => (a['title']).compareTo(b['title']));
    return notesData;
  }

  static Future<void> insertNote(Note note) async {
    NotesDatabase notesDb = NotesDatabase();
    await notesDb.initDatabase();
    int result = await notesDb.insertNote(note);
    await notesDb.closeDatabase();
  }

  static Future<void> updateNote(Note note) async {
    NotesDatabase notesDb = NotesDatabase();
    await notesDb.initDatabase();
    int result = await notesDb.updateNote(note);
    await notesDb.closeDatabase();
  }

  static Future<void> deleteNote(List<int> selectedNoteIds) async {
    NotesDatabase notesDb = NotesDatabase();
    await notesDb.initDatabase();
    for (int id in selectedNoteIds) {
      int result = await notesDb.deleteNode(id);
    }
    await notesDb.closeDatabase();
  }
}