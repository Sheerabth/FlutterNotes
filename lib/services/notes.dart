import 'package:flutter/cupertino.dart';

import '../dao/notes.dart';
import '../models/note.dart';
import 'package:flutter_notes/theme/note_theme.dart';

enum SortBy {
  modifiedAt,
  title,
}

enum SortOrder {
  ascending,
  descending,
}

class NotesService {
  static Future<List<Map<String, dynamic>>> getNotes(SortBy sortBy, SortOrder sortOrder) async {
    NotesDatabase notesDb = NotesDatabase();
    await notesDb.initDatabase();
    List<Map> notesList = await notesDb.getAllNotes();
    await notesDb.closeDatabase();
    List<Map<String, dynamic>> notesData = List<Map<String, dynamic>>.from(notesList);
    if (sortBy == SortBy.modifiedAt) {
      if (sortOrder == SortOrder.descending) {
        notesData.sort((a, b) => (dateFormat.parse(b[sortBy.name])).compareTo(dateFormat.parse(a[sortBy.name])));
      } else {
        notesData.sort((a, b) => (dateFormat.parse(a[sortBy.name]).compareTo(dateFormat.parse(b[sortBy.name]))));
      }
    }
    else
    if (sortOrder == SortOrder.descending) {
      notesData.sort((a, b) => (b[sortBy.name]).compareTo(a[sortBy.name]));
    } else {
      notesData.sort((a, b) => (a[sortBy.name]).compareTo(b[sortBy.name]));
    }
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