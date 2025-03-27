import 'dart:typed_data';

import 'package:chatting/global.dart';
import 'package:chatting/model/story.dart';
import 'package:chatting/providers/storage.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:share_plus/share_plus.dart';

class ChatStoryScreen extends StatefulWidget {
  final StoryModel story;
  ChatStoryScreen({required this.story});

  @override
  _ChatStoryScreenState createState() => _ChatStoryScreenState();
}

class _ChatStoryScreenState extends State<ChatStoryScreen> {
  late List<MessageModel> messages; // Use MessageModel for messages
  final ScrollController _scrollController = ScrollController();

  Future<void> gh() async {
    try {
      await FirebaseFirestore.instance
          .collection("Stories").doc(widget.story.id).update({
        "views": FieldValue.increment(1),
      });
    }catch(e){

    }
  }
  @override
  void initState() {
    jop();
    super.initState();
    gh();
    messages = widget.story.messages; // Directly use messages from StoryModel
    scrollToBottom();
  }
  Future<void> jop() async {
    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

    bool away= await asyncPrefs.getBool('night')??false;
    setState(() {
      ison=away;
    });
  }
  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }
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
bool admin=(FirebaseAuth.instance.currentUser!.email=="ayush@fiverr.com"||FirebaseAuth.instance.currentUser!.email=="niraj.bhatt612@gmail.com"||FirebaseAuth.instance.currentUser!.email=="harttti@g.com");
  bool ison=false;
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            width:60,
            child: DayNightSwitcher(
              isDarkModeEnabled:ison,
              onStateChanged: (bool isDarkModeEnabled) async {
                setState(() {
                  ison=isDarkModeEnabled;
                });
                final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
                await asyncPrefs.setBool('night', isDarkModeEnabled);
              },
            ),
          ),SizedBox(width: 8,),
          widget.story.admin?Icon(Icons.remove_red_eye,color: Colors.black,):SizedBox(),
          SizedBox(width: 5,),
          widget.story.admin?Container(
            child: Text(widget.story.views.toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800),),
          ):SizedBox(),
          SizedBox(width: 15,),
          InkWell(
            onTap: () {
              Share.share('Hello ! I got New App name *Chatting* that have many Stories from Romance to Horror ! Also you could make your Own Story by Gemini AI here. \n\nSo, What are you waiting for?\nDownload now from PlayStore');
            },
            child: Icon(Icons.share_outlined, color: Colors.blueAccent),
          ),
          SizedBox(width: 10,),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    width: w,
                    color: Colors.white,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Report Content',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.red),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0,right: 18),
                          child: Text('Report this Content to Admin. If found Offensive/Vulgar/Harmful Content, This Story will be Deleted.',textAlign: TextAlign.center,),
                        ),
                        SizedBox(height: 20),
                        InkWell(
                            onTap: () async {
                              try {
                                await FirebaseFirestore.instance.collection("Report").doc("Report_Doc").set({
                                  "ReportedStories":FieldValue.arrayUnion([widget.story.id]),
                                });
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Global.showMessage(context, "Reported Successfully");
                              } catch (e) {
                                Navigator.pop(context);
                                Global.showMessage(context, "$e");
                              }
                            },
                            child:Center(child: Global.button("Report Now", w, Colors.yellow))),
                        SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              );
                },
            child: Icon(Icons.report, color: Colors.red),
          ),
          SizedBox(width: 10,),
        ],
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.blue,)),
            SizedBox(width: 8,),
            Column(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: widget.story.dp.isEmpty?NetworkImage(widget.story.picture):NetworkImage(widget.story.dp), // Use the story picture
                ),
                Text(widget.story.char1, style: TextStyle(fontSize: 12, color: Colors.black)), // Show character name
              ],
            ),
            SizedBox(width: 12,),
            admin? InkWell(
                onTap: (){
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Ensures the bottom sheet takes up only the required height
                          children: [
                            ListTile(
                              leading: Icon(Icons.person,color: Colors.blue,),
                              title: Text('Update DP'),
                              onTap: () async {
                                if(widget.story.admin){
                                  try {
                                    Uint8List? _file = await pickImage(ImageSource.gallery);
                                    if (_file == null) return;
                                    String photoUrl = await StorageMethods()
                                        .uploadImageToStorage('admin', _file, true);
                                    await FirebaseFirestore.instance
                                        .collection("Stories").doc(widget.story.id).update({
                                      "dp":photoUrl,
                                    });
                                    Navigator.pop(context);
                                    Global.showMessage(context, "Uploaded ! Updating in few minutes");
                                  }catch(e){
                                    Navigator.pop(context);
                                    Global.showMessage(context, "$e");
                                  }

                                }else{

                                }
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.book,color: Colors.green,),
                              title: Text('Update Banner'),
                              onTap: () async {
                                if(widget.story.admin){
                                  try {
                                    Uint8List? _file = await pickImage(ImageSource.gallery);
                                    if (_file == null) return;
                                    String photoUrl = await StorageMethods()
                                        .uploadImageToStorage('admin', _file, true);
                                    await FirebaseFirestore.instance
                                        .collection("Stories").doc(widget.story.id).update({
                                      "picture":photoUrl,
                                    });
                                    Navigator.pop(context);
                                    Global.showMessage(context, "Uploaded ! Updating in few minutes");
                                  }catch(e){
                                    Navigator.pop(context);
                                    Global.showMessage(context, "$e");
                                  }

                                }else{

                                }
                                                           },
                            ),
                            ListTile(
                              leading: Icon(Icons.delete,color: Colors.red,),
                              title: Text('Delete'),
                              onTap: () async {
                                if(widget.story.admin){
                                  await FirebaseFirestore.instance
                                      .collection("Stories").doc(widget.story.id).delete();
                                }else{

                                }
                                Navigator.pop(context); // Close the bottom sheet
                                Navigator.pop(context); // Close the bottom sheet
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Icon(Icons.edit,color: Colors.red,)):SizedBox()
          ],
        ),
        backgroundColor: Colors.grey.shade100,
        iconTheme: IconThemeData(
          color: Colors.blueAccent
        ),
      ),
      body: Container(
        color:ison?Colors.white: Colors.grey[900],
        child: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? Center(
                child: Text("No messages yet!", style: TextStyle(color: Colors.white)),
              )
                  : ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return chatBubble(
                    messages[index].text,
                    messages[index].isMe,w
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatBubble(String message, bool isMe,double w) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: w-55,
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
          style: TextStyle(color:  !isMe ? Colors.black:Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
