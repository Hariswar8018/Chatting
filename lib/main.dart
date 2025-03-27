import 'package:chatting/firebase_options.dart';
import 'package:chatting/first/login.dart';
import 'package:chatting/first/test.dart';
import 'package:chatting/home/home.dart';
import 'package:chatting/home/navigation.dart';
import 'package:chatting/providers/declare.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

 bool away= await asyncPrefs.getBool('night')??false;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(gett: away,),
    ),
  );
}
bool isDarkModeEnabled = false;
class MyApp extends StatelessWidget {
  bool gett;
   MyApp({super.key,required this.gett});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatting',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(color: const Color(0xFF253341)),
        scaffoldBackgroundColor: const Color(0xFF15202B),
      ),debugShowCheckedModeBanner: false,
      themeMode: isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      home: MyHomePage(title: gett),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final bool title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void initState(){
    Timer(Duration(seconds: 3), () async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        print("Going...................90");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Login()));

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Image(
            image: AssetImage('assets/33bfe9ad-805b-405f-90f1-584e3c2f5fc6.jpeg'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
