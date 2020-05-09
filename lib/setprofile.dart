
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hellogram/headerappbar.dart';
import 'package:hellogram/loginpage.dart';
import 'package:hellogram/services/usermanagement.dart';
import 'package:hellogram/timeline.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Setprofilepage extends StatefulWidget{
  @override
  SetprofilepageState createState() => SetprofilepageState();
}

class SetprofilepageState extends State<Setprofilepage>{

  File tempimg;
  String Username;

  getimg()async{
    var getimage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      tempimg = getimage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: header(context,pagetitle: 'Set Profile'),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
           // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  tempimg==null?Container(height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('images/mountain.jfif'),
                    fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(100.0),

                  ),):
                  Container(height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: FileImage(tempimg),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(100.0),

                    ),),
                  Positioned(
                    right: 10.0,
                    top: 140,
                    child: MaterialButton(onPressed: (){
                      getimg();
                      },
                      height: 60.0,
                      minWidth: 60.0,
                      child: Icon(Icons.edit,color: Colors.white,size: 30.0,),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      color: Colors.blue,
                      elevation: 6.0,

                    ),

                  )
                ],
              ),
              SizedBox(height: 50,),
              TextField(

                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.person_outline,color: Colors.black,size: 30.0,),
                  hintText: 'Username',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 20.0,
                  )
                ),
                onChanged: (value){
                  Username = value;
                },
              ),
              SizedBox(height: 30,),

              //tempimg==null?Image(image: AssetImage('images/mountain.jfif'),height: 200,width: 200,):Image.file(tempimg,height: 200,width: 200,),
              RaisedButton(
                onPressed: ()async{
                  var user =await  FirebaseAuth.instance.currentUser();
                  StorageReference picref = FirebaseStorage.instance.ref().child('userprofilepic/${user.uid}.jpg');
                  StorageUploadTask task = picref.putFile(tempimg);
                  var url = await (await task.onComplete).ref.getDownloadURL();
                  Usermanagement().updateuserprofile(url,Username);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MyLoginPage()));
                },
                child: Text('Upload',style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0
                ),),
                color: Colors.blue,

              )
            ],
          ),
        ),
      ),
    );
  }

}