enum AccessType {
  owner,
  editor,
  viewer
}

extension AccessTypeExtension on AccessType {
  String get value {
    switch (this) {
      case AccessType.owner:
        return "owner";
      case AccessType.editor:
        return "editor";
      case AccessType.viewer:
        return "viewer";
      default:
        return "";
    }
  }

  AccessType getEnum (String accessType) {
    switch (accessType) {
      case "editor":
        return AccessType.editor;
      case "viewer":
        return AccessType.viewer;
      default:
        return AccessType.owner;
    }
  }
}
