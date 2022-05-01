import 'package:uuid_type/uuid_type.dart';

class Note {
  Uuid id;
  String title;
  String color;
  String lastModified;
  String? content;

  Note({
    required this.id,
    required this.title,
    required this.color,
    required this.lastModified,
    this.content,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (content != null) {
      data['content'] = content;
    }
    data['title'] = title;
    data['color'] = color;
    data['lastModified'] = lastModified;
    return data;
  }

  @override
  toString() {
    return {
      'id': id,
      'title': title,
      'color': color,
      'lastModified': lastModified,
      'content': content
    }.toString();
  }
}
