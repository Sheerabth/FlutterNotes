import 'package:uuid_type/uuid_type.dart';

class Note {
  Uuid id;
  String title;
  String color;
  String lastModified;
  String? content;
  String? preview;

  Note({
    required this.id,
    required this.title,
    required this.color,
    required this.lastModified,
    this.content,
    this.preview,
  }) {
    if (preview == null) {
      if (content != null) {
        String contentFirstLine = content!.split('\n')[0];
        if (contentFirstLine.length < 29) {
          preview = contentFirstLine;
        } else {
          preview = contentFirstLine.substring(0, 29) + '...';
        }
      }
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (content != null) {
      data['content'] = content;
    }
    data['title'] = title;
    data['preview'] = preview;
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
