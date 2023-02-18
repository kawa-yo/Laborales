class PhotoDTO {
  static const columnRelativePath = "relative_path";
  static const columnLabel = "label";
  static const List<String> columns = [columnRelativePath, columnLabel];

  final String relativePath;
  final String label;

  const PhotoDTO({required this.relativePath, required this.label});

  factory PhotoDTO.fromMap(Map<String, dynamic> map) {
    return PhotoDTO(
      relativePath: map["relative_path"],
      label: map["label"],
    );
  }

  Map<String, String> toMap() {
    return {
      "relative_path": relativePath,
      "label": label,
    };
  }
}
