// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:konnect/core/constants/core.dart';
import 'package:konnect/core/navigation/navigation_constants.dart';
import 'package:konnect/core/service/audio_provider.dart';
import 'package:konnect/ui/components/auth.dart';
import 'package:konnect/ui/view/authenticate/splash/splashscreen.dart';
import 'core/init/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await getCurrentUser();
  runApp(ChangeNotifierProvider(
      create: (context) => AudioProvider(), child: Konnect()));
}

class Konnect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    // Portrait Mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: AppStrings.APP_NAME,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: AppStrings.FONT_FAMILY,
        textTheme: TextTheme(
          bodyText2: TextStyle(fontSize: 15),
        ),
      ),
      supportedLocales: [Locale("en"), Locale("tr")],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: NavigationConstants.SPLASH,
      routes: {
        NavigationConstants.SPLASH: (context) => SplashScreen(),
      },
      // home: (userMain != null) ? ChatHome() : LoginNew(),
    );
  }
}
