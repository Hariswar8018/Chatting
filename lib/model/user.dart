import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.name,
    required this.email,
    required this.position,
    required this.no,
    required this.uid,
    required this.pic,
    required this.school,
    required this.other1,
    required this.other2,
  });

  late final String name;
  late final String email;
  late final String position;
  late final int no;
  late final String uid;
  late final String pic;
  late final String school;
  late final String other1;
  late final String other2;

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    position = json['position'] ?? '';
    no = json['no'] ?? 0;
    uid = json['uid'] ?? '';
    pic = json['pic'] ?? '';
    school = json['school'] ?? '';
    other1 = json['other1'] ?? '';
    other2 = json['other2'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['position'] = position;
    data['no'] = no;
    data['uid'] = uid;
    data['pic'] = pic;
    data['school'] = school;
    data['other1'] = other1;
    data['other2'] = other2;
    return data;
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel.fromJson(snapshot);
  }
}
