import 'dart:convert';
import 'dart:developer';

import 'package:chatapp_with_firebase/api/api_helper.dart';
import 'package:chatapp_with_firebase/custom_widgets/chat_user_card.dart';
import 'package:chatapp_with_firebase/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';
import '../models/chat_user_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//for storing all users
  List<ChatUserModel> _list = [];

  //for stroring searched items
  final List<ChatUserModel> _searchList =[];

  //for stroring search status
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    Api.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard when tap is detected on screen
      onTap: ()=>FocusScope.of(context).unfocus(),
      //if search is on & back is pressed then close search
      //oe else simple close current screen on back button click
      child: WillPopScope(
        onWillPop: (){
          if(_isSearching){
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          }else{
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(CupertinoIcons.home),
            title: _isSearching ? TextField(
              decoration: InputDecoration(border: InputBorder.none,
                hintText: 'Name,Email,...'
              ),
              autofocus: true,
              style: TextStyle(fontSize: 18,letterSpacing: 0.5),
              //when search text change the update search list
              onChanged: (val){
                //search logic
                _searchList.clear();
                for(var i in _list){
                  if(i.Name.toLowerCase().contains(val.toLowerCase()) ||
                      i.Email.toLowerCase().contains(val.toLowerCase())){
                    _searchList.add(i);
                  }
                  setState(() {
                    _searchList;
                  });
                }

              },
            ) : Text('hello'),
            actions: [
              IconButton(onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });

              }, icon: Icon(_isSearching ? CupertinoIcons.clear_circled_solid : Icons.search)),
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen(userModel: Api.me,)));
              }, icon: Icon(Icons.more_vert))
            ],
          ),
          body: StreamBuilder(
            stream: Api.getAllUsers(),
            builder: (context,snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(child: const CircularProgressIndicator());
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data!.docs;
                  _list = data!.map((e) => ChatUserModel.fromJson(e.data())).toList() ?? [];
                    if(_list.isNotEmpty){
                      return ListView.builder(
                          itemCount: _isSearching ? _searchList.length : _list.length,
                          padding: EdgeInsets.only(top: mq.height * .01),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ChatUserCard(userModel: _isSearching ? _searchList[index] : _list[index]);
                          });
                    }else{
                      return Center(child: Text('No Connection Found!',style: TextStyle(fontSize: 25),));
                    }

              }
            }
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green.shade200,
            onPressed: () async{
              await Api.auth.signOut();
              await GoogleSignIn().signIn();

            },
            child: Icon(Icons.messenger),

          ),
        ),
      ),
    );
  }
}
