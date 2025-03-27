import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  StoryModel({
    this.timestamp, // Now timestamp is nullable
    required this.id,
    required this.category,
    required this.public,
    required this.picture,
    required this.admin,
    required this.char1,
    required this.messages,
    required this.views,
    required this.dp,
  });

  final dynamic timestamp; // Accepts FieldValue or Timestamp
  final String id;
  final String category;
  final bool public;
  final String picture;
  final bool admin;
  final String char1;
  final List<MessageModel> messages;
  final int views;
  final String dp;

  StoryModel.fromJson(Map<String, dynamic> json)
      : timestamp = json['timestamp'],
        id = json['id'] ?? '',
  views=json['views']??0,
  dp=json['dp']??"",
        category = json['category'] ?? '',
        public = json['public'] ?? false,
        picture = json['picture'] ?? '',
        admin = json['admin'] ?? false,
        char1 = json['char1'] ?? '',
        messages = (json['messages'] as List<dynamic>?)
            ?.map((msg) => MessageModel.fromJson(msg))
            .toList() ??
            [];

  Map<String, dynamic> toJson() {
    return {
      "timestamp": timestamp, // Can be a Firestore FieldValue or a Timestamp
      "id": id,
      'views':views,
      "category": category,
      "public": public,
      "dp":dp,
      "picture": picture,
      "admin": admin,
      "char1": char1,
      "messages": messages.map((msg) => msg.toJson()).toList(),
    };
  }

  static StoryModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return StoryModel.fromJson(snapshot);
  }
}

class MessageModel {
  MessageModel({
    required this.text,
    required this.isMe,
    required this.time,
  });

  final String text;
  final bool isMe;
  final int time;

  MessageModel.fromJson(Map<String, dynamic> json)
      : text = json['text'] ?? '',
        isMe = json['isMe'] ?? false,
        time = json['time'] ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "isMe": isMe,
      "time": time,
    };
  }
}
