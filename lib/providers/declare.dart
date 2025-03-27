
import 'package:chatting/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get getUser => _user;

  Future<void> refreshuser() async {
    UserModel user = await GetUser();
    _user = user;
    notifyListeners();
  }

  Future<UserModel> GetUser() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    print(snap);
    print(UserModel.fromSnap(snap).email);
    return UserModel.fromSnap(snap);
  }
}
