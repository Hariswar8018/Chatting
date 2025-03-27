import 'package:chatting/admin/all_users.dart';
import 'package:chatting/admin/create.dart';
import 'package:chatting/home/create.dart';
import 'package:chatting/home/home.dart';
import 'package:chatting/home/setting.dart';
import 'package:chatting/home/story.dart';
import 'package:chatting/providers/declare.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void initState(){
    dr();
  }
  void dr()async{
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshuser();
  }
  String gh=FirebaseAuth.instance.currentUser!.email!;

  Widget diu(){
    if(_currentIndex==2){
      return Settings();
    }else if(_currentIndex==1){
      return Createe();
    }
    return Home2(admin: false,);
  }
  Future<bool> _onWillPop(BuildContext context) async {
    bool exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Exit App"),
          content: Text("Are you sure you want to exit?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Stay in the app
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // Exit the app
              child: Text("Exit"),
            ),
          ],
        );
      },
    ) ?? false; // If the dialog is dismissed, return false (stay in the app)
    return exitApp;
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    print(gh);
    if(gh=="ayush@fiverr.com"||gh=="niraj.bhatt612@gmail.com"||gh=="harttti@.com"){
      return WillPopScope(
          onWillPop: () => _onWillPop(context),
          child: sd(true));
    }
    return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: sd(false));
  }

  Widget adm(){
    if(_currentIndex==2){
      return All_Users();
    }if(_currentIndex==1){
      return Create_Admin();
    }
    return Home2(admin:true);
  }

  Widget sd(bool b){
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: b?adm():diu(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {

            _currentIndex=index;
            setState(() {

            });

        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_rounded),
            label: "Create",
          ),
          b?BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Users",
          ):BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        selectedItemColor: Colors.blueAccent, // Selected icon color
        unselectedItemColor: Colors.grey, // Unselected icon color
        backgroundColor: Colors.black, // Background color
      ),
    );
  }
  int _currentIndex = 0;
}
