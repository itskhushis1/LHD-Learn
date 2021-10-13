import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  static const ROUTE_NAME = '/onboarding';

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnboardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (_) => LoginPage(),
    //   ),
    // );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white, //Color(0xFF5DB075),
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Share Food",
          image: SafeArea(
            child: Align(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.asset("assets/illustrations/share.png")),
              alignment: Alignment.bottomCenter,
            ),
          ),
          body:
              "Instead of throwing away, share your unneeded still valuable food to help others.",
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Get Foods for Free",
          body:
              "Instead of buying all foods yourself, get some foods shared by others for free.",
          image: SafeArea(
              child: Align(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset("assets/illustrations/request.png")),
            alignment: Alignment.bottomCenter,
          )),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Help the Environment",
          body:
              "By wasting less you join efforts for better environment protection.",
          image: SafeArea(
              child: Align(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset("assets/illustrations/environment.png")),
            alignment: Alignment.bottomCenter,
          )),
          footer: RaisedButton(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Start Now'),
            ),
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              prefs.setBool('hideOnboarding', true);
              Navigator.of(context).pop();
            },
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text(
        'Skip',
        style: TextStyle(color: Color(0xFF5DB075)),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: Color(0xFF5DB075),
      ),
      done: const Text('Done',
          style:
              TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF5DB075))),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeColor: Color(0xFF5DB075),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
