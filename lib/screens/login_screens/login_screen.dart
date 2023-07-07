import 'dart:developer';
import 'dart:io';

import 'package:chatapp_with_firebase/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../api/api_helper.dart';
import '../../helper/dialog.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_LoginScreen();

}
class _LoginScreen extends State<LoginScreen>{

  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5),(){
      setState(() {
        _isAnimate=true;
      });
    });
  }

  googleBtnClick(){
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async{
      Navigator.pop(context);
      if(user != null) {
        log('nUser:${user.user}');
        log('UserAdditionalInfo:${user.additionalUserInfo}');

        if((await Api.userExists())){
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }else{
          await Api.createUser().then((value) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          });
        }


      }

    });


  }
  Future<UserCredential?>_signInWithGoogle() async{
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser
          ?.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }catch(e){
      log('_signInWithGoogle:$e');
      Dialogs.showSnackbar(context, "Smothing Wrong! Check Internet!");

    }
  }

  @override
  Widget build(BuildContext context) {
    mq =MediaQuery.of(context).size;
  return Scaffold(
    appBar: AppBar(
      title: Text('Welcome To hello'),
    ),
    body:Stack(
      children: [
        AnimatedPositioned(
          top: mq.height*0.15,
          right: _isAnimate ? mq.width* .25:-mq.width *.5,
            duration: Duration(seconds: 1),
            width: mq.width*0.5,
            child: Image.asset('assets/images/hello.png')),
        Positioned(
          bottom: mq.height*.15,
            left: mq.width*.05,
            width: mq.width*.9,
            height: mq.height*.07,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade100,
                shape: StadiumBorder()
              ),
                onPressed: (){
                googleBtnClick();
                //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                }, icon: Image.asset('assets/images/google.png',height: mq.height*.04,), label: Text('Login with Google',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),))
        )
      ],
    ) ,
  );
  }

}