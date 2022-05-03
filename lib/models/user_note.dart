import 'package:flutter_notes/models/note.dart';
import 'package:uuid_type/uuid_type.dart';

import 'access_type.dart';

class UserNote extends Note {
  AccessType accessRights;

  UserNote({
    required Uuid id,
    required String title,
    required String color,
    required String lastModified,
    required this.accessRights,
    String? content,
    String? preview,
  }) : super(
            id: id,
            title: title,
            preview: preview,
            color: color,
            lastModified: lastModified,
            content: content);

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['accessRights'] = accessRights;
    return data;
  }

  @override
  toString() {
    return {
      'id': id,
      'title': title,
      'color': color,
      'lastModified': lastModified,
      'accessRights': accessRights.value,
      'content': content
    }.toString();
  }
}
