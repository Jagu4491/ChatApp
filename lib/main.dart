import 'package:chatapp_with_firebase/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

late Size mq;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

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





