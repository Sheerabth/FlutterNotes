import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/note.dart';
import 'package:uuid_type/uuid_type.dart';

class CloudStorage {
  static final storage = FirebaseStorage.instance;
  static final storageRef = FirebaseStorage.instance.ref().child("notes");

  static Future<File> getTemporaryFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  static Future<void> insertNote(Note note) async {
    File tempFile = await getTemporaryFile(note.id.toString());
    if (note.content == null) {
      return;
    }
    tempFile.writeAsString(note.content!);
    // TODO: if possible, show progress indicators
    var fileRef = storageRef.child(note.id.toString());
    await fileRef.putFile(tempFile);
    // await tempFile.delete();
  }

  static Future<String> getNote(Uuid id) async {
    File tempFile = await getTemporaryFile(id.toString());
    var fileRef = storageRef.child(id.toString());
    await fileRef.writeToFile(tempFile);
    String noteContents = await tempFile.readAsString();
    // await tempFile.delete();
    return noteContents;
  }

  static Future<void> deleteNote(Uuid id) async {
    var fileRef = storageRef.child(id.toString());
    await fileRef.delete();
  }
}
