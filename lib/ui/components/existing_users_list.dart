// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:konnect/core/constants/core.dart';
import 'package:konnect/core/model/user_model.dart';
import 'package:konnect/ui/view/home/chat_screen.dart';

class ExistingUserWidget extends StatefulWidget {
  final UserModel userModel;
  final String chatId;

  const ExistingUserWidget({this.userModel, this.chatId});

  @override
  _ExistingUserWidgetState createState() => _ExistingUserWidgetState();
}

class _ExistingUserWidgetState extends State<ExistingUserWidget> {
  String lMsg = '';
  String date = '';
  @override
  void initState() {
    print('Entered4');

    lastMsg();
    super.initState();
  }

  @override
  void didUpdateWidget(ExistingUserWidget oldWidget) {
    lastMsg();
    super.didUpdateWidget(oldWidget);
  }

  String times(DateTime dateCreated) {
    String fStr = "";
    if (dateCreated != null) {
      if (dateCreated.hour < 10) {
        fStr = "0${dateCreated.hour}:";
      } else {
        fStr = "${dateCreated.hour}:";
      }
      if (dateCreated.minute < 10) {
        fStr = "${fStr}0${dateCreated.minute}";
      } else {
        fStr = "$fStr${dateCreated.minute}";
      }
    }
    return fStr;
  }

  void lastMsg() {
    print('Called Lastmsg');
    final _firestore = FirebaseFirestore.instance.collection('newMessages');
    _firestore
        .doc(widget.chatId)
        .collection('messages')
        .orderBy('created', descending: true)
        .get()
        .then((QuerySnapshot qs) {
      if (qs.docs.isNotEmpty) {
        if (qs.docs[0].data()['type'] == 'txt') {
          lMsg = qs.docs[0].data()['text'];
        } else {
          lMsg = 'Voice Message (${qs.docs[0].data()['duration']})';
        }
        DateTime dateCreated = qs.docs[0].data()['created']?.toDate();
        DateTime thisDate = DateTime.now();

        if (thisDate.day == dateCreated.day) {
          date = times(qs.docs[0].data()['created']?.toDate());
        } else {
          date = '${dateCreated.day}/${dateCreated.month}/21';
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return ChatScreen(
                  otherUserModel: widget.userModel,
                  chatId: widget.chatId,
                );
              },
            ),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width * 0.08),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40000000),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: width * 0.075,
                child: CircleAvatar(
                  radius: width * 0.07,
                  backgroundImage: NetworkImage(widget.userModel.photoURL),
                ),
              ),
            ),
            SizedBox(width: width * 0.05),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userModel.name,
                  style: TextStyle(
                    fontFamily: AppStrings.FONT_FAMILY, // Montserrat-Bold
                    fontSize: width / 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: width * 0.01,
                ),
                Text(
                  lMsg,
                  style: TextStyle(
                    fontFamily: AppStrings.FONT_FAMILY, // Montserrat-Medium 
                    fontSize: width / 30,
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              date,
              style: TextStyle(
                fontFamily: AppStrings.FONT_FAMILY, // Montserrat-Medium
                fontSize: width / 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
