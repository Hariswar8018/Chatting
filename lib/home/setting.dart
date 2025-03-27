import 'package:chatting/first/login.dart';
import 'package:chatting/first/profile.dart';
import 'package:chatting/global.dart';
import 'package:chatting/main.dart';
import 'package:chatting/model/user.dart';
import 'package:chatting/providers/declare.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: isDarkModeEnabled?Colors.white:Colors.black,
      body: Column(
        children: [
          SizedBox(height: 55,),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CircleAvatar(
              radius: 55,
              backgroundImage: NetworkImage(_user!.pic),
            ),
          ),
          Text(_user.name,style: TextStyle(color: isDarkModeEnabled?Colors.black:Colors.white,fontSize: 20,fontWeight: FontWeight.w700),),
          Text(_user.email,style: TextStyle(color: isDarkModeEnabled?Colors.black:Colors.grey,fontSize: 17,fontWeight: FontWeight.w400),),
          SizedBox(height: 25,),
          InkWell(
            onTap: (){
              Navigator.push(
                  context, PageTransition(
                  child: Profile(user: _user, update: true,), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
              ));
            },
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color:isDarkModeEnabled?Colors.grey.shade200: Global.blac,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)
                    )
                ),
                width: w-20,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      Icon(Icons.person,color:isDarkModeEnabled?Colors.black: Colors.white),
                      SizedBox(width: 7,),
                      Text("User Profile",style: TextStyle(color:isDarkModeEnabled?Colors.black: Colors.white,fontWeight: FontWeight.w500),)
                    ],
                  ),
                ),
              ),
            ),
          ),
          InkWell(
              onTap: () async {
                Global.showMessage(context, "Will be Available Soon");
              },
              child: r(w,"Subscriptions", Icon(Icons.subscriptions,color:isDarkModeEnabled?Colors.black: Colors.white),)),
          InkWell(
              onTap: () async {
                final Uri _url = Uri.parse('https://venusluxe.space/terms-and-condition');
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
              },
              child: r(w,"Terms & Condition", Icon(Icons.language,color: isDarkModeEnabled?Colors.black:Colors.white),)),
          InkWell(
              onTap: () async {
                final Uri _url = Uri.parse('https://venusluxe.space/privacy-policy');
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
              },
              child: r(w,"Privacy", Icon(Icons.privacy_tip,color:isDarkModeEnabled?Colors.black: Colors.white),)),
          InkWell(
              onTap: () async {
                try{
                  FirebaseAuth auth = FirebaseAuth.instance;
                  await auth.sendPasswordResetEmail(email: _user!.email);
                  Global.showMessage(context, "Reset Email Sended");
                }catch(e){
                  Global.showMessage(context, "$e");
                }
              },
              child: r(w,"ResetPassword", Icon(Icons.lock_reset,color: isDarkModeEnabled?Colors.black:Colors.white),)),
          InkWell(
            onTap: (){
              FirebaseAuth auth = FirebaseAuth.instance;
              auth.signOut().then((res) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>Login()),
                );
              });
            },
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color:isDarkModeEnabled?Colors.grey.shade200: Global.blac,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                    )
                ),
                width: w-20,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      Icon(Icons.login,color: Colors.red),
                      SizedBox(width: 7,),
                      Text("Log Out",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500),)
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 60,),
        ],
      ),
    );
  }
  Widget r1(double w, String str,Widget r,Widget r1)=>Center(
    child: Container(
      decoration: BoxDecoration(
        color: isDarkModeEnabled?Colors.grey.shade200:Global.blac,
      ),
      width: w-20,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            r,
            SizedBox(width: 7,),
            Text(str,style: TextStyle(color:isDarkModeEnabled?Colors.black: Colors.white,fontWeight: FontWeight.w500),),
            Spacer(),
            r1,
          ],
        ),
      ),
    ),
  );
  Widget r(double w, String str,Widget r)=>Center(
    child: Container(
      decoration: BoxDecoration(
        color: isDarkModeEnabled?Colors.grey.shade200:Global.blac,
      ),
      width: w-20,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            r,
            SizedBox(width: 7,),
            Text(str,style: TextStyle(color:isDarkModeEnabled?Colors.black: Colors.white,fontWeight: FontWeight.w500),)
          ],
        ),
      ),
    ),
  );
}
