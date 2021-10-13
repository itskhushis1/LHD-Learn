import 'package:flutter/material.dart';
import 'package:wastood/pages/active_wastoods.dart';
import 'package:wastood/pages/details.dart';
import 'package:wastood/pages/history.dart';
import 'package:wastood/pages/home.dart';
import 'package:wastood/pages/login.dart';
import 'package:wastood/pages/new_wastood.dart';
import 'package:wastood/pages/onboarding.dart';
import 'package:wastood/wastood_theme.dart';

class WastoodApp extends StatelessWidget {
  final bool showOnboarding;
  final bool showLogin;

  WastoodApp({Key key, this.showOnboarding, this.showLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        OnboardingPage.ROUTE_NAME: (context) => OnboardingPage(),
        LoginPage.ROUTE_NAME: (context) => LoginPage(),
        HomePage.ROUTE_NAME: (context) => HomePage(),
        DetailsPage.ROUTE_NAME: (context) => DetailsPage(),
        HistoryPage.ROUTE_NAME: (context) => HistoryPage(),
        NewWastoodPage.ROUTE_NAME: (context) => NewWastoodPage(),
        ActiveWastoodsPage.ROUTE_NAME: (context) => ActiveWastoodsPage(),
      },
      debugShowCheckedModeBanner: false,
      theme: WastoodTheme().themeData,
      home: _WrappedWidget(
        showOnboarding: this.showOnboarding,
        showLogin: this.showLogin,
      ),
    );
  }
}

class _WrappedWidget extends StatefulWidget {
  final bool showOnboarding;
  final bool showLogin;

  @override
  State createState() => _WrappedWidgetState();

  _WrappedWidget({@required this.showOnboarding, @required this.showLogin});
}

class _WrappedWidgetState extends State<_WrappedWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init(context);
    });
  }

  _init(BuildContext context) async {
    if (this.widget.showOnboarding) {
      await Navigator.pushNamed(context, OnboardingPage.ROUTE_NAME);
      if (this.widget.showLogin) {
        await Navigator.pushNamed(context, LoginPage.ROUTE_NAME);
      }
    }
    Navigator.pushNamed(context, HomePage.ROUTE_NAME);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
    );
  }
}
