import 'package:chatting/global.dart';
import 'package:chatting/home/chat_screen.dart';
import 'package:chatting/home/chatscreen2.dart';
import 'package:chatting/home/second/chat.dart';
import 'package:chatting/model/story.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../main.dart';

class Createe extends StatefulWidget {
 Createe({super.key});

  @override
  State<Createe> createState() => _CreateeState();
}

class _CreateeState extends State<Createe> {
bool on=false;

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:isDarkModeEnabled?Colors.white: Colors.black,
      appBar: AppBar(
        backgroundColor: isDarkModeEnabled?Colors.white:Colors.black,
        automaticallyImplyLeading: false,
        title: Text("Create Stories",style: TextStyle(color: isDarkModeEnabled?Colors.black:Colors.white),),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    InkWell(
                        onTap: (){
                          setState(() {
                            on=true;
                            i=0;
                          });
                        },
                        child: s(char1,"Character 1","assets/2218159.webp")),
                    SizedBox(height: 10,),
                    InkWell(
                        onTap: (){
                          setState(() {
                            on=true;
                            i=1;
                          });

                        },
                        child: s(situation,"Situation","assets/flat-design-concept-of-businessman-with-different-poses-working-and-presenting-process-gestures-actions-and-poses-cartoon-character-design-set-vector.jpg")),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    InkWell(
                        onTap: (){

                            setState(() {
                              on=true;
                              i=2;
                            });

                        },
                        child: s(char2,"Character 2","assets/2218185.webp")),
                    SizedBox(height: 10,),
                    InkWell(
                        onTap: (){
                          setState(() {
                            on=true;
                            i=3;
                          });

                        },
                        child: s(mood,"Mood","assets/depositphotos_101268878-stock-illustration-set-of-colorful-emoticons-emoji.jpg")),
                  ],
                ),
              ),

            ],
          ),
          SizedBox(height: 10,),
          c(),
          SizedBox(height: 15,),
          InkWell(
              onTap: (){
                if(char1.text.isEmpty||char2.text.isEmpty||situation.text.isEmpty||mood.text.isEmpty){
                  Global.showMessage(context, "Type all Character 1, 2, Situation and about Mood");
                  return ;
                }
                Navigator.push(
                    context, PageTransition(
                    child: ChatScreen(str:tyup(), admin: false, character1name: getF(char1.text), picture: "https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/no-profile-picture-icon.png", character2name: getF(char2.text), dp: 'https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/no-profile-picture-icon.png',), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                ));
              },
              child: Global.button("Generate Story", w, Colors.grey)),
          SizedBox(height: 20,),
          Row(
            children: [
              ty("Your Creation"),
              Spacer(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 180,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('Stories').orderBy("id",descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                    case ConnectionState.done:
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("No stories available"));
                    }
                    List<StoryModel> stories = snapshot.data!.docs
                        .map((doc) => StoryModel.fromJson(doc.data() as Map<String, dynamic>))
                        .toList();
                    return Container(
                      width:w,height:220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                        itemCount: stories.length,
                        itemBuilder: (context, index) {
                          StoryModel story = stories[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adds spacing
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatStoryScreen(
                                      story: story, // Pass the StoryModel object
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 130,
                                height: 180,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12), // Rounded corners
                                  border: Border.all(
                                    color: isDarkModeEnabled?Colors.black:Colors.white,
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage("assets/logos.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
String getF(String input) {
  if (input.isEmpty) return ""; // Return empty string if input is empty
  String firstWord = input.split(RegExp(r'\s+'))[0]; // Get the first word
  return firstWord[0].toUpperCase() + firstWord.substring(1).toLowerCase(); // Capitalize the first letter
}

  int i=0;
  String tyup(){
   return "Write a Story in Chat Format where character 1 name ${getF(char1.text)} and Character 2 name ${char2.text} in a Situation ${situation.text} with a Mood of ${mood.text} in Hinglish (roman Hindi) Language [and no English Translation required] and in minimum 15000 words" ;
  }
  Widget c() {
    if(!on){
      return SizedBox();
    }
    if(i==0){
     return fg(char1, "Type About Character 1", "Character Name Ayush");
    }else if(i==1){
      return  fg(situation, "Type About Situation", "Inside a School");
    }else if(i==2){
      return fg(char2, "Type About Character 2", "Character Name Aysha");
    }else{
      return fg(mood, "Type About Mood", "Characters are both Angry");
    }
  }
  TextEditingController char1=TextEditingController();

  TextEditingController char2=TextEditingController();

  TextEditingController situation=TextEditingController();

  TextEditingController mood=TextEditingController();

Widget fg(TextEditingController ha, String str, String str2) => Padding(
  padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
  child: TextFormField(
    controller: ha,
    keyboardType: TextInputType.text,
    textCapitalization: TextCapitalization.words,
    style: TextStyle(color:isDarkModeEnabled?Colors.black: Colors.white), // ✅ Makes typed text white
    decoration: InputDecoration(
      labelText: str,
      labelStyle: TextStyle(color:isDarkModeEnabled?Colors.black: Colors.white), // ✅ Makes label text white
      hintText: str2,
      hintStyle: TextStyle(color: isDarkModeEnabled?Colors.black:Colors.white70), // ✅ Makes hint text white with slight opacity
      isDense: true,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: isDarkModeEnabled?Colors.black:Colors.white), // ✅ White border
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color:isDarkModeEnabled?Colors.black: Colors.white), // ✅ White border when not focused
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: isDarkModeEnabled?Colors.black:Colors.white, width: 2.0), // ✅ Thicker white border when focused
      ),
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Please type It';
      }
      return null;
    },
  ),
);


Widget ty(String str){
    return Text("   "+str,style: TextStyle(color:isDarkModeEnabled?Colors.black: Colors.white,fontSize: 18,fontWeight: FontWeight.w700,letterSpacing: 1.2),);
  }

  Widget s(TextEditingController c,String s, String pic){
    return Container(
      width: 150,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.black,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(pic),opacity: 0.6)
      ),
      child: Center(child: c.text.isEmpty?Text(s,style: TextStyle(color: Colors.white),):Icon(Icons.verified,color: Colors.green,)),
    );
  }
}
