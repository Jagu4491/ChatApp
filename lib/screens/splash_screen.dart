import 'dart:developer';

import 'package:chatapp_with_firebase/api/api_helper.dart';
import 'package:chatapp_with_firebase/screens/home_screen.dart';
import 'package:chatapp_with_firebase/screens/login_screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_SplashScreenState();

}
class _SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2),(){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent)
      );
      if(Api.auth.currentUser != null){
        log('nUser:${Api.auth.currentUser}');

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      }

    });
  }
  @override
  Widget build(BuildContext context) {
    mq =MediaQuery.of(context).size;
   return Scaffold(
     body: Stack(
       children: [
         Positioned(
           top: mq.height*.15,
             right: mq.width*.25,
             width: mq.width*.5,
             child: Image.asset('assets/images/hello.png'), ),
     Positioned(
       bottom: mq.height*.15,
       width: mq.width,
       child: Text('Happy With My Chat App 😀',textAlign: TextAlign.center,style: TextStyle(fontSize: 18,color: Colors.blueGrey),),
     )
       ],
     ),
   );
  }

}