import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_notes/models/access_type.dart';
import 'package:flutter_notes/models/user_note.dart';
import 'package:postgres/postgres.dart';
import 'package:uuid_type/uuid_type.dart';

import '../models/note.dart';
import 'database.dart';

class NotesDAO {
  static Future<Uuid> insertNote(Note note) async {
    PostgreSQLConnection connection = await Database.getConnection();
    try {
      await connection.query(
          "INSERT INTO notes(id, title, preview, color, last_modified) VALUES (@noteId:uuid, @noteTitle, @notePreview, @noteColor, @noteLastModified)",
          substitutionValues: {
            "noteId": note.id.toString(),
            "noteTitle": note.title,
            "notePreview": note.preview,
            "noteColor": note.color,
            "noteLastModified": note.lastModified
          });

      await connection.query(
          "INSERT INTO user_notes(note_id, user_email, access_rights) VALUES (@noteId:uuid, @userEmail, @accessRights)",
          substitutionValues: {
            "noteId": note.id.toString(),
            "userEmail": FirebaseAuth.instance.currentUser!.email,
            "accessRights": AccessType.owner.value
          });
    } on SocketException catch (_, e) {
      debugPrint("Socket Exception!!!");
      debugPrint(e.toString());
    } on PostgreSQLException catch (_, e) {
      debugPrint("PostgreSQL Exception!!!");
      debugPrint(e.toString());
    }
    return note.id;
  }

  static Future<void> updateNote(Note note) async {
    PostgreSQLConnection connection = await Database.getConnection();
    try {
      await connection.query(
          "UPDATE notes SET title = @noteTitle, preview = @notePreview, color = @noteColor, last_modified = @noteLastModified WHERE id = @noteId:uuid",
          substitutionValues: {
            "noteTitle": note.title,
            "notePreview": note.preview,
            "noteColor": note.color,
            "noteLastModified": note.lastModified,
            "noteId": note.id.toString(),
          });
    } on SocketException catch (_, e) {
      debugPrint("Socket Exception!!!");
      debugPrint(e.toString());
    } on PostgreSQLException catch (_, e) {
      debugPrint("PostgreSQL Exception!!!");
      debugPrint(e.toString());
    }
  }

  static Future<List<UserNote>> getAllNotes() async {
    PostgreSQLConnection connection = await Database.getConnection();
    List<UserNote> result = [];
    try {
      var queryResult = await connection.mappedResultsQuery(
          "SELECT id, title, preview, color, last_modified, access_rights FROM notes INNER JOIN user_notes ON id = note_id AND user_email = @userEmail",
          substitutionValues: {
            "userEmail": FirebaseAuth.instance.currentUser!.email,
          });
      for (var queryEntry in queryResult) {
        // print(queryEntry);
        UserNote userNote = UserNote(
            id: Uuid.parse(queryEntry['notes']!['id']),
            title: queryEntry['notes']!['title'],
            preview: queryEntry['notes']!['preview'],
            color: queryEntry['notes']!['color'],
            lastModified: queryEntry['notes']!['last_modified'],

            // TODO: Store and retrieve content from firebase cloud storage in service layer

            accessRights: AccessType.values.firstWhere((element) {
              return element.value ==
                  queryEntry['user_notes']!['access_rights'];
            }));
        result.add(userNote);
      }
    } on SocketException catch (_, e) {
      debugPrint("Socket Exception!!!");
      debugPrint(e.toString());
    } on PostgreSQLException catch (_, e) {
      debugPrint("PostgreSQL Exception!!!");
      debugPrint(e.toString());
    }
    return result;
  }

  static Future<void> deleteNote(Uuid id) async {
    PostgreSQLConnection connection = await Database.getConnection();
    try {
      await connection.query("DELETE FROM notes WHERE id = @noteId:uuid",
          substitutionValues: {"noteId": id.toString()});
    } on SocketException catch (_, e) {
      debugPrint("Socket Exception!!!");
      debugPrint(e.toString());
    } on PostgreSQLException catch (_, e) {
      debugPrint("PostgreSQL Exception!!!");
      debugPrint(e.toString());
    }
  }

  static Future<void> shareNote(Uuid id, String email) async {
    PostgreSQLConnection connection = await Database.getConnection();
    try {
      await connection.query(
          "INSERT INTO user_notes (note_id, user_email, access_rights) VALUES (@noteId:uuid, @userEmail, @accessRights)",
          substitutionValues: {
            "noteId": id.toString(),
            "userEmail": email,
            "accessRights": "editor",
          });
    } on SocketException catch (_, e) {
      debugPrint("Socket Exception!!!");
      debugPrint(e.toString());
    } on PostgreSQLException catch (_, e) {
      debugPrint("PostgreSQL Exception!!!");
      debugPrint(e.toString());
    }
  }

  static Future<List<String>> getSharedEmails(Uuid id) async {
    PostgreSQLConnection connection = await Database.getConnection();
    List<String> result = [];
    try {
      var queryResult = await connection.mappedResultsQuery(
          "SELECT user_email FROM user_notes WHERE note_id=@noteId:uuid",
          substitutionValues: {
            "noteId": id.toString(),
          });
      for (var queryEntry in queryResult) {
        print(queryEntry);
        result.add(queryEntry['user_notes']!['user_email']);
      }
    } on SocketException catch (_, e) {
      debugPrint("Socket Exception!!!");
      debugPrint(e.toString());
    } on PostgreSQLException catch (_, e) {
      debugPrint("PostgreSQL Exception!!!");
      debugPrint(e.toString());
    }
    return result;
  }

  static Future<void> revokeNoteAccess(Uuid id, String email) async {
    PostgreSQLConnection connection = await Database.getConnection();
    try {
      await connection.query(
          "DELETE from user_notes WHERE user_email = @userEmail AND note_id = @noteId:uuid;",
          substitutionValues: {
            "noteId": id.toString(),
            "userEmail": email,
          });
    } on SocketException catch (_, e) {
      debugPrint("Socket Exception!!!");
      debugPrint(e.toString());
    } on PostgreSQLException catch (_, e) {
      debugPrint("PostgreSQL Exception!!!");
      debugPrint(e.toString());
    }
  }
}
