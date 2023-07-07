import 'package:chatapp_with_firebase/api/api_helper.dart';
import 'package:chatapp_with_firebase/models/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class MessageCard extends StatefulWidget{
  final MessageModel messageModel;
  MessageCard({super.key,required this.messageModel});
  @override
  State<StatefulWidget> createState()=>_MessageCardState();
}
class _MessageCardState extends State<MessageCard>{
  @override
  Widget build(BuildContext context) {
    return Api.user.uid == widget.messageModel.fromId ? _greenMessage():_blueMessage();
  }

  //sender or another user message
  Widget _blueMessage(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(mq.width * .04),
          margin: EdgeInsets.symmetric(horizontal: mq.width * .04,vertical: mq.height * .01),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.lightBlue,width: 2),
              color: Colors.lightBlue.shade50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30)
              )),
          child: Text(widget.messageModel.msg,style: TextStyle(fontSize: 18),),
        ),
        Padding(
          padding: EdgeInsets.only(left: mq.width * .04),
          child: Text(widget.messageModel.sent,style: TextStyle(fontSize: 14,color: Colors.black54),),
        )
      ],
    );
  }
  //our or user message
  Widget _greenMessage(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(mq.width * .04),
          margin: EdgeInsets.symmetric(horizontal: mq.width * .04,vertical: mq.height * .01),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green,width: 2),
              color: Colors.green.shade50,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)
              )),
          child: Text(widget.messageModel.msg,style: TextStyle(fontSize: 18),),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('${widget.messageModel.read}12:00 am',style: TextStyle(fontSize: 14,color: Colors.black54),),
            SizedBox(width: 3,),
            Padding(
              padding: EdgeInsets.only(right: mq.width * .03),
              child: Icon(Icons.done_all_rounded,color: Colors.blue,size: 20,),
            )
          ],
        )
      ],
    );
}


}