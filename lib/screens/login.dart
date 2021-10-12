import 'package:konnect/constants.dart';
import 'package:konnect/screens/chat_home.dart';
import 'package:flutter/material.dart';

import '../components/auth.dart';

class LoginNew extends StatefulWidget {
  LoginNew({Key key}) : super(key: key);

  @override
  _LoginNewState createState() => _LoginNewState();
}

class _LoginNewState extends State<LoginNew> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              width: width,
              height: height,
              color: Colors.grey[100],
            ),
            Positioned(
              top: -height * 0.2,
              right: -width * 0.1,
              child: Container(
                height: height * 0.6,
                width: width * 1.2,
                decoration: BoxDecoration(
                
                  color: primaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(300),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment(0, -0.6),
                  child: Text(
                    'Konnect',
                    style: TextStyle(
                      fontSize: height / 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment(0, -0.22),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x40000000),
                          blurRadius: 4,
                          offset: Offset(0, 4))
                    ],
                    border: Border.all(width: 5, color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Image(
                  image: AssetImage("assets/images/logo.png"),
                  width: height * 0.1,
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.black,
                      indent: width * 0.1,
                      endIndent: width * 0.05,
                    ),
                  ),
                  Text(
                    "Sign in",
                    style: TextStyle(
                      fontSize: height / 40,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.black,
                      indent: width * 0.05,
                      endIndent: width * 0.1,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment(0, 0.4),
              child: RaisedButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          ),
                        );
                      });
                  try {
                    signInWithGoogle().then((result) {
                      if (result != null) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) {
                          return ChatHome();
                        }), (Route<dynamic> route) => false);
                      }
                    }).catchError((onError) {});
                  } catch (Exception) {}
                },
                splashColor: Colors.grey,
                color: Colors.white,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                          image: AssetImage("assets/google_logo.png"),
                          height: 35.0),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 40,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.9),
              child: Text("0.1.0"),
            )
          ],
        ),
      ),
    );
  }
}
