import 'dart:math';
import 'dart:typed_data';

import 'package:chatting/admin/demo.dart';
import 'package:chatting/global.dart';
import 'package:chatting/home/chat_screen.dart';
import 'package:chatting/model/story.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

import '../providers/storage.dart';

class Create_Admin extends StatefulWidget {
  const Create_Admin({super.key});

  @override
  State<Create_Admin> createState() => _Create_AdminState();
}

class _Create_AdminState extends State<Create_Admin> {
  bool on=false;
  int review=0;
  Widget f(double w, int yes)=>InkWell(
    onTap: (){
      setState(() {
        review=yes;
      });
      print(review);
    },
    child: Container(
      width: w/2-14,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: yes==review?Colors.yellowAccent:Global.blac,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            yes==0?Icon(Icons.copy,size: 25,color: Colors.black,):Icon(Icons.rocket_launch_sharp,size: 25,color: Colors.black,),
            Text(yiop(yes),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:yes==review? Colors.black:Colors.white)),
          ],
        ),
      ),
    ),
  );
  String yiop(int y){
    if(y==0){
      return "Copy Paste";
    }else if(y==1){
      return "Gemini AI";
    }else {
      return "Invites";
    }
  }
  Uint8List? _file;
  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text("Create Stories",style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Center(
              child: Container(
                  width: w-20,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Global.blac,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      // specify the radius for the top-left corner
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      // specify the radius for the top-right corner
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      f(w, 0),
                      f(w, 1),
                    ],
                  )
              ),
            ),
          ),
          mainp(w,h),
          SizedBox(height: 25,),

        ],
      ),
    );
  }
  Widget mainp(double w,double h){
    if(review==1) {
      return Container(
        width: w,height: h-200,
        child: Column(
          children: [
            Row(
              children: [
                g("Billionaire"),g('Horror'),g('Romance'),g("Fantasy"),g("Thriller")
              ],
            ),
            Row(
              children: [
                SizedBox(width: 10,),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () async {
                            try {
                              setState(() {
                                onnn=true;
                              });
                              Uint8List? _file = await pickImage(ImageSource.gallery);
                              if (_file == null) return;
                              String photoUrl = await StorageMethods()
                                  .uploadImageToStorage('admin', _file, true);
                              setState(() {
                                on=true;
                                onnn=false;
                                i=4;
                                picture.text=photoUrl;
                              });
                              Global.showMessage(context, "Uploaded !");
                            }catch(e){
                              setState(() {
                                onnn=false;
                              });
                              Global.showMessage(context, "$e");
                            }
                          },
                          child: onnn?CircularProgressIndicator():s(picture,"Picture Link","assets/pixars-brave-movie-poster.jpg")),
                      SizedBox(height: 10,),
                      InkWell(
                          onTap: () async {
                            try {
                              setState(() {
                                onnn=true;
                              });
                              Uint8List? _file = await pickImage(ImageSource.gallery);
                              if (_file == null) return;
                              String photoUrl = await StorageMethods()
                                  .uploadImageToStorage('admin', _file, true);
                              setState(() {
                                on=true;
                                onnn=false;
                                i=5;
                                dp.text=photoUrl;
                              });
                              Global.showMessage(context, "Uploaded !");
                            }catch(e){
                              setState(() {
                                onnn=false;
                              });
                              Global.showMessage(context, "$e");
                            }
                          },
                          child:onnn?CircularProgressIndicator(): s(dp,"Display Picture","assets/pic2.jpg")),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            c(),
            SizedBox(height: 10,),
            InkWell(
                onTap: (){
                  if(char1.text.isEmpty||char2.text.isEmpty||situation.text.isEmpty||mood.text.isEmpty){
                    Global.showMessage(context, "Type all Character 1, 2, Situation and about Mood");
                    return ;
                  }
                  Navigator.push(
                      context, PageTransition(
                      child: ChatScreen(category:hh,str:tyup(), character1name: getF(char1.text), admin: true, picture: picture.text, character2name: getF(char2.text), dp: dp.text,), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                  ));
                },
                child: Global.button("Generate $hh Story", w, Colors.grey)),
            SizedBox(height: 10,),
        
          ],
        ),
      );
    }
    return Container(
      width: w,height: h-200,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                g("Billionaire"),g('Horror'),g('Romance'),g("Fantasy"),g("Thriller")
              ],
            ),
            Row(
              children: [
                SizedBox(width: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: (){
                        setState(() {
                          off=true;
                          i=0;
                        });
                      },
                      child: s(char1,"Main Character","assets/2218159.webp")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: (){
                        setState(() {
                          off=true;
                          i=1;
                        });
                      },
                      child: s(char2,"Conversation","assets/chats.jpg")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () async {
                        try {
                          setState(() {
                            onnn=true;
                          });
                          Uint8List? _file = await pickImage(ImageSource.gallery);
                          if (_file == null) return;
                          String photoUrl = await StorageMethods()
                              .uploadImageToStorage('admin', _file, true);
                          setState(() {
                            off=true;
                            onnn=false;
                            i=4;
                            picture.text=photoUrl;
                          });
                          Global.showMessage(context, "Uploaded !");
                        }catch(e){
                          setState(() {
                            onnn=false;
                          });
                          Global.showMessage(context, "$e");
                        }
                      },
                      child:onnn?Center(child: CircularProgressIndicator()): s(picture,"Banner Picture","assets/pixars-brave-movie-poster.jpg")),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: (){
                        setState(() {
                          off=true;
                          i=5;
                        });
                      },
                      child: s6(char2,"Character 2","assets/2218159.webp")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () async {
                        try {
                          setState(() {
                            onnn=true;
                          });
                          Uint8List? _file = await pickImage(ImageSource.gallery);
                          if (_file == null) return;
                          String photoUrl = await StorageMethods()
                              .uploadImageToStorage('admin', _file, true);
                          setState(() {
                            off=true;
                            onnn=false;
                            i=6;
                            dp.text=photoUrl;
                          });
                          Global.showMessage(context, "Uploaded !");
                        }catch(e){
                          setState(() {
                            onnn=false;
                          });
                          Global.showMessage(context, "$e");
                        }
                      },
                      child: onnn?CircularProgressIndicator():s6(dp,"Display Picture","assets/pic2.jpg")),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0,bottom: 12),
              child: c1(),
            ),
            i==1?Text("Conversation should be in Format"):SizedBox(),
            InkWell(
                onTap: (){
                  if(conversation.text.isEmpty){
                    Global.showMessage(context, "Please type Conversation");
                  }if(char1.text.isEmpty){
                    Global.showMessage(context, "Please type main Character Name");
                  }
                  if(char1.text.isEmpty||char2.text.isEmpty){
                    Global.showMessage(context, "Type all Character 1, 2");
                    return ;
                  }
                 List<Map<String, dynamic>> g=  parseChat(conversation.text,char1.text);
                  print("----------->");
                  print(g);
                  Navigator.push(
                      context, PageTransition(
                      child: ChatStoryDemo(messages: g, char1: char1.text, category: hh, pic: picture.text, char2: char2.text, dp: dp.text,), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                  ));
                },
                child: Global.button("Generate Story with Conversation", w, Colors.grey)),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }

  bool onnn=false;
  List<Map<String, dynamic>> parseChat(String response, String userName) {
    List<Map<String, dynamic>> messages = [];

    // Regex to capture sender and message properly
    RegExp regExp = RegExp(r"([^:]+):\s(.+)", multiLine: true);

    print("-------> Parsing Chat");
    print("Raw Response:\n$response");

    for (RegExpMatch match in regExp.allMatches(response)) {
      String sender = match.group(1)?.trim() ?? "Unknown"; // Extract sender
      String message = match.group(2)?.trim() ?? ""; // Extract message

      if (message.isNotEmpty) { // Avoid empty messages
        messages.add({
          "text": message,
          "isMe": sender == userName, // Check if the sender is the user
        });

        // Debugging: Print each parsed message
        print("{text: $message, isMe: ${sender == userName}}");
      }
    }

    print("Final Parsed Messages: $messages");
    return messages;
  }
  TextEditingController dp=TextEditingController();
  TextEditingController conversation=TextEditingController();
  bool off=false;
  Widget as(bool b){
    return Row(
      children: [
        SizedBox(width: 10,),
        b?Icon(Icons.copy,size: 25,color: Colors.white,):Icon(Icons.rocket_launch_sharp,size: 25,color: Colors.white,),  SizedBox(width: 10,),
        Text(!b?"Gemini AI":"Copy Paste Conversation",style: TextStyle(color: Colors.white,fontSize: 21,fontWeight: FontWeight.w800),),
      ],
    );
  }
  int i=0;
  String getF(String input) {
    if (input.isEmpty) return ""; // Return empty string if input is empty
    String firstWord = input.split(RegExp(r'\s+'))[0]; // Get the first word
    return firstWord[0].toUpperCase() + firstWord.substring(1).toLowerCase(); // Capitalize the first letter
  }

  String tyup(){
    return "Write a Story in Chat Format ( only chat ) where character 1 name ${getF(char1.text)} and Character 2 name ${char2.text} in a Situation ${situation.text} with a Mood of ${mood.text} as $hh genere in Hinglish (roman Hindi) Language [and no English Translation required] and in minimum 15000 words";
  }
  TextEditingController copy=TextEditingController();
  Widget c1(){
    if(!off){
      return SizedBox();
    }
    if(i==0){
      return fg(char1, "Type Character 1 Name ( CAREFUL* )", "Ayush");
    }else if(i==1){
      return  frrrg(conversation, "Paste the Conversation", "Inside a School");
    }else if(i==5){
      return  fg(char2, "Character 2", "Akira");
    }else if(i==6){
      return  fg(dp, "Choose Display Picture", "https://images.png");
    }else {
      return fg(picture, "Picture Link", "https://images.png");
    }
  }
  Widget c() {
    if(!on){
      return SizedBox();
    }

    if(i==0){
      return fg(char1, "Type Character 1 Name", "Ayush");
    }else if(i==1){
      return  fg(situation, "Type About Situation", "Inside a School");
    }else if(i==2){
      return fg(char2, "Character 2 Name", "Aysha");
    }else if(i==4){
      return fg(picture, "Picture Link", "https://images.png");
    }else if(i==5){
      return fg(dp, "Display Picture", "https://images.png");
    }else{
      return fg(mood, "Type About Mood", "Characters are both Angry");
    }
  }
  String hh="Horror";
  Widget g(String f)=>InkWell(
    onTap: (){
      setState(() {
        hh=f;
      });
    },
    child: Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: hh==f?Colors.blue:Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8,right: 8,top: 4,bottom: 4),
            child: Text(f,style: TextStyle(color:hh==f?Colors.white: Colors.black),),
          )),
    ),
  );
  TextEditingController picture=TextEditingController();
  TextEditingController category=TextEditingController();
  TextEditingController char1=TextEditingController();

  TextEditingController char2=TextEditingController();

  TextEditingController situation=TextEditingController();

  TextEditingController mood=TextEditingController();

  Widget fg(TextEditingController ha, String str, String str2) => Padding(
    padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
    child: TextFormField(
      controller: ha,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.white), // ✅ Makes typed text white
      decoration: InputDecoration(
        labelText: str,
        labelStyle: TextStyle(color: Colors.white), // ✅ Makes label text white
        hintText: str2,
        hintStyle: TextStyle(color: Colors.white70), // ✅ Makes hint text white with slight opacity
        isDense: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white), // ✅ White border
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white), // ✅ White border when not focused
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0), // ✅ Thicker white border when focused
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
  Widget frrrg(TextEditingController ha, String str, String str2) => Padding(
    padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
    child: TextFormField(
      controller: ha,
      minLines: 10,maxLines: 1000000,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.white), // ✅ Makes typed text white
      decoration: InputDecoration(
        labelText: str,
        labelStyle: TextStyle(color: Colors.white), // ✅ Makes label text white
        hintText: str2,
        hintStyle: TextStyle(color: Colors.white70), // ✅ Makes hint text white with slight opacity
        isDense: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white), // ✅ White border
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white), // ✅ White border when not focused
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0), // ✅ Thicker white border when focused
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
    return Text("   "+str,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w700,letterSpacing: 1.2),);
  }

  Widget s(TextEditingController c,String s, String pic){
    return Container(
      width: 110,
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
  Widget s6(TextEditingController c,String s, String pic){
    return Container(
      width: 170,
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
