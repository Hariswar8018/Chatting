import 'package:chatting/first/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class All_Users extends StatelessWidget {
  const All_Users({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("All Users",style: TextStyle(color: Colors.white,),),
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth auth = FirebaseAuth.instance;
            auth.signOut().then((res) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>Login()),
              );
            });
          }, icon: Icon(Icons.login,color: Colors.red,)),
          SizedBox(width: 10,)
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text("Coming Soon",style:TextStyle(color: Colors.white,fontSize: 19)))
        ],
      ),
    );
  }
}
