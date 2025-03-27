import 'dart:typed_data';

import 'package:chatting/global.dart';
import 'package:chatting/home/chatscreen2.dart';
import 'package:chatting/home/create.dart';
import 'package:chatting/home/second/all_stories.dart';
import 'package:chatting/home/setting.dart';
import 'package:chatting/home/story.dart';
import 'package:chatting/model/story.dart';
import 'package:chatting/providers/declare.dart';
import 'package:chatting/providers/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class Home2 extends StatefulWidget {
  bool admin;
 Home2({super.key,required this.admin});

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  TextEditingController text=TextEditingController();

 final CarouselSliderController _controller = CarouselSliderController();

 void initState(){
   fetchImages();
   dr();
 }
void dr()async{
  UserProvider _userprovider = Provider.of(context, listen: false);
  await _userprovider.refreshuser();
}
  late List<String> images = [];
  Future<void> fetchImages() async {
    try {
      final DocumentSnapshot documentSnapshot =  await FirebaseFirestore.instance.collection('Users')
          .doc('Admin')
          .get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        List<String> fetchedImages = List<String>.from(data['images'] ?? []);
        setState(() {
          images = fetchedImages;
        });
      }
    } catch (e) {
      print('Error fetching images: $e');
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
  Future<void> deleteImage(String imageUrl) async {
    try {
      setState(() {
        images.remove(imageUrl); // Remove from local list
      });
      await FirebaseFirestore.instance.collection('Users')
          .doc('Admin').update({
        'images': images,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Image deleted successfully!'),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:isDarkModeEnabled?Colors.white: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Container(
          width: w-15,height: 45,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10,bottom: 6.0,top: 9,right: 12),
            child: TextFormField(
              controller: text,
              decoration: InputDecoration(
                hintText:" Type your Genere",
                prefixIcon: Icon(Icons.search,color: Colors.blue,),
                border: InputBorder.none
              ),
              onFieldSubmitted: (String s){
                Navigator.push(
                    context, PageTransition(
                    child: All_Stories(name: s,on:true), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                ));
              },
              onSaved: ( str){
                String s=str??"None Genere typed";
                Navigator.push(
                    context, PageTransition(
                    child: All_Stories(name: s,on:true), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                ));
            },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                images.isNotEmpty?CarouselSlider(
                    controller: _controller,
                    items: images.map((imageUrl) {
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              height: 360,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent, // Fully transparent at the top
                                    isDarkModeEnabled?Colors.white:Colors.black.withOpacity(1), // Darker at the bottom
                                  ],
                                ),
                              ),
                            ),
                          ),
                          widget.admin?Positioned(
                            top: 100,
                            right: 5,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteImage(imageUrl),
                            ),
                          ):Positioned(
                              top: 100,
                              right: 5,
                              child: SizedBox(width: 1,)),
                        ],
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 360,
                      aspectRatio: 16/9,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 400),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.5,
                      scrollDirection: Axis.horizontal,
                    )
                ): Container(
                  width: MediaQuery.of(context).size.width,
                  height: 360,
                  color: Colors.black,
                  child: Center(
                    child: Text("No Images uploaded",style: TextStyle(color: Colors.white),),
                  ),
                ),
                Positioned(
                    top: 90,left: 25,
                    child: Text("Trending",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),))
              ],
            ),
            widget.admin?InkWell(
                onTap: () async {
                  try {
                    Uint8List? _file = await pickImage(ImageSource.gallery);
                    if (_file == null) return;
                    String photoUrl = await StorageMethods()
                        .uploadImageToStorage('admin', _file, true);
                    setState(() {
                      images=[photoUrl]+images;
                    });
                    await FirebaseFirestore.instance.collection('Users')
                        .doc('Admin')
                        .set({
                      "images": images,
                    });
                    Global.showMessage(context, "Uploaded !");
                  }catch(e){
                    Global.showMessage(context, "$e");
                  }
                },
                child: Global.button("Upload Picture", w, Colors.blue)):SizedBox(),
            SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ...Iterable<int>.generate(imgList.length).map(
                      (int pageIndex) => Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:isDarkModeEnabled?Colors.black: Colors.white,
                          ),
                          width: 8,height: 8,
                        ),
                      ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            fgiop(w, "Billionaire"),
            fgiop(w, "Romance"),
            fgiop(w, "Horror"),
            fgiop(w, "Fantasy"),
            fgiop(w, "Thriller"),
          ],
        ),
      ),
    );
  }
  Widget fgiop(double w,String str){
   return Container(
     width: w,
     child: Column(
       children: [
         Row(
           children: [
             ty(str),
             Spacer(),
             InkWell(
                 onTap: (){
                   Navigator.push(
                       context, PageTransition(
                       child: All_Stories(name: str), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                   ));
                 },
                 child: t()),
           ],
         ),
         SizedBox(height: 9,),
         StreamBuilder(
           stream: FirebaseFirestore.instance
               .collection("Stories")
               .where("category", isEqualTo: str)
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
                   return Center(child: Text("No stories available"));
                 }
                 List<StoryModel> stories = snapshot.data!.docs
                     .map((doc) => StoryModel.fromJson(doc.data() as Map<String, dynamic>))
                     .toList();
                 return Container(
                   width:w,height:220,
                   child: ListView.builder(
                     scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                     itemCount: stories.length,
                     itemBuilder: (context, index) {
                       StoryModel story = stories[index];
                       return Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adds spacing
                         child: InkWell(
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
                           child: Column(
                             children: [
                               Container(
                                 width: 130,
                                 height: 180,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(12), // Rounded corners
                                   border: Border.all(
                                     color: isDarkModeEnabled?Colors.black:Colors.white,
                                   ),
                                   image: DecorationImage(
                                     image: NetworkImage(story.picture), // Use the picture from StoryModel
                                     fit: BoxFit.cover,
                                   ),
                                 ),
                                 child:
                                 widget.admin?Column(children: [
                                   Spacer(),
                                   Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: IconButton(onPressed: ()async{
                                         showDialog(
                                           context: context,
                                           builder: (BuildContext context) {
                                             return AlertDialog(
                                               title: Text("Delete"),
                                               content: Text("Are you sure you want to delete?"),
                                               actions: [
                                                 TextButton(
                                                   onPressed: () {
                                                     Navigator.pop(context); // Close dialog
                                                   },
                                                   child: Text("Cancel"),
                                                 ),
                                                 TextButton(
                                                   onPressed: () async {
                                                     Navigator.pop(context);
                                                     await FirebaseFirestore.instance
                                                         .collection("Stories").doc(story.id).delete();
                                                     // Add your action here
                                                   },
                                                   child: Text("OK"),
                                                 ),
                                               ],
                                             );
                                           },
                                         );

                                     }, icon: Icon(Icons.delete,color:Colors.red)),
                                   )
                                 ],):SizedBox(),
                               ),
                               Container(
                                 width: 130,
                                 height: 30,
                                 child: Row(
                                   children: [
                                     SizedBox(width: 9,),
                                     Icon(Icons.remove_red_eye,color: Colors.white,),
                                     Text(" Views : ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                     SizedBox(width: 9,),
                                     Container(
                                       child: Text(story.views.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
                                     ),
                                   ],
                                 ),
                               )
                             ],
                           ),
                         ),
                       );
                     },
                   ),
                 );
             }
           },
         ),
         SizedBox(height: 14,),
       ],
     ),
   );
  }
  TextEditingController mainpic=TextEditingController();
  Widget fg(TextEditingController ha, String str, String str2) => TextFormField(
    controller: ha,
    keyboardType: TextInputType.text,
    style: TextStyle(color: Colors.white), // ✅ Makes typed text white
    decoration: InputDecoration(
      labelText: str,
      labelStyle: TextStyle(color: Colors.white), // ✅ Makes label text white
      hintText: str2,
      hintStyle: TextStyle(color: Colors.white70), // ✅ Makes hint text white with slight opacity
      isDense: true,

    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Please type It';
      }
      return null;
    },
  );
 int _currentIndex = 0;
 // Track selected tab
  List<String> list=[
    "https://images-cdn.ubuy.co.in/668f03f763dc6918441092c0-avengers-infinity-war-movie-poster.jpg",
    "https://i.ebayimg.com/images/g/v3oAAOSwulViCEyE/s-l400.jpg",
    "https://cdn.prod.website-files.com/6009ec8cda7f305645c9d91b/66a4263d01a185d5ea22eeec_6408f6e7b5811271dc883aa8_batman-min.png",
    "https://insessionfilm.com/wp-content/uploads/2022/09/Screen-Shot-2022-09-26-at-7.13.09-AM.png",
  ];

 List<String> romance=[
   "https://i.pinimg.com/736x/b9/c9/e1/b9c9e1bd2ba7c82680e92a28251470bd.jpg",
   "https://www.yourfilmposter.com/cdn/shop/products/ourjourney_dbae58a7-4115-40be-b6a1-cb6f111427c4_314x.webp?v=1736341312",
   "https://intheposter.com/cdn/shop/products/the-perfect-match-in-the-poster-1_2000x.jpg?v=1733910571",
   'https://cdn.shopify.com/s/files/1/1083/5290/collections/Fault_in_Our_Stars_-_Romance_RP13495.jpg?v=1453448429',
   "https://images.bauerhosting.com/legacy/empire-legacy/uploaded/backtoback5.jpg?auto=format&w=1440&q=80",

 ];

 List<String> horror=[
   "https://www.filmsourcing.com/wp-content/uploads/2013/02/horror521.jpg",
   "https://3.bp.blogspot.com/-dUZf4g4ITik/UfZmxVBj8uI/AAAAAAAAHJA/KiXMgr_aI_0/s1600/The+Conjuring+movie+poster+large+malaysia.jpg",
  "https://99designs-blog.imgix.net/blog/wp-content/uploads/2016/10/Dont-Speak.jpg?auto=format&q=60&fit=max&w=930"
   "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSR0FBzVwmipi5J1hNX1iJ6gn8uUk37kAoexyIS5SX_Vp33Pb4G6iSl1LdFi2goZcrjJtQ&usqp=CAU",
"https://cdn.venngage.com/template/thumbnail/full/c1ba1d83-13ee-4fab-a7fe-3592b113c90e.webp",
 ];

  Widget ty(String str){
    return Text("  "+str,style: TextStyle(color: isDarkModeEnabled?Colors.black:Colors.white,fontSize: 18,fontWeight: FontWeight.w700,letterSpacing: 1.2),);
  }

 Widget t(){
   return Text("Show More"+"  ",style: TextStyle(color: Colors.blueAccent,fontSize: 11,fontWeight: FontWeight.w400),);
 }

 Widget d(double w, String text, String url) => Container(
   width: w,
   height: 360,
   child: Stack(
     children: [
       // Background Image
       Positioned.fill(
         child: Image.network(
           url,
           fit: BoxFit.cover,
         ),
       ),
       Positioned.fill(
         child: Container(
           decoration: BoxDecoration(
             gradient: LinearGradient(
               begin: Alignment.topCenter,
               end: Alignment.bottomCenter,
               colors: [
                 Colors.transparent, // Fully transparent at the top
                 Colors.black.withOpacity(1), // Darker at the bottom
               ],
             ),
           ),
         ),
       ),
       // Text Overlay
       Align(
         alignment: Alignment.bottomCenter,
         child: Padding(
           padding: const EdgeInsets.all(16.0),
           child: Padding(
             padding: const EdgeInsets.only(left: 15,right: 15),
             child: Text(
               text,
               style: TextStyle(
                 color: Colors.white,
                 fontWeight: FontWeight.w600,
                 fontSize: 20,
                 letterSpacing: 1,height: 0.9
               ),
               textAlign: TextAlign.center,
             ),
           ),
         ),
       ),
     ],
   ),
 );
}
