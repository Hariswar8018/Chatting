import 'package:chatting/global.dart';
import 'package:chatting/home/chatscreen2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../model/story.dart';

class ChatScreen extends StatefulWidget {
  String str;String character1name;String picture; bool admin;String category;
  String character2name;String dp;
  ChatScreen({super.key,required this.dp,required this.character2name, required this.str,required this.admin,required this.character1name,required this.picture,this.category="Horror"});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String response = "";
  bool showSaveButton = false;

  @override
  void initState() {
    super.initState();
    progress=true;
    gu();
  }

  void gu() {
    getGeminiResponse(widget.str);
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        // Show an exit confirmation dialog
        bool exitApp = await _showExitConfirmationDialog(context);
        return exitApp; // true = exit, false = stay
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          actions: [
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
                                    "ReportedStories":FieldValue.arrayUnion([geminiresponse]),
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
            SizedBox(width: 15),
          ],
          title: Column(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                    widget.picture),
              ),
              Text(
               widget.character1name,
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
          backgroundColor: Colors.grey.shade100,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.blueAccent),
          ),
        ),
        body: SingleChildScrollView(child:Column(
          children: [
            progress?LinearProgressIndicator():SizedBox(),
            response.isEmpty? SizedBox(height: 35):SizedBox(),
            response.isEmpty?Center(
              child: Image.network(
                "https://i.pinimg.com/736x/c7/96/0c/c7960cce52a8a750454bc0cf216ef1b9.jpg",
                width: MediaQuery.of(context).size.width / 2,
              ),
            ):SizedBox(),
            response.isEmpty?Center(
              child: Text(
                '✍ Fetching Your Story...',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
              ),
            ):SizedBox(),
            SizedBox(height: 10),
            if (response.isNotEmpty) // Show response only when available
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  response,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),),
        persistentFooterButtons: [
          response.isEmpty?SizedBox(): Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      bool exitApp = await _showExitConfirmationDialog(context);
                      exitApp?Navigator.pop(context):SizedBox();
                    },
                    child: Container(
                      height:45,width:MediaQuery.of(context).size.width/2-10,
                      decoration:BoxDecoration(
                        borderRadius:BorderRadius.circular(7),
                        color:Colors.red,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                            spreadRadius: 5, // The extent to which the shadow spreads
                            blurRadius: 7, // The blur radius of the shadow
                            offset: Offset(0, 3), // The position of the shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.close,color: Colors.white,),
                          Center(child: Text(" Close",style: TextStyle(
                              color: Colors.white,
                              fontFamily: "RobotoS",fontWeight: FontWeight.w800
                          ),)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 3,),
                  InkWell(
                    onTap: (){
                      if(progress){
                        return ;
                      }
                      setState(() {
                        progress=true;
                      });
                      gu();
                    },
                    child: Container(
                      height:45,width:MediaQuery.of(context).size.width/2-10,
                      decoration:BoxDecoration(
                        borderRadius:BorderRadius.circular(7),
                        color:Colors.green,
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
                          Icon(Icons.recycling,color: Colors.white,),
                          Text("Regenerate",style: TextStyle(
                              color: Colors.white,
                              fontFamily: "RobotoS",fontWeight: FontWeight.w800
                          ),),
                        ],
                      )),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4,),
              InkWell(
                onTap: () async {
                  setState(() {
                    progress=true;
                  });
                  List<Map<String, dynamic>> messagesss = await parseChat(response);
                  print(messagesss);
                  await saveChatToFirestore(FirebaseAuth.instance.currentUser!.uid, geminiresponse, messagesss);
                  setState(() {
                    progress=false;
                  });
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
          ),
      ],
      ),
    );
  }
  final String geminiresponse=DateTime.now().microsecondsSinceEpoch.toString();
  List<Map<String, dynamic>> parseChat(String response) {
    List<Map<String, dynamic>> messages = [];

    // Updated regex to properly capture name and message
    RegExp regExp = RegExp(r"\*\*(.*?)\*\*\s(.*?)($|\*\*)", multiLine: true);

    for (RegExpMatch match in regExp.allMatches(response)) {
      String sender = match.group(1)?.trim() ?? "Unknown";
      String message = match.group(2)?.trim() ?? "";
      print(sender);
      print("------->");
      if (message.isNotEmpty) { // Avoid adding empty messages
        messages.add({
          "text": message,
          "isMe": sender == widget.character1name+":", // Assume 'Ayush' is the user
        });
      }
    }
    print(response);
    print(messages);
    return messages;
  }


  Future<void> saveChatToFirestore(
      String userId, String geminiId, List<Map<String, dynamic>> messages) async {
    CollectionReference storiesCollection = widget.admin? FirebaseFirestore.instance
        .collection("Stories"):FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Stories");
    DocumentReference storyDoc = storiesCollection.doc(geminiId);
    StoryModel story = StoryModel(
      timestamp: FieldValue.serverTimestamp(), // No explicit type casting
      id: geminiId,
      category: widget.category,
      public: true,
      picture: widget.picture,
      admin: widget.admin,
      char1: widget.character2name,
      messages: messages.map((msg) => MessageModel(
        text: msg['text'],
        isMe: msg['isMe'],
        time: DateTime.now().millisecondsSinceEpoch, // Saves message order
      )).toList(), views: 0, dp: widget.dp,
    );

    await storyDoc.set(story.toJson());
    print("Chat story saved successfully!");
  }


  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit Story Creation"),
        content: Text("Are you sure you want to exit Story Section? The last response if not saved will be deleted"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Stay on screen
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Exit app
            child: Text("Exit"),
          ),
        ],
      ),
    ) ??
        false; // Default to false if dismissed
  }

  Future<void> getGeminiResponse(String prompt) async {
    const apiKey = "AIzaSyBCULYosDsHRWKOPGzs2IWN41qqhl_g1Qw"; // Replace with your API key
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    try {
      final responseContent =
      await model.generateContent([Content.text(prompt)]);
      String geminiResponseText = responseContent.text ?? "No response";

      setState(() {
        response = geminiResponseText; // Store Gemini's response
        showSaveButton = true; // Show the "Save Response" button
        progress=false;
      });
    } catch (e) {
      print("Error fetching response from Gemini: $e");
    }
  }
  bool progress=false;
}
