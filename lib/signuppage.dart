import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hellogram/setprofile.dart';

class MySignUpPage extends StatefulWidget{
  @override
  MySignUpPageState createState() => MySignUpPageState();
}

class MySignUpPageState extends State<MySignUpPage>{

  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  )
              ),
              onChanged: (value){
                _email = value;
              },
            ),
            SizedBox(height: 10.0,),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  )
              ),
              onChanged: (value){
                _password = value;
              },
            ),
            SizedBox(height: 10.0,),
            RaisedButton(
              color: Colors.blue,
              child: Text('Sign Up'),
              onPressed: (){

                FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password).then((val){
                  FirebaseAuth.instance.currentUser().then((FirebaseUser user){
                    Firestore.instance.collection('users').document(user.uid).setData({
                      'email': user.email,
                      'uid': user.uid,
                      'profilepic': 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.facebook.com%2FProfilePictures%2F&psig=AOvVaw3CCgx4r32qAVDD13_m3RsA&ust=1586954679753000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCPiu44P55-gCFQAAAAAdAAAAABAD',
                      'username': 'username',
                      'userkey': 'u',
                    }).then((value){
                   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Setprofilepage()));
                });
                  });
                });

//                FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password).then((user){
//                  Firestore.instance.collection('/users').add({
//                    'email': user.user.email,
//                    'uid': user.user.uid,
//                    'profilepic': 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.facebook.com%2FProfilePictures%2F&psig=AOvVaw3CCgx4r32qAVDD13_m3RsA&ust=1586954679753000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCPiu44P55-gCFQAAAAAdAAAAABAD',
//                    'username': 'username'
//                  }).then((value){
//                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Setprofilepage()));
//                  });
//                });


              },
            )
          ],
        )
    );
  }

}