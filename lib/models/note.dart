import 'package:flutter_notes/theme/note_theme.dart';

class Note {
  int? id;
  String title;
  String content;
  String noteColor;
  String modifiedAt;

  Note({
    this.id,
    this.title = "Note",
    this.content = "Text",
    this.noteColor = "purple",
  }) : modifiedAt = dateFormat.format(DateTime.now());

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = <String, dynamic>{};
    if (id == -1) {
      data['id'] = id;
    }
    data['title'] = title;
    data['content'] = content;
    data['noteColor'] = noteColor;
    data['modifiedAt'] = modifiedAt;
    return data;
  }

  @override
  toString() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'noteColor': noteColor,
      'modifiedAt': modifiedAt
    }.toString();
  }
}
