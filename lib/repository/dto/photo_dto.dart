class PhotoDTO {
  static const columnPath = "path";
  static const columnLabel = "label";
  static List<String> get columns => [columnPath, columnLabel];

  final String path;
  final String label;

  const PhotoDTO({required this.path, required this.label});

  factory PhotoDTO.fromMap(Map<String, dynamic> map) {
    return PhotoDTO(
      path: map["path"],
      label: map["label"],
    );
  }

  Map<String, String> toMap() {
    return {
      "path": path,
      "label": label,
    };
  }
}
