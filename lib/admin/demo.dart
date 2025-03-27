import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../global.dart';
import '../model/story.dart';

class ChatStoryDemo extends StatefulWidget {
  String pic;String char1; String category;String char2;String dp;
  final List<Map<String, dynamic>> messages; // Accept only conversation list

  ChatStoryDemo({required this.messages,required this.char1,required this.category,required this.pic,required this.char2,required this.dp});

  @override
  _ChatStoryDemoState createState() => _ChatStoryDemoState();
}

class _ChatStoryDemoState extends State<ChatStoryDemo> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollToBottom();
  }

  /// Scrolls to the bottom of the chat
  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }
  final String geminiresponse=DateTime.now().microsecondsSinceEpoch.toString();

  Future<void> saveChatToFirestore(String userId, String geminiId, List<Map<String, dynamic>> messages) async {
    CollectionReference storiesCollection =  FirebaseFirestore.instance
        .collection("Stories");
    DocumentReference storyDoc = storiesCollection.doc(geminiId);
    StoryModel story = StoryModel(
      timestamp: FieldValue.serverTimestamp(), // No explicit type casting
      id: geminiId,
      category: widget.category,
      public: true,
      picture: widget.pic,
      admin:true,
      char1: widget.char2,
      messages: messages.map((msg) => MessageModel(
        text: msg['text'],
        isMe: msg['isMe'],
        time: DateTime.now().millisecondsSinceEpoch, // Saves message order
      )).toList(), views: 0, dp:widget.dp,
    );
    await storyDoc.set(story.toJson());
    print("Chat story saved successfully!");
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          SizedBox(width: 10,),
        ],
        title: Column(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.pic), // Use the story picture
            ),
            Text(widget.char1, style: TextStyle(fontSize: 12, color: Colors.black)), // Show character name
          ],
        ),
        backgroundColor: Colors.grey.shade100,
        iconTheme: IconThemeData(
            color: Colors.blueAccent
        ),
      ),
      body: Container(
        color: Colors.white, // Light mode
        child: Column(
          children: [
            Expanded(
              child: widget.messages.isEmpty
                  ? Center(
                child: Text("No messages yet!", style: TextStyle(color: Colors.black)),
              )
                  : ListView.builder(
                controller: _scrollController,
                itemCount: widget.messages.length,
                itemBuilder: (context, index) {
                  return chatBubble(
                    widget.messages[index]['text'],
                    widget.messages[index]['isMe'],
                    w,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: () async {
            await saveChatToFirestore(FirebaseAuth.instance.currentUser!.uid, geminiresponse, widget.messages);
            Navigator.pop(context);
            Global.showMessage(context, "Story Saved Successfully");
          },
          child: Container(
            height:45,width:MediaQuery.of(context).size.width,
            decoration:BoxDecoration(
              borderRadius:BorderRadius.circular(7),
              color:Colors.blue,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                  spreadRadius: 5, // The extent to which the shadow spreads
                  blurRadius: 7, // The blur radius of the shadow
                  offset: Offset(0, 3), // The position of the shadow
                ),
              ],
            ),
            child: Center(child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save,color: Colors.white,),
                Text("Save this Story",style: TextStyle(
                    color: Colors.white,
                    fontFamily: "RobotoS",fontWeight: FontWeight.w800
                ),),
              ],
            )),
          ),
        ),
      ],
    );
  }

  Widget chatBubble(String message, bool isMe, double w) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: w - 55,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isMe ? Color(0xff49B5FD) : Color(0xffE6E5EB),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: isMe ? Radius.circular(16) : Radius.circular(0),
            bottomRight: isMe ? Radius.circular(0) : Radius.circular(16),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(color: !isMe ? Colors.black : Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
