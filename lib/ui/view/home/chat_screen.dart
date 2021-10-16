// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:konnect/core/constants/core.dart';
import 'package:konnect/core/model/user_model.dart';
import 'package:konnect/core/service/audio_provider.dart';
import 'package:konnect/core/service/upload_audio.dart';
import 'package:konnect/ui/components/auth.dart';
import 'package:konnect/ui/components/message_stream.dart';
import 'package:konnect/ui/components/wave.dart';
import 'package:konnect/ui/view/home/chat_home.dart';

final _firestore = FirebaseFirestore.instance;
auth.User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat';
  final String chatId;
  final UserModel otherUserModel;

  const ChatScreen({this.chatId, this.otherUserModel});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  String messageText;
  final _auth = auth.FirebaseAuth.instance;

  bool sendButtonVisible = false;
  bool showWave = false;
  bool recordButtonVisible = true;
  bool isTextMsg = true;

  String content;
  bool isMe = true;
  
  // type of voice effect
  // 0 -> normal
  // 1 -> lorie
  // 2 -> terror
  // 3 -> uncle
  // 4 -> funny
  // 5 -> vacant
  int t = 4;

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    messageTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getPermissions();
    getCurrentUser();
    Provider.of<AudioProvider>(context, listen: false).initRec();
    super.initState();
  }

  Future<void> getPermissions() async {
    var statusMic = await Permission.microphone.request();

    if (statusMic == PermissionStatus.denied) {
      Fluttertoast.showToast(
          msg: AppStrings.RECORD_STATUS);
      await Future.delayed(Duration(seconds: 1));
      getPermissions();
    }
  }

  void sendMessage() {
    uploadAudio(Provider.of<AudioProvider>(context, listen: false).mPath)
        .then((downloadUrl) {
      firestoreMsgUpload(downloadUrl);
    });
  }

  firestoreMsgUpload(content) {
    var documentReference = FirebaseFirestore.instance
        .collection('newMessages')
        .doc(widget.chatId)
        .collection('messages')
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        {
          'name': name,
          'photo': imageUrl,
          'duration': Provider.of<AudioProvider>(context, listen: false).dur,
          'type': "voice",
          'sender': email,
          'content': content,
          'created': FieldValue.serverTimestamp()
        },
      );

      setState(() {
        recordButtonVisible = true;
        isTextMsg = true;
        sendButtonVisible = false;
        showWave = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Consumer<AudioProvider>(builder: (context, aud, child) {
      return WillPopScope(
        onWillPop: () {
          // Provider.of<AudioProvider>(context, listen: false).dispRec();
          return Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return ChatHome();
              },
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Provider.of<AudioProvider>(context, listen: false).dispRec();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return ChatHome();
                    },
                  ),
                );
              },
            ),
            actions: <Widget>[
              PopupMenuButton(
                onSelected: (value) {
                  //Deleting a collection in firestore
                  _firestore
                      .collection('newMessages')
                      .doc(widget.chatId)
                      .collection('messages')
                      .get()
                      .then(
                        (res) => res.docs.forEach(
                          (element) {
                            element.reference.delete();
                          },
                        ),
                      );
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text(AppStrings.CLEAR_CHAT),
                  ),
                ],
              ),
            ],
            titleSpacing: 0,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage('${widget.otherUserModel.photoURL}'),
                ),
                SizedBox(width: 5),
                Text(
                  '${widget.otherUserModel.name}',
                  style: TextStyle(fontFamily: 'Gilroy'), // Montserrat-Medium
                ),
              ],
            ),
            backgroundColor: AppColors.colorPrimary,
          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                    child: MessagesStream(
                  chatId: widget.chatId,
                )),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: showWave
                              ? aud.isRecStopped
                                  ? textField()
                                  : Row(
                                      children: [
                                        SizedBox(width: width * 0.025),
                                        Container(
                                          width: width * 0.786,
                                          height: height * 0.075,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          margin:
                                              EdgeInsets.symmetric(vertical: 8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              border: Border.all(
                                                  color: Colors.black45)),
                                          child: Wave(
                                              height: height * 0.08,
                                              width: width * 0.45,
                                              isFull: true),
                                        ),
                                      ],
                                    )
                              : textField()),
                      Visibility(
                        visible: recordButtonVisible,
                        child: GestureDetector(
                          onTap: () => Fluttertoast.showToast(
                            msg: AppStrings.RECORD_GUIDE,
                          ),
                          onLongPress: () async {
                            setState(() {
                              sendButtonVisible = false;
                              showWave = true;
                              isTextMsg = false;
                            });
                            aud.getRecorder();
                          },
                          onLongPressEnd: (longPressEndDetails) {
                            aud.stopRecorder().then((value) async {
                              await aud.duration();
                            });
                            sendMessage();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 8.0),
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  color: AppColors.colorPrimary,
                                  borderRadius: BorderRadius.circular(32)),
                              child: Icon(
                                Icons.keyboard_voice,
                                size: width * 0.1,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: sendButtonVisible,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(4, 0, 8, 8),
                          child: IconButton(
                            icon: Icon(
                              Icons.send,
                              size: width * 0.1,
                            ),
                            onPressed: () {
                              if (isTextMsg) {
                                messageTextController.clear();
                                _firestore
                                    .collection('newMessages')
                                    .doc(widget.chatId)
                                    .collection('messages')
                                    .add({
                                  'text': messageText,
                                  'type': "txt",
                                  'name': name,
                                  'sender': loggedInUser.email,
                                  'created': FieldValue.serverTimestamp()
                                });
                                setState(() {
                                  sendButtonVisible = false;
                                  recordButtonVisible = true;
                                });
                              } else {
                                sendMessage();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget textField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 0, 8),
      child: TextField(
        controller: messageTextController,
        onChanged: (value) {
          setState(() {
            if (value == '') {
              sendButtonVisible = false;
              recordButtonVisible = true;
            } else {
              sendButtonVisible = true;
              recordButtonVisible = false;
            }
          });
          messageText = value;
        },
        decoration: kMessageTextFieldDecoration,
      ),
    );
  }
}
