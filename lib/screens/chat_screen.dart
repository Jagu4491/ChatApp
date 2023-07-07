import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp_with_firebase/api/api_helper.dart';
import 'package:chatapp_with_firebase/custom_widgets/message_card.dart';
import 'package:chatapp_with_firebase/models/chat_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/message_model.dart';

class ChatScreen extends StatefulWidget {
  final ChatUserModel userModel;

  ChatScreen({super.key, required this.userModel});

  @override
  State<StatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessageModel> _list = [];
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: _appBar(),
      ),
      backgroundColor: Colors.lightGreen.shade50,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: Api.getAllMessages(widget.userModel),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                //if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return SizedBox();

                //if some or all data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data!.docs;

                    _list = data
                        ?.map((e) => MessageModel.fromJson(e.data()))
                        .toList() ??
                        [];
                    /*_list.add(MessageModel(fromId: Api.user.uid, msg: 'hii', type: Type.text, toId: 'xyz', sent: '12:00 am', read: ''));
                    _list.add(MessageModel(fromId: 'uu', msg: 'hello', type: Type.text, toId: Api.user.uid, sent: '12:00am', read: ''));*/
                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          itemCount:_list.length,
                          padding: EdgeInsets.only(top: mq.height * .01),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MessageCard(messageModel: _list[index],);
                          });
                    } else {
                      return Center(
                          child: Text(
                            'Say Hello! 👋',
                            style: TextStyle(fontSize: 25),
                          ));
                    }
                }
              },
            ),
          ),
          _chatInput()
        ],
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          //back button
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                size: 30,
              )),
          //user profile picture
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .03),
            child: CachedNetworkImage(
              width: mq.height * .05,
              height: mq.height * .05,
              imageUrl: widget.userModel.Image,
              errorWidget: (context, url, error) => CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //user name
              Text(
                widget.userModel.Name,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
              //last seen time of user
              Text(
                'Last seen not show',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.height * .01),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.emoji_emotions,
                        color: Colors.green.shade200,
                        size: 30,
                      )),
                  Expanded(
                      child: TextField(
                        controller: textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            hintText: 'Type Something...',
                            hintStyle: TextStyle(
                                color: Colors.green.shade600, fontSize: 18),
                            border: InputBorder.none),
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.image,
                          color: Colors.green.shade200, size: 30)),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.green.shade200,
                        size: 30,
                      ))
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {

                Api.sendMessage(widget.userModel,textController.text.toString(),);
                //textController.text='';

            },
            minWidth: 0,
            padding: EdgeInsets.only(top: 8, bottom: 8, right: 5, left: 10),
            shape: CircleBorder(),
            color: Colors.green,
            child: Icon(
              Icons.send_rounded,
              size: 25,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
