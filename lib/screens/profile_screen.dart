import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp_with_firebase/api/api_helper.dart';
import 'package:chatapp_with_firebase/helper/dialog.dart';
import 'package:chatapp_with_firebase/models/chat_user_model.dart';
import 'package:chatapp_with_firebase/screens/login_screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

class ProfileScreen extends StatefulWidget{
  final ChatUserModel userModel;
  ProfileScreen({super.key,required this.userModel});
  @override
  State<StatefulWidget> createState()=>_ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // using this line click any one keyboard is hiding
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile Screen'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(width: mq.width,height: mq.height * .03,),
                  Stack(
                    children: [
                      //profile picture
                      _image != null ?
                      //local image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .1),
                        child: Image.file(File(_image!),
                          width: mq.height * .2,
                          height: mq.height * .2,
                          fit: BoxFit.cover,
                        ),
                      )
                      :
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .1),
                        child: CachedNetworkImage(
                          width: mq.height * .2,
                          height: mq.height * .2,
                          fit: BoxFit.cover,
                          imageUrl: widget.userModel.Image,
                          errorWidget: (context,url,error)=>CircleAvatar(child: Icon(Icons.person),),
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: (){
                            _showBottomSheet();
                          },
                          shape: CircleBorder(),
                          color: Colors.white,
                          child: Icon(Icons.edit,color: Colors.blue,),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: mq.height * .03,),
                  Text(widget.userModel.Email,style: TextStyle(fontSize: 18,color: Colors.black54),),
                  SizedBox(width: mq.width,height: mq.height * .05,),
                  TextFormField(
                    initialValue: widget.userModel.Name,
                    onSaved: (val) => Api.me.Name = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty ? null :'Required Field',
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      hintText: 'eg.Nayan Sharma',
                      label: Text('Name')
                    ),
                  ),
                  SizedBox(height: mq.height * .02,),
                  TextFormField(
                    initialValue: widget.userModel.About,
                    onSaved: (val) => Api.me.About = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.info_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        hintText: 'eg.Fellings Happy',
                        label: Text('About')
                    ),
                  ),
                  SizedBox(height: mq.height * .05,),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                        minimumSize: Size(mq.width * .5, mq.height * .06)),
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        _formKey.currentState!.save();
                        Api.updateUserInfo().then((value){
                          Dialogs.showSnackbar(context, 'Profile Updated Successfully!');
                        });
                        log('inside validator');
                      }
                    },
                    icon: Icon(Icons.login,size: 28,),
                    label: Text('UPDATE',style: TextStyle(fontSize: 18),),
                  )


                ],
              ),
            ),
          ),
        ),
        //floating button to add new user
        floatingActionButton:FloatingActionButton.extended(
          backgroundColor: Colors.redAccent,
          onPressed: () async{
            //for showing progress dialog
            Dialogs.showProgressBar(context);

            //sign out from app
            await Api.auth.signOut().then((value) async{
              await GoogleSignIn().signOut().then((value) {

                //for hiding progress dialog
                Navigator.pop(context);

                //for moving to home screen
                Navigator.pop(context);

                //replacing home screen with login screen
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
              });
            });

          },
          icon: Icon(Icons.logout),
          label: Text('Logout'),

        ),
      ),
    );
  }

  // bottom sheet function  for picking a profile picture for user
void _showBottomSheet(){
    showModalBottomSheet(
      backgroundColor: Colors.green.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
        context: context,
        builder: (context){

      return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: mq.height * .03,bottom: mq.height * .05),
        children: [
          Text('Pick Profile Picture',textAlign: TextAlign.center,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500),),
          SizedBox(height: mq.height * .03,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: CircleBorder(),
                  fixedSize: Size(mq.width * .3, mq.height * .15)
                ),
                  onPressed: () async{
                  final ImagePicker picker = ImagePicker();
                  //pick an image

                  final XFile? image = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
                  if(image != null){
                    log('Image path:${image.path}--MimeType:${image.mimeType}');
                    setState(() {
                      _image = image.path;
                    });
                    Api.updateProfilePicture(File(_image!));
                    Navigator.pop(context);

                  }
                  },
                  child:Image.asset('assets/images/gallery.png') ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: CircleBorder(),
                      fixedSize: Size(mq.width * .3, mq.height * .15)
                  ),
                  onPressed: () async{
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 80);
                    if(image != null){
                      log('Image path: ${image.path}');
                      setState(() {
                        _image = image.path;
                      });
                      Api.updateProfilePicture(File(_image!));
                      Navigator.pop(context);
                    }

                  },
                  child:Image.asset('assets/images/camera.png') )
            ],
          )
        ],
      );

        });
}

}