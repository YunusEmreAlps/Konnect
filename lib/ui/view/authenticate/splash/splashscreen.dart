// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:animated_text_kit/animated_text_kit.dart';

// Project imports:
import 'package:konnect/core/constants/core.dart';
import 'package:konnect/core/init/app_localizations.dart';
import 'package:konnect/core/init/size_config.dart';
import 'package:konnect/ui/components/auth.dart';
import 'package:konnect/ui/view/authenticate/login/login.dart';
import 'package:konnect/ui/view/home/chat_home.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimeout() {
    Future.delayed(Duration(seconds: 4), () {
      navigateUser();
    });
  }

  void navigateUser() async{
    if (userMain != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatHome()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginNew()));
    }
  }

  @override
  void initState() {
    super.initState();
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    AppLocalizations.of(context);
    return Scaffold(
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
              image: AssetImage(AppImages.pngSplashBackground),
              fit: BoxFit.cover),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // Logo
            Center(
              child: Image.asset(
                AppImages.pngDarkLogo,
                height: 250, 
              ),
            ),
            // Animated Text
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RotateAnimatedTextKit(
                      alignment: Alignment.center,
                      onTap: () {
                        print("Tap Event");
                      },
                      text: [
                        AppStrings.SPLASH_TEXT,
                        AppStrings.SPLASH_TEXT,
                        AppStrings.SPLASH_TEXT
                      ],
                      textStyle: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                          fontFamily: AppStrings.FONT_FAMILY,
                          color: Colors.white,
                        ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
