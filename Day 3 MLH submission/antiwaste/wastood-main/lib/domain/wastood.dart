import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:meta/meta.dart';
import 'package:wastood/domain/author.dart';

class Wastood {
  final String title;

  // final Map<String, dynamic> details;
  final Author author;
  final List<dynamic> imageUrls;
  final bool completed;
  final Timestamp endsAt;
  final Author negotiatingWith;
  final String id;
  final String description;
  final GeoFirePoint location;
  final String locationNote;

  const Wastood({
    @required this.title,
    @required this.author,
    // @required this.details,
    @required this.imageUrls,
    @required this.completed,
    @required this.endsAt,
    @required this.negotiatingWith,
    @required this.id,
    @required this.description,
    @required this.location,
    @required this.locationNote,
  });

  Wastood.fromMap(Map<String, dynamic> map, String id)
      : title = map["title"],
        author = Author.fromMap(Map<String, String>.from(map["author"])),
        negotiatingWith = map["negotiatingWith"] == null
            ? null
            : Author.fromMap(Map<String, String>.from(map["negotiatingWith"])),
        // details = map["details"] == null ? Map<String,dynamic>() : map["details"],
        imageUrls = map["images"] ?? [],
        completed = map["completed"],
        endsAt = map["endsAt"],
        description = map["description"],
        id = id,
        location = map["location"] == null || map["location"]["geopoint"] == null
            ? null
            : GeoFirePoint((map["location"]["geopoint"] as GeoPoint).latitude,
                (map["location"]["geopoint"] as GeoPoint).longitude),
        locationNote = map["locationNote"];
}