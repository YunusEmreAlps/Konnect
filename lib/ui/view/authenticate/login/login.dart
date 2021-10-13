// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:konnect/core/constants/core.dart';
import 'package:konnect/core/init/app_localizations.dart';
import 'package:konnect/core/init/size_config.dart';
import 'package:konnect/ui/components/auth.dart';
import 'package:konnect/ui/view/home/chat_home.dart';

class LoginNew extends StatefulWidget {
  LoginNew({Key key}) : super(key: key);

  @override
  _LoginNewState createState() => _LoginNewState();
}

class _LoginNewState extends State<LoginNew> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    AppLocalizations.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
              image: AssetImage(AppImages.pngLoginBackground),
              fit: BoxFit.cover),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // Logo
            Center(
              child: Image.asset(
                AppImages.pngLogo,
                height: 250,
              ),
            ),
            // Animated Text
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 54.0, horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: getProportionateScreenHeight(56),
                    child: ElevatedButton(
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
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF6CD8D1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Color(0xFF6CD8D1)),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            AppImages.iconWhiteGoogle,
                            height: getProportionateScreenHeight(29),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              AppStrings.CONNECT_GOOGLE,
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(18),
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
