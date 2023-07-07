import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp_with_firebase/models/chat_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget{
  final ChatUserModel userModel;

  const ChatUserCard({super.key,required this.userModel});
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
      onTap: (){
        //for Navigate to chat screen
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(userModel: widget.userModel,)));
      },
      child: ListTile(
        //leading: CircleAvatar(child: Icon(Icons.person),),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(mq.height * .3),
          child: CachedNetworkImage(
            width: mq.height * .055,
            height: mq.height * .055,
            imageUrl: widget.userModel.Image,
            fit: BoxFit.fill,
            placeholder: (context,url)=>CircularProgressIndicator(),
            errorWidget: (context,url,error)=> CircleAvatar(child: Icon(Icons.person,),),

          ),
        ),
        title: Text(widget.userModel.Name),
        subtitle: Text(widget.userModel.About,maxLines: 1,),
        trailing: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.green.shade200,
            borderRadius: BorderRadius.circular(10)
          ),
        )

      ),
    ),
  );
  }
}