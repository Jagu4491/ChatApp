import 'dart:io';

import 'package:chatapp_with_firebase/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

late Size mq;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid?
      await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAiAXLD-MewGBPupBdiPOQEQfwVCjMysjw",
            appId:  "1:463163677126:android:6b68d31cf6919f966e7ac7",
            messagingSenderId: "463163677126",
            projectId:  "chat-app-ffab8"),
      ):

  //write code for full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  //for setting orientation for portrait only
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]).then((value) async{
    await Firebase.initializeApp();
    runApp(MyApp());
  });

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'hello',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade200,
          centerTitle: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black),),),
      home: SplashScreen(),
    );
  }
}





