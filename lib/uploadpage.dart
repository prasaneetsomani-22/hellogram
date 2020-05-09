import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hellogram/loginpage.dart';
import 'package:hellogram/services/usermanagement.dart';
import 'package:hellogram/timeline.dart';
import 'package:image_picker/image_picker.dart';

class Upload extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UploadState();
  }

}

class UploadState extends State<Upload>{
  
  File tempimg;
  var postId = Uuid().v4();

  getimage() async{
    var getimg = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      tempimg = getimg;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle:true,
        backgroundColor: Colors.black,
        title: Text('New Post',style: TextStyle(color: Colors.white,),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            setState(() {
              tempimg = null;
            });
          },
        ),

      ),
        body: tempimg==null? Center(child: Text('Select Image',style: TextStyle(color: Colors.white),),): Column(
          children: <Widget>[
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(tempimg),
                  fit: BoxFit.cover,
                )
              ),
            ),
            SizedBox(height: 30.0,),
            RaisedButton(
                child: Text('Upload'),
                color: Colors.blue,
                onPressed: ()async{
              var imgurl =  await Usermanagement().storage(tempimg);
              FirebaseAuth.instance.currentUser().then((user){
                Firestore.instance.collection('users').document(user.uid).collection('posts').document(postId).setData({
                    'posturl': imgurl.toString(),
                    'likes': '',
                    'uid':user.uid,
                    'postId':postId
                  }).then((value){
                    Firestore.instance.collection('/timelineposts').add({
                      'timelinposturl': imgurl.toString(),
                      'posteduserprofile':user.photoUrl,
                      'postedusername': user.displayName,
                      'likes': '',
                      'uid':user.uid,
                      'postId':postId
                    }).then((val){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyLoginPage()));

                    });
                  });
                });


            })
          ]
    ),
        floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
      onPressed: (){
        getimage();
      },
    ),


    );
  }

}