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
      await connection.query("INSERT INTO notes(id, title, color, last_modified) VALUES ('${note.id}', '${note.title}', '${note.color}', '${note.lastModified}')");
      await connection.query("INSERT INTO user_notes(note_id, user_email, access_rights) VALUES ('${note.id}', '${FirebaseAuth.instance.currentUser!.email}', '${AccessType.owner.value}')");
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
      await connection.query("UPDATE notes SET title = '${note.title}', color = '${note.color}', last_modified = '${note.lastModified}' WHERE id = '${note.id}'");
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
      var queryResult = await connection.mappedResultsQuery("SELECT id, title, color, last_modified, access_rights FROM notes INNER JOIN user_notes ON id = note_id AND user_email = '${FirebaseAuth.instance.currentUser!.email}'");
      for (var queryEntry in queryResult) {
        UserNote userNote = UserNote(
            id: Uuid.parse(queryEntry['notes']!['id']),
            title: queryEntry['notes']!['title'],
            color: queryEntry['notes']!['color'],
            lastModified: queryEntry['notes']!['last_modified'],


            // TODO: Store and retrieve content from firebase cloud storage in service layer

            content: "Default Content",
            accessRights: AccessType.values.firstWhere((element) {
              return element.value == queryEntry['user_notes']!['access_rights'];
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
      await connection.query("DELETE FROM notes WHERE id = '$id'");
    } on SocketException catch (_, e) {
      debugPrint("Socket Exception!!!");
      debugPrint(e.toString());
    } on PostgreSQLException catch (_, e) {
      debugPrint("PostgreSQL Exception!!!");
      debugPrint(e.toString());
    }
  }
}
