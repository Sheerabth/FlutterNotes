enum AccessType {
  owner,
  editor
}

extension AccessTypeExtension on AccessType {
  String get value {
    switch (this) {
      case AccessType.owner:
        return "owner";
      case AccessType.editor:
        return "editor";
      default:
        return "";
    }
  }

  AccessType getEnum (String accessType) {
    switch (accessType) {
      case "editor":
        return AccessType.editor;
      default:
        return AccessType.owner;
    }
  }
}
