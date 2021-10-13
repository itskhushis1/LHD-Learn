import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:wastood/domain/author.dart';
import 'package:wastood/domain/wastood.dart';
import 'package:wastood/pages/chat.dart';
import 'package:intl/intl.dart';

extension DurationFormatter on Duration {
  /// Returns a day, hour, minute, second string representation of this `Duration`.
  ///
  ///
  /// Returns a string with days, hours, minutes, and seconds in the
  /// following format: `dd:HH:MM:SS`. For example,
  ///
  ///   var d = new Duration(days:19, hours:22, minutes:33);
  ///    d.dayHourMinuteSecondFormatted();  // "19:22:33:00"
  String dayHourMinuteSecondFormatted() {
    return "${this.inDays} days, ${this.inHours.remainder(24)} hours";
  }
}

class DetailsPage extends StatelessWidget {
  static const ROUTE_NAME = "/details";
  void _showErrorSnackbarWastoodAuthor(BuildContext context) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Text("Sorry, but you can't accept a Wastood you created."),
        ],
      ),
      backgroundColor: Theme.of(context).errorColor,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final Wastood wastood = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      floatingActionButton: StreamBuilder<Object>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return Container();
            }
            final User user = snapshot.data;
            return FloatingActionButton(
              child: Icon(Icons.shopping_cart_outlined, color: Colors.white,),
              onPressed: wastood.author.uid == user.uid
                  ? () {
                      _showErrorSnackbarWastoodAuthor(context);
                    }
                  : () async {
                      await FirebaseFirestore.instance
                          .collection("giveAways")
                          .doc(wastood.id)
                          .update({
                        "negotiatingWith": {
                          "name": user.displayName,
                          "profilePicURL": user.photoURL,
                          "uid": user.uid
                        }
                      });
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatWidget(
                            wastood: wastood,
                          ),
                        ),
                      );
                    },
            );
          }),
      appBar: AppBar(
        title: Text("Wastood Details"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                wastood.imageUrls != null && wastood.imageUrls.length >= 1
                    ? _newImageGallery(
                        context, wastood) //_buildImagesArea(context, wastood)
                    : _buildSingleImageArea(context, wastood),
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      wastood.title ?? "",
                      style: TextStyle(fontSize: 20),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'by ${wastood.author.name}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Description',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      wastood.description ?? "",
                      style: TextStyle(fontSize: 16),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Good until ${DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(wastood.endsAt.millisecondsSinceEpoch))}',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Location Note',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      wastood.locationNote ?? "",
                      style: TextStyle(fontSize: 16),
                    )),
                wastood.location != null ? Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('Show on Map'),
                      ),
                      onPressed: () async {
                            final availableMaps = await MapLauncher.installedMaps;
                            await availableMaps.first.showMarker(
                              coords: Coords(wastood.location.latitude, wastood.location.longitude),
                              title: wastood.title,
                            );
                      },
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                ): Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildSingleImageArea(BuildContext context, Wastood wastood) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 250),
      child: wastood.imageUrls == null || wastood.imageUrls.length == 0
          ? Container(
              color: Colors.grey[200],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.network(
                    wastood.imageUrls[0],
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
    );
  }

  _newImageGallery(BuildContext context, Wastood wastood) {
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 300),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(wastood.imageUrls[index]),
                initialScale: PhotoViewComputedScale.contained * 1,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: wastood.imageUrls[index]),
              );
            },
            itemCount: wastood.imageUrls.length,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                ),
              ),
            ),
            backgroundDecoration: BoxDecoration(
              color: Colors.grey[200],
            ),
          ),
        ));
  }
}

class DetailsArguments {
  const DetailsArguments({
    Key key,
    @required this.title,
    @required this.author,
    @required this.details,
    @required this.image,
    @required this.endsAt,
  });

  final String title;
  final Map<String, dynamic> details;
  final Author author;
  final Image image;
  final Timestamp endsAt;
}
