import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart' show required;

class Author {
  final String name;
  final String profilePicURL;
  final String uid;

  const Author(
      {@required this.name, @required this.uid, @required this.profilePicURL});

  Map<String, String> toMap() {
    return {
      'name': this.name,
      'profilePicURL': this.profilePicURL,
      'uid': this.uid,
    };
  }

  Author.fromMap(Map<String, String> info)
      : this.name = info['name'],
        this.profilePicURL = info['profilePicURL'],
        this.uid = info['uid'];

  Author.fromFirebaseAuthCurrentUser(User user)
      : this.name = user.displayName,
        this.profilePicURL = user.photoURL,
        this.uid = user.uid;
}