import 'package:chatting/home/chatscreen2.dart';
import 'package:chatting/model/story.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class All_Stories extends StatelessWidget {
  String name;bool on;
  All_Stories({super.key,required this.name,this.on=false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:isDarkModeEnabled?Colors.white :Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(name+" Genere",style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: on?FirebaseFirestore.instance
              .collection("Stories")
              .where("category", isLessThanOrEqualTo: name)
              .snapshots():FirebaseFirestore.instance
              .collection("Stories")
              .where("category", isEqualTo: name)
              .where("public", isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              case ConnectionState.done:
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No stories available",style: TextStyle(color: isDarkModeEnabled?Colors.black:Colors.white),));
                }
                List<StoryModel> stories = snapshot.data!.docs.map((doc) => StoryModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
                return GridView.builder(
                  scrollDirection: Axis.vertical, // Scroll vertically
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 items per row
                    crossAxisSpacing: 8.0, // Spacing between columns
                    mainAxisSpacing: 20.0, // Spacing between rows
                    childAspectRatio: 0.7, // Adjust to maintain good card proportions
                  ),
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    StoryModel story = stories[index];
                    return InkWell(
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                          border: Border.all(
                            color: Colors.white,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(story.picture), // Use the picture from StoryModel
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                );

            }
          },
        ),
      ),
    );
  }
}
