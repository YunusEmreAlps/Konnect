import 'package:firebase_core/firebase_core.dart';
import 'package:konnect/services/audio_provider.dart';
import 'package:konnect/components/auth.dart';
import 'package:konnect/screens/chat_home.dart';
import 'package:konnect/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Montserrat-SemiBold',
          textTheme: TextTheme(
            bodyText2: TextStyle(fontSize: 15),
          ),
        ),
        home: (userMain != null) ? ChatHome() : LoginNew());
  }
}
