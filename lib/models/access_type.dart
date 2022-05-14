enum AccessType {
  owner,
  editor,
  viewer
}

extension AccessTypeExtension on AccessType {
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
