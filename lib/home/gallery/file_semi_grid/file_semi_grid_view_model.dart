import 'package:laborales/home/gallery/photo/photo_view_model.dart';

Map<String, List<Photo>> photoList(List<Photo> photos) {
  var listed = <String, List<Photo>>{};

  for (var photo in photos) {
    String key = photo.src.parent.path;
    listed[key] = (listed[key] ?? [])..add(photo);
  }
  return listed;
}
