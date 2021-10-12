// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:konnect/core/constants/core.dart';
import 'package:konnect/core/service/audio_provider.dart';
import 'package:konnect/ui/components/wave.dart';

String times(QueryDocumentSnapshot message) {
  DateTime dateCreated = message.data()["created"]?.toDate();
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

class TextMessageBubble extends StatelessWidget {
  final QueryDocumentSnapshot message;
  final bool isMe;
  TextMessageBubble({this.message, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Text(
          //   message.data()['name'],
          //   style: TextStyle(fontSize: 12, color: Colors.black54),
          // ),
          Material(
            elevation: 2,
            borderRadius: BorderRadius.only(
              topRight: isMe ? Radius.zero : Radius.circular(30),
              topLeft: isMe ? Radius.circular(30) : Radius.zero,
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: isMe ? AppColors.colorPrimary : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                message.data()['text'],
                style: TextStyle(
                    color: isMe ? Colors.white : Colors.black54, fontSize: 15),
              ),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            times(message),
            style: TextStyle(fontSize: 8, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class Bubble extends StatefulWidget {
  final QueryDocumentSnapshot message;
  final bool isMe;

  Bubble({this.message, this.isMe});

  @override
  _BubbleState createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var content = widget.message.data()['content'];

    return (widget.message.data()['type'].contains('txt'))
        ? TextMessageBubble(message: widget.message, isMe: widget.isMe)
        : Consumer<AudioProvider>(builder: (context, aud, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: widget.isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 2.0,
                    color: widget.isMe ? Colors.lightBlueAccent : Colors.white,
                    child: Container(
                      padding: EdgeInsets.all(6.0),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    widget.message.data()['photo']),
                              ),
                              SizedBox(height: 2),
                              Text(widget.message.data()['duration'],
                                  style: TextStyle(
                                      color: widget.isMe
                                          ? Colors.white
                                          : Colors.black))
                            ],
                          ),
                          !(aud.isPlaying && aud.tUrl == content)
                              ? SizedBox()
                              : Wave(
                                  height: height * 0.08,
                                  width: width * 0.15,
                                  isFull: false,
                                ),
                          IconButton(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            iconSize: MediaQuery.of(context).size.height * 0.06,
                            icon: (aud.isPlaying && aud.tUrl == content)
                                ? Icon(
                                    Icons.stop_circle_outlined,
                                    color: Colors.black,
                                  )
                                : Icon(
                                    Icons.play_arrow,
                                    color: Colors.black,
                                  ),
                            onPressed: () async {
                              aud.isPlaying
                                  ? aud.stopPlayer()
                                  : aud.play(content); 
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    times(widget.message),
                    style: TextStyle(fontSize: 8),
                  )
                ],
              ),
            );
          });
  }
}
