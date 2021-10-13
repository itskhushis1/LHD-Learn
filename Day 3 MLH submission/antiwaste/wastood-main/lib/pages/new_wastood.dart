import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:wastood/domain/author.dart';
import 'package:wastood/pages/take_picture.dart';

class NewWastoodPage extends StatelessWidget {
  static const ROUTE_NAME = "/newwastood";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Wastood"),
        ),
        body: _NewWastoodPageInner());
  }
}

class _NewWastoodPageInner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewWastoodPageStateInner();
}

class _NewWastoodPageStateInner extends State<_NewWastoodPageInner> {
  static const Map<String, String> CATEGORIES = {
    'vegetables': 'Vegetables',
    'meat': 'Meat',
    'fruits': 'Fruits',
    'milk-products': 'Milk Products',
    'bakery-products': 'Bakery Products',
    'exotic': 'Exotic',
    'other': 'Other'
  };

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<WastoodImage> images = [];

  String barcode;
  bool barcodeLookup = false;
  bool barcodeLookupSuccessful = false;
  TextEditingController titleController = TextEditingController();

  DateTime goodUntil;
  TextEditingController goodUntilController = TextEditingController();

  String category;

  Position location;
  TextEditingController locationNoteController = TextEditingController();
  bool locationUpdate = false; // get GPS coordinates

  TextEditingController descriptionController = TextEditingController();

  bool uploadingData = false;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: this.uploadingData,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: this.images.length == 0
                    ? _buildAddImageArea(context)
                    : _buildImagesArea(context)),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextField(
                controller: this.titleController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Item Name',
                  suffixIcon: MaterialButton(
                    child: this.barcodeLookup
                        ? SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(
                                  'Scan Barcode',
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                              ),
                              this.barcode != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(bottom: 2),
                                      child: Icon(
                                          CupertinoIcons.check_mark_circled,
                                          size: 16,
                                          color: Theme.of(context).accentColor),
                                    )
                                  : Container()
                            ],
                          ),
                    onPressed: this.barcodeLookup
                        ? null
                        : () async {
                            if (this.barcode == null) {
                              String barcodeScanRes =
                                  await FlutterBarcodeScanner.scanBarcode(
                                      "#ff6666",
                                      "Cancel",
                                      false,
                                      ScanMode.DEFAULT);
                              if (barcodeScanRes != "-1") {
                                setState(() {
                                  this.barcode = barcodeScanRes;
                                });
                                this._barcodeLookup();
                              }
                            } else {
                              setState(() {
                                this.barcode = null;
                                this.barcodeLookupSuccessful = false;
                              });
                            }
                          },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextField(
                focusNode: AlwaysDisabledFocusNode(),
                controller: this.goodUntilController,
                decoration: InputDecoration(
                  hintText: 'Good Until',
                ),
                onTap: () async {
                  DateTime now = DateTime.now();
                  DateTime newSelectedDate = await showDatePicker(
                      context: context,
                      initialDate:
                          this.goodUntil != null ? this.goodUntil : now,
                      firstDate: DateTime(now.year - 1, now.month, now.day),
                      lastDate: DateTime(now.year + 5, now.month, now.day),
                      builder: (BuildContext context, Widget child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            accentColor: Theme.of(context).accentColor,
                            colorScheme: ColorScheme.light(
                              primary: Theme.of(context).primaryColor,
                              onPrimary: Colors.white,
                              surface: Theme.of(context).accentColor,
                              onSurface: Colors.black,
                            ),
                          ),
                          child: child,
                        );
                      });

                  if (newSelectedDate != null) {
                    this.goodUntilController.text =
                        DateFormat('yyyy-MM-dd').format(newSelectedDate);
                    setState(() {
                      this.goodUntil = newSelectedDate;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextField(
                controller: this.locationNoteController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Location Note',
                  suffixIcon: MaterialButton(
                    child: this.locationUpdate
                        ? SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(
                                  'Use Device Location',
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                              ),
                              this.location != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(bottom: 2),
                                      child: Icon(
                                          CupertinoIcons.check_mark_circled,
                                          size: 16,
                                          color: Theme.of(context).accentColor),
                                    )
                                  : Container()
                            ],
                          ),
                    onPressed: this.locationUpdate
                        ? null
                        : () async {
                            if (this.location == null) {
                              this._getLocation(context);
                            } else {
                              setState(() {
                                this.location = null;
                              });
                            }
                          },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Theme(
                data: Theme.of(context).copyWith(),
                child: DropdownButtonFormField(
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(Icons.arrow_drop_down),
                  ),
                  hint: Text('Category'),
                  value: this.category,
                  isExpanded: true,
                  onChanged: (String newValue) {
                    setState(() {
                      this.category = newValue;
                    });
                  },
                  items: CATEGORIES.keys.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(CATEGORIES[category]),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextField(
                  controller: this.descriptionController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Description & Nutrition',
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 16),
              child: RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      this.uploadingData
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                            )
                          : Container(),
                      Text('Create Wastood')
                    ],
                  ),
                ),
                onPressed: () async {
                  this._wastood(context);
                },
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildAddImageArea(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 250),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF6F6F6),
          border: Border.all(width: 1, color: Color(0xFFE8E8E8)),
          borderRadius: const BorderRadius.all(const Radius.circular(8)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                      padding: const EdgeInsets.all(32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(CupertinoIcons.photo_camera,
                          size: 64, color: Color(0xFFBDBDBD)),
                      onPressed: () async {
                        await this._addImageFromCamera(context);
                      }),
                  SizedBox(
                    width: 1,
                    height: 96,
                    child: const DecoratedBox(
                      decoration: const BoxDecoration(color: Color(0xFFE8E8E8)),
                    ),
                  ),
                  MaterialButton(
                      padding: const EdgeInsets.all(32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(CupertinoIcons.photo_on_rectangle,
                          size: 64, color: Color(0xFFBDBDBD)),
                      onPressed: () async {
                        await this._addImageFromGallery(context);
                      }),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Take a picture or add from gallery to help requesters to get a better idea of what you give away.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFFBDBDBD)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildImagesArea(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 180),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF6F6F6),
          border: Border.all(width: 1, color: Color(0xFFE8E8E8)),
          borderRadius: const BorderRadius.all(const Radius.circular(8)),
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(CupertinoIcons.photo_camera,
                          size: 32, color: Color(0xFFBDBDBD)),
                      onPressed: () async {
                        await this._addImageFromCamera(context);
                      }),
                  SizedBox(
                    width: 96,
                    height: 1,
                    child: const DecoratedBox(
                      decoration: const BoxDecoration(color: Color(0xFFE8E8E8)),
                    ),
                  ),
                  MaterialButton(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(CupertinoIcons.photo_on_rectangle,
                          size: 32, color: Color(0xFFBDBDBD)),
                      onPressed: () async {
                        await this._addImageFromGallery(context);
                      }),
                ],
              ),
            ),
            ...this.images.map((image) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.file(
                      image.file,
                      fit: BoxFit.fitHeight,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8, top: 4),
                      child: InkWell(
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: Icon(
                              CupertinoIcons.clear,
                              size: 16,
                            ),
                          ),
                        ),
                        onTap: () async {
                          if (image.fromCamera) {
                            try {
                              image.file.delete();
                            } catch (e) {}
                          }
                          setState(() {
                            this.images.remove(image);
                          });
                        },
                      ),
                    )
                  ],
                ),
              );
            }).toList()
          ],
        ),
      ),
    );
  }

  _getLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      this._showErrorSnackbarLocationAccess(context);
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    this.setState(() {
      this.locationUpdate = true;
    });
    final currentLocation = await Geolocator.getCurrentPosition();
    this.setState(() {
      this.location = currentLocation;
      this.locationUpdate = false;
    });
    return null;
  }

  _showErrorSnackbarLocationAccess(BuildContext context) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Text('Please allow location access'),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: RaisedButton(
              child: Text('Settings'),
              onPressed: () {
                Geolocator.openAppSettings();
              },
              color: Color(0xFF5DB075),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).errorColor,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _addImageFromCamera(BuildContext context) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TakePicturePage()),
    );
    if (result != null) {
      setState(() {
        this.images.add(WastoodImage(File(result), true));
      });
    }
  }

  _addImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      setState(() {
        this.images.add(WastoodImage(image, false));
      });
    }
  }

  _barcodeLookup() async {
    setState(() {
      this.barcodeLookup = true;
    });
    try {
      final response = await this
          .firestore
          .collection("barcodes")
          .where("barcode", isEqualTo: this.barcode)
          .limit(1)
          .get();
      if (response.size == 1) {
        final doc = response.docs.first;
        setState(() {
          this.titleController.text = doc['title'];
          this.category = doc['category'];
          this.descriptionController.text = doc['description'];
          this.barcodeLookupSuccessful = true;
        });
      } else {
        setState(() {
          this.barcodeLookupSuccessful = false;
        });
      }
    } catch (e) {
      setState(() {
        this.barcodeLookupSuccessful = false;
      });
    } finally {
      this.setState(() {
        this.barcodeLookup = false;
      });
    }
  }

  _wastood(BuildContext context) async {
    setState(() {
      this.uploadingData = true;
    });

    // await Future.delayed(const Duration(seconds: 5));

    // try to upload barcode prefill data
    if (!this.barcodeLookupSuccessful) {
      try {
        await this.firestore.collection('barcodes').add({
          'barcode': this.barcode,
          'category': this.category,
          'description': this.descriptionController.text,
          'title': this.titleController.text,
        });
      } catch (e) {}
    }

    try {
      // try to upload images to firebase cloud storage; get references
      final List<String> downloadReferences = await Future.wait(
          this.images.map((image) => this._uploadImageFile(image.file)));

      // try to upload actual giveaway
      await this.firestore.collection('giveAways').add({
        'author':
            Author.fromFirebaseAuthCurrentUser(this.auth.currentUser).toMap(),
        'images': downloadReferences,
        'title': this.titleController.text,
        'endsAt': this.goodUntil,
        'locationNote': this.locationNoteController.text,
        'location':
            GeoFirePoint(this.location.latitude, this.location.longitude).data,
        'category': this.category,
        'description': this.descriptionController.text,
        'completed': false,
        'negotiatingWith': null,
      });
      Navigator.of(context).pop();
    } catch (e) {}

    setState(() {
      this.uploadingData = false;
    });
  }

  Future<String> _uploadImageFile(File image) async {
    try {
      final String filename = 'giveawayPics/${Uuid().v1()}';
      await FirebaseStorage.instance.ref(filename).putFile(image);
      final String url =
          await FirebaseStorage.instance.ref(filename).getDownloadURL();
      return url;
    } catch (e) {}
    return null;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    this.titleController.dispose();
    this.goodUntilController.dispose();
    this.locationNoteController.dispose();
    this.descriptionController.dispose();
    super.dispose();
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class WastoodImage {
  File file;
  bool fromCamera;

  WastoodImage(this.file, this.fromCamera); // otherwise from gallery
}
