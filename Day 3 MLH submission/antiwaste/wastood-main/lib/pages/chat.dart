import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:wastood/domain/wastood.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({Key key, @required this.wastood}) : super(key: key);
  final Wastood wastood;

  @override
  _ChatWidgetState createState() => _ChatWidgetState(wastood: wastood);
}

class _ChatWidgetState extends State<ChatWidget> {
  _ChatWidgetState({@required this.wastood});
  final Wastood wastood;
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  final FirebaseStorage fsore = FirebaseStorage.instance;

  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();

  var i = 0;

  @override
  void initState() {
    super.initState();
  }

  void systemMessage() {
    Timer(Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(Duration(milliseconds: 300), () {
        _chatViewKey.currentState.scrollController
          ..animateTo(
            _chatViewKey.currentState.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
      });
    });
  }

  void onSend(ChatMessage message) async {
    var documentReference = FirebaseFirestore.instance
        .collection('giveAways/${wastood.id}/messages');

    await documentReference.add({
      ...message.toJson(),
      "createdAt":
          Timestamp.fromMillisecondsSinceEpoch(message.toJson()["createdAt"])
    });
  }

  @override
  Widget build(BuildContext context) {
    // ChatUser user = args.wastood.
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("giveAways")
                    .doc(wastood.id)
                    .update({"completed": true});
                Navigator.popAndPushNamed(context, "/home");
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: StreamBuilder<User>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final userAuth = snapshot.data;

            final user =
                ChatUser(uid: userAuth.uid, name: userAuth.displayName, avatar: userAuth.photoURL);

            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("giveAways/${wastood.id}/messages")
                    .orderBy("createdAt")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    );
                  } else {
                    List<QueryDocumentSnapshot> items = snapshot.data.docs;

                    var messages = items.map((i) {
                      final chatUser = ChatUser(uid: i.data()["user"]["uid"], name: i.data()["user"]["name"], avatar: i.data()["user"]["avatar"]);
                      return ChatMessage.fromJson({
                        ...i.data(),
                        "user": chatUser.toJson(),
                        "createdAt":
                            i.data()["createdAt"].millisecondsSinceEpoch
                      });
                    }).toList();

                    return DashChat(
                      key: _chatViewKey,
                      inverted: false,
                      onSend: onSend,
                      sendOnEnter: true,
                      textInputAction: TextInputAction.send,
                      user: user,
                      inputDecoration: InputDecoration.collapsed(
                          hintText: "Add message here..."),
                      dateFormat: DateFormat('yyyy-MMM-dd'),
                      timeFormat: DateFormat('HH:mm'),
                      messages: messages,
                      showUserAvatar: true,
                      showAvatarForEveryMessage: false,
                      scrollToBottom: true,
                      onPressAvatar: (ChatUser user) {},
                      onLongPressAvatar: (ChatUser user) {},
                      inputMaxLines: 5,
                      messageContainerPadding:
                          EdgeInsets.only(left: 5.0, right: 5.0),
                      alwaysShowSend: true,
                      inputTextStyle: TextStyle(fontSize: 16.0),
                      inputContainerStyle: BoxDecoration(
                        border: Border.all(width: 0.0),
                        color: Colors.white,
                      ),
                      onQuickReply: (Reply reply) {
                        setState(() {
                          messages.add(ChatMessage(
                              text: reply.value,
                              createdAt: DateTime.now(),
                              user: user));

                          messages = [...messages];
                        });

                        Timer(Duration(milliseconds: 300), () {
                          _chatViewKey.currentState.scrollController
                            ..animateTo(
                              _chatViewKey.currentState.scrollController
                                  .position.maxScrollExtent,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 300),
                            );

                          if (i == 0) {
                            systemMessage();
                            Timer(Duration(milliseconds: 600), () {
                              systemMessage();
                            });
                          } else {
                            systemMessage();
                          }
                        });
                      },
                      onLoadEarlier: () {},
                      shouldShowLoadEarlier: false,
                      showTraillingBeforeSend: true,
                    );
                  }
                });
          }),
    );
  }
}
