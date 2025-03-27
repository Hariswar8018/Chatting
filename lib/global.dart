import 'package:flutter/material.dart';

class Global{
  static Color blac = Color(0xff23262B);
  static void showMessage(BuildContext context,String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(s),
        duration: Duration(seconds: 2),
      ),
    );
  }
  static Widget button(String s,double w,Color r){
    return Center(
      child: Container(
        height:45,width:w-40,
        decoration:BoxDecoration(
          borderRadius:BorderRadius.circular(7),
          color:r,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
              spreadRadius: 5, // The extent to which the shadow spreads
              blurRadius: 7, // The blur radius of the shadow
              offset: Offset(0, 3), // The position of the shadow
            ),
          ],
        ),
        child: Center(child: Text(s,style: TextStyle(
            color: Colors.black,
            fontFamily: "RobotoS",fontWeight: FontWeight.w800
        ),)),
      ),
    );
  }
}