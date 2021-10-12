import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:konnect/components/auth.dart';
import 'package:konnect/models/user_model.dart';
import 'package:konnect/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  final UserModel userModel;

  const UserWidget({this.userModel});

  String generateChatId() {
    String genUid = uid.substring(0, 6) + userModel.uid.substring(0, 6);
    return genUid;
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    final width = MediaQuery.of(context).size.width;

    return TextButton.icon(
      onPressed: () {
        String _chatId = generateChatId();
        _firestore.collection('newMessages').doc(_chatId).set({}).then(
          (value) {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
              builder: (context) {
                return ChatScreen(
                  otherUserModel: userModel,
                  chatId: _chatId,
                );
              },
            ), (Route<dynamic> route) => false);
          },
        );
      },
      label: Text(
        userModel.name,
        style: TextStyle(fontSize: width / 25),
      ),
      icon: CircleAvatar(
        backgroundImage: NetworkImage(userModel.photoURL),
        radius: width / 20,
      ),
    );
  }
}
