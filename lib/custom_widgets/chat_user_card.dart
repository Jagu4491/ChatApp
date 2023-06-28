import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ChatUserCard extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard>{
  @override
  Widget build(BuildContext context) {
  return Card(
    margin: EdgeInsets.symmetric(horizontal: mq.width * .04,vertical: 4
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 0.5,
    child: InkWell(
      onTap: (){},
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text('Demo user'),
        subtitle: Text('my last message',maxLines: 1,),
        trailing: Text('12:pm'),

      ),
    ),
  );
  }
}