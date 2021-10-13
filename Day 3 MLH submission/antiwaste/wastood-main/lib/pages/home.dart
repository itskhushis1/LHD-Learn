import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wastood/components/empty_placeholder.dart';
import 'package:wastood/components/filter_panel.dart';
import 'package:wastood/components/foodcard.dart';
import 'package:wastood/domain/wastood.dart';

class HomePage extends StatefulWidget {
  static const ROUTE_NAME = '/home';

  final List<Tab> tabs = [
    Tab(
      icon: Icon(Icons.arrow_circle_down, color: Colors.white),
      text: "WASTOODS",
    ),
  ];

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PanelController panelController = PanelController();
  final geo = Geoflutterfire();
  FilterOptions filterOptions = FilterOptions();
  bool locationUpdate = true;

  @override
  void initState() {
    super.initState();
    this._getLocation(context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        drawer: _buildDrawer(context),
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.filter_alt, color: Colors.white),
              onPressed: () {
                if (this.panelController.isPanelClosed) {
                  this.panelController.open();
                } else if (this.panelController.isPanelOpen) {
                  this.panelController.close();
                }
              },
            ),
            // IconButton(
            //   icon: Icon(Icons.search, color: Colors.white),
            //   onPressed: () {},
            // ),
            SizedBox(
              width: 8,
            ),
          ],
          title: Text("Feed"),
          bottom: TabBar(
            labelColor: Colors.white,
            tabs: this.widget.tabs,
          ),
        ),
        body: SlidingUpPanel(
          controller: this.panelController,
          minHeight: 88,
          renderPanelSheet: false,
          backdropEnabled: true,
          panel: FilterPanel(
            onFilterChanged: (FilterOptions filterOptions) {
              setState(() {
                this.panelController.close();
                this.filterOptions = filterOptions;
              });
            },
          ),
          body: TabBarView(children: [
            _createFirebaseBuilder(
              "giveAways",
            ),
          ]),
        ),
      ),
    );
  }

  Widget _createFirebaseBuilder(String path) {
    return this.filterOptions.getIncludedList().length == 0
        ? EmptyPlaceholder()
        : this.locationUpdate
            ? Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder(
                stream: geo
                    .collection(
                        collectionRef: FirebaseFirestore.instance
                            .collection(path)
                            .where("completed", isEqualTo: false)
                            .where("category",
                                whereIn: this.filterOptions.getIncludedList())
                            // .where("endsAt",
                            //     isGreaterThan: Timestamp.fromDate(DateTime.now()
                            //         .add(Duration(
                            //             days: this.filterOptions.daysToGo))))
                            .where("negotiatingWith", isNull: true)
                        // .orderBy("endsAt")
                        )
                    .within(
                        center: this.filterOptions.currentLocation,
                        radius: this.filterOptions.distanceKm.toDouble(),
                        field: "location",
                        strictMode: false),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    // return const Center(child: CircularProgressIndicator());
                    return EmptyPlaceholder();
                  }
                  List<DocumentSnapshot> unfilteredDocs = [];
                  (snapshot.data as List<DocumentSnapshot>)
                      .forEach((DocumentSnapshot document) {
                    unfilteredDocs.add(document);
                  });
                  List<DocumentSnapshot> docs = unfilteredDocs
                      .where((DocumentSnapshot document) => document["endsAt"]
                          .toDate()
                          .isAfter(DateTime.now().add(
                              Duration(days: this.filterOptions.daysToGo - 1))))
                      .toList();
                  docs.sort((DocumentSnapshot a, DocumentSnapshot b) =>
                      (a.data()["endsAt"] as Timestamp).millisecondsSinceEpoch -
                      (b.data()["endsAt"] as Timestamp).millisecondsSinceEpoch);
                  // return Container();
                  return docs.length == 0
                      ? EmptyPlaceholder()
                      : GridView.builder(
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot document = docs[index];
                            return FoodCard(
                              wastood:
                                  Wastood.fromMap(document.data(), document.id),
                              active: false,
                            );
                          },
                        );
                },
              );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        padding: EdgeInsets.zero, // Remove any padding from the ListView.
        children: <Widget>[
          DrawerHeader(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            // margin: null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wastood',
                  style: const TextStyle(fontSize: 32, color: Colors.white),
                ),
                SizedBox(
                  height: 32,
                ),
                UserAuth(),
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.history,
              color: Colors.black54,
            ),
            title: Text(
              "History",
              style: TextStyle(color: Colors.black54),
            ),
            onTap: () {
              Navigator.pushNamed(context, "/history");
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(
              Icons.fastfood,
              color: Colors.black54,
            ),
            title: Text(
              'Active Wastoods',
              style: TextStyle(color: Colors.black54),
            ),
            onTap: () {
              Navigator.pushNamed(context, "/active_wastoods");

              // Update the state of the app.
              // ...
            },
          ),
        ],
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
      this.filterOptions.currentLocation =
          GeoFirePoint(currentLocation.latitude, currentLocation.longitude);
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
}

class UserAuth extends StatefulWidget {
  const UserAuth({
    Key key,
  }) : super(key: key);

  @override
  _UserAuthState createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  Stream<User> authState;

  @override
  void initState() {
    super.initState();
    authState = FirebaseAuth.instance.authStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: authState,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(snapshot.data.photoURL),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                snapshot.data.displayName ?? "",
                style: const TextStyle(color: Colors.white),
              )
            ],
          );
        });
  }
}
