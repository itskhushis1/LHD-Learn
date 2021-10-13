import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wastood/pages/new_wastood.dart';

class FilterPanel extends StatefulWidget {
  final ValueChanged<FilterOptions> onFilterChanged;

  FilterPanel({this.onFilterChanged});

  @override
  State createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  FilterOptions filterOptions = FilterOptions();
  bool locationUpdate = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: FloatingActionButton(
                child: Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, NewWastoodPage.ROUTE_NAME);
                },
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            color: Colors.white,
            border: Border.all(color: Colors.grey[400], width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 80,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Container(
                              width: 32,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[300],
                              ),
                            )),
                        Text('Filter Items',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20)),
                      ],
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 330),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Included Categories',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SwitchListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.only(top: 0),
                          title: Text(
                            'Vegetables',
                            style: TextStyle(fontSize: 16),
                          ),
                          value: this.filterOptions.includeVegetables,
                          onChanged: (bool value) {
                            setState(() {
                              this.filterOptions.includeVegetables = value;
                            });
                          }),
                      SwitchListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.only(top: 0),
                          title: Text(
                            'Meat',
                            style: TextStyle(fontSize: 16),
                          ),
                          value: this.filterOptions.includeMeat,
                          onChanged: (bool value) {
                            setState(() {
                              this.filterOptions.includeMeat = value;
                            });
                          }),
                      SwitchListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.only(top: 0),
                          title: Text(
                            'Fruits',
                            style: TextStyle(fontSize: 16),
                          ),
                          value: this.filterOptions.includeFruits,
                          onChanged: (bool value) {
                            setState(() {
                              this.filterOptions.includeFruits = value;
                            });
                          }),
                      SwitchListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.only(top: 0),
                          title: Text(
                            'Milk Products',
                            style: TextStyle(fontSize: 16),
                          ),
                          value: this.filterOptions.includeMilkProducts,
                          onChanged: (bool value) {
                            setState(() {
                              this.filterOptions.includeMilkProducts = value;
                            });
                          }),
                      SwitchListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.only(top: 0),
                          title: Text(
                            'Bakery Products',
                            style: TextStyle(fontSize: 16),
                          ),
                          value: this.filterOptions.includeBakeryProducts,
                          onChanged: (bool value) {
                            setState(() {
                              this.filterOptions.includeBakeryProducts = value;
                            });
                          }),
                      SwitchListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.only(top: 0),
                          title: Text(
                            'Exotic',
                            style: TextStyle(fontSize: 16),
                          ),
                          value: this.filterOptions.includeExotic,
                          onChanged: (bool value) {
                            setState(() {
                              this.filterOptions.includeExotic = value;
                            });
                          }),
                      SwitchListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.only(top: 0),
                          title: Text(
                            'Other',
                            style: TextStyle(fontSize: 16),
                          ),
                          value: this.filterOptions.includeOther,
                          onChanged: (bool value) {
                            setState(() {
                              this.filterOptions.includeOther = value;
                            });
                          }),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'At Least ${this.filterOptions.daysToGo} days To Go',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackShape: CustomTrackShape(),
                          ),
                          child: Slider(
                            activeColor: Theme.of(context).primaryColor,
                            inactiveColor: Colors.grey[300],
                            min: 0,
                            max: 15,
                            value: this.filterOptions.daysToGo.toDouble(),
                            onChanged: (double value) {
                              setState(() {
                                this.filterOptions.daysToGo = value.toInt();
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Maximal  ${this.filterOptions.distanceKm} km Distance',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackShape: CustomTrackShape(),
                          ),
                          child: Slider(
                            activeColor: Theme.of(context).primaryColor,
                            inactiveColor: Colors.grey[300],
                            min: 0,
                            max: 20,
                            value: this.filterOptions.distanceKm.toDouble(),
                            onChanged: (double value) {
                              setState(() {
                                this.filterOptions.distanceKm = value.toInt();
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24, bottom: 16),
                        child: this._buildFilterButton(context),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return AbsorbPointer(
      absorbing: this.locationUpdate,
      child: RaisedButton(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              this.locationUpdate
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    )
                  : Container(),
              Text('Filter')
            ],
          ),
        ),
        onPressed: () async {
          await this._getLocation(context);
          if (this.widget.onFilterChanged != null) {
            this.widget.onFilterChanged(this.filterOptions);
          }
        },
        color: Theme.of(context).accentColor,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
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

class FilterOptions {
  bool includeVegetables = true;
  bool includeMeat = true;
  bool includeFruits = true;
  bool includeMilkProducts = true;
  bool includeBakeryProducts = true;
  bool includeExotic = true;
  bool includeOther = true;
  int daysToGo = 1;
  int distanceKm = 15;
  GeoFirePoint currentLocation;

  List<String> getIncludedList() {
    final List<String> included = [
      if (includeVegetables) "vegetables",
      if (includeMeat) "meat",
      if (includeFruits) "fruits",
      if (includeMilkProducts) "milk-products",
      if (includeBakeryProducts) "bakery-products",
      if (includeExotic) "exotic",
      if (includeOther) "other"
    ];
    return included;
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
