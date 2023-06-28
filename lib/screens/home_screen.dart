import 'dart:developer';

import 'package:chatapp_with_firebase/api/api_helper.dart';
import 'package:chatapp_with_firebase/custom_widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: Text('hello'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))
        ],
      ),
      body: StreamBuilder(
        stream: Api.firestore.collection('users').snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            final data = snapshot.data!.docs;
            for(var i in data!){
              log('Data: ${i.data()}');
            }
          }
          return ListView.builder(
              itemCount: 1,
              padding: EdgeInsets.only(top: mq.height * .01),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context,index){
                return ChatUserCard();
              });
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Api.auth.signOut();
          await GoogleSignIn().signIn();

        },
        child: Icon(Icons.messenger),

      ),
    );
  }
}
