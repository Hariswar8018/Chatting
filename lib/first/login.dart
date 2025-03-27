import 'dart:async';
import 'package:chatting/first/forgot.dart';
import 'package:chatting/first/profile.dart';
import 'package:chatting/global.dart';
import 'package:chatting/home/chat_screen.dart';
import 'package:chatting/home/home.dart';
import 'package:chatting/home/navigation.dart';
import 'package:chatting/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int i = 0; // Track the index

  @override
  void initState() {
    super.initState();
    f(); // Start the timer
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool b=false;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: b?Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Spacer(),
                Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      )),
                  child: Text("       "),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                SizedBox(width: 10),
                Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      )),
                  child: Text(" "),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Spacer(),
              d(1),
              d(2),
              d(3),d(4),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 10),
          Image.asset("assets/33bfe9ad-805b-405f-90f1-584e3c2f5fc6.jpeg", width: w),
          signup?fg(name, "Your Name", ""):SizedBox(),
          fg(email, "Your Email", ""),
          fg(password, "Your Password", ""),
          SizedBox(height: 5),
          progress?Center(child: CircularProgressIndicator(backgroundColor: Colors.grey,)):InkWell(
            onTap: () async {
              setState(() {
                progress=true;
              });
              if(signup){
                try{
                  final us=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text);
                  UserModel user=UserModel(name: name.text, 
                      email: email.text, position: "", no: 0, uid: us.user!.uid, 
                      pic: "", school: "", other1: "", other2: "");
                  await FirebaseFirestore.instance.collection("users").doc(us.user!.uid).set(user.toJson());
                  Navigator.push(
                      context, PageTransition(
                      child: Profile(user: user, update: false,), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                  ));
                  Global.showMessage(context, "SignUp Successful");
                }catch(e){
                  Global.showMessage(context, "$e");
                }
              }else{
                try{
                  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
                  Navigator.push(
                      context, PageTransition(
                      child: Home(), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                  ));
                  Global.showMessage(context, "LoggedIn Successful");
                }catch(e){
                  Global.showMessage(context, "$e");
                }
              }
              setState(() {
                progress=false;
              });
            },
            child:Center(
              child: Container(
                height:45,width:w-40,
                decoration:BoxDecoration(
                  borderRadius:BorderRadius.circular(7),
                  color:Colors.grey,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                      spreadRadius: 5, // The extent to which the shadow spreads
                      blurRadius: 7, // The blur radius of the shadow
                      offset: Offset(0, 3), // The position of the shadow
                    ),
                  ],
                ),
                child: Center(child: Text(signup?"Sign Up":"Login Now",style: TextStyle(
                    color: Colors.black,
                    fontFamily: "RobotoS",fontWeight: FontWeight.w800
                ),)),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 13,),
              TextButton(onPressed: () {
                setState(() {
                  if(signup){
                    signup=false;
                  }else{
                    signup=true;
                  }
                });
              }, child: Text(signup?"Not New? Login ":"New User? Sign Up here",style: TextStyle(color: Colors.white),),),
              Spacer(),
              TextButton(onPressed: () {
                Navigator.push(
                    context, PageTransition(
                    child: Forgot(), type: PageTransitionType.topToBottom, duration: Duration(milliseconds: 800)
                ));
              }, child: Text("Forgot Password?",style: TextStyle(color: Colors.white),),),
              SizedBox(width: 13,),
            ],
          ),
        ],
      ):Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Spacer(),
                Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      )),
                  child: Text("       "),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                SizedBox(width: 10),
                Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      )),
                  child: Text(" "),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Spacer(),
              d(1),
              d(2),
              d(3),d(4),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 80),
          Image.asset("assets/33bfe9ad-805b-405f-90f1-584e3c2f5fc6.jpeg", width: w),
          SizedBox(height: 40),
          InkWell(
            onTap: (){
             setState(() {
               b=true;
             });
            },
            child: Container(
              width: w - 70,
              height: 65,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: Center(
                  child: Text(
                    "Signup / Login",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 17),
                  )),
            ),
          ),
        ],
      ),
    );
  }
  bool progress=false;
  bool signup=false;
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


  TextEditingController name=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController verify=TextEditingController();
  TextEditingController password=TextEditingController();
  Widget d(int j) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(shape: BoxShape.circle, color: i != j ? Colors.white : Colors.grey),
      ),
    );
  }

  void f() {
    Timer.periodic(Duration(milliseconds: 300), (timer) {
      setState(() {
        if (i >= 5) {
          i = 0; // Reset to 1
        } else {
          i++;
        }
      });
    });
  }
}
