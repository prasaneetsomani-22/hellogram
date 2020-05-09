

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hellogram/headerappbar.dart';
import 'package:hellogram/loginpage.dart';
import 'package:hellogram/models/userposts.dart';
import 'package:hellogram/services/usermanagement.dart';


class Profile extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileState();
  }

}

class ProfileState extends State<Profile> {

  String profilepic;
  String username;
  QuerySnapshot posts;
  List<Userposts> userposts = [];
  int postcount = 0;




  @override
  void initState(){
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      Usermanagement().getuserposts(user.displayName).then((results) {
        setState(() {
          profilepic = user.photoUrl;
          username = user.displayName;
          posts = results;
          postcount = posts.documents.length;
        });
      });
    });
  }



  List<Userposts> getpostslist(){

     return posts.documents.map((doc)=>Userposts(doc.data['postedusername'],
      doc.data['posteduserprofile'],
      doc.data['postId'],
      doc.data['timelinposturl'],
      doc.data['uid'],
      doc.data['likes'],)).toList();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle:true,
          title: Text('Profile',style: TextStyle(color: Colors.white),),
          actions: <Widget>[

           Center(
             child: GestureDetector(
               child: Text('Sign Out',style: TextStyle(color: Colors.white),),
               onTap: (){
                 FirebaseAuth.instance.signOut().then((value){
                   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MyLoginPage()));
                 });
               },
             ),
           )
          ],
        ),
        body: ListView(
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: profilepic == null?AssetImage('images/mountain.jfif'):NetworkImage(profilepic),
                    radius: 60,
                  ),
                  SizedBox(width: 50,),
                  Column(
                    children: <Widget>[
                      Text(username!=null?username:'username',
                        style: TextStyle(fontSize: 30.0, color: Colors.white),),
                      SizedBox(height: 20,),
                      Center(
                        child: Column(
                          children: <Widget>[
                            Text('Posts', style: TextStyle(color: Colors.white,
                                fontSize: 20),),
                            SizedBox(height: 5,),
                            Text('$postcount', style: TextStyle(color: Colors.white,
                                fontSize: 20))
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  padding: EdgeInsets.all(8.0),
                  child: Text('Edit profile', textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20),),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white,
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                ),
              ),
            ),
            posts == null?
              Center(child: Text('Loading...',style: TextStyle(color: Colors.white),),):
            Column(
              children: displayposts(),
            )

          ],
        )
    );
  }
   List<Container> displayposts(){
    List<Container> profileposts = [];
    getpostslist().forEach((eachpost) {
      profileposts.add(Container(
        padding: EdgeInsets.all(10.0),
        height: 500.0,
        width: 400,
        decoration: BoxDecoration(

        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      eachpost.posteduserprofile),
                ),
                SizedBox(width: 15.0,),
                Text(eachpost.postedusername, style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),)
              ],
            ),
            SizedBox(height: 15.0,),
            Container(
              padding: EdgeInsets.all(5.0), width: 400,
              height: 320,
              decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(
                      eachpost.timelinposturl),
                      fit: BoxFit.cover)

              ),
            ),
            SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: <Widget>[
                IconButton(icon: Icon(Icons.favorite),
                    color: Colors.white,
                    iconSize: 35,
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {
//                                  Firestore.instance.collection('users')
//                                      .document(
//                                      snapshots.data.documents[0].data['uid'])
//                                      .collection('posts')
//                                      .document(snapshots.data.documents[0]
//                                      .data['postId'])
//                                      .updateData({'likes': 'liked'});
//                                }),
                    }),
                IconButton(icon: Icon(Icons.comment),
                    color: Colors.white,
                    iconSize: 35,
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {}),
                IconButton(icon: Icon(Icons.send),
                    color: Colors.white,
                    iconSize: 35,
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {}),

              ],
            ),
            Text('likes',
              style: TextStyle(color: Colors.white),)
          ],
        ),
      )
      );
    }
    );
    return profileposts;
  }

//    Widget Postcard(document) {
//      if (posts != null) {
//        return StreamBuilder(
//          stream: posts,
//          builder: (context, snapshots) {
//            return ListView.builder(
//                itemCount: snapshots.data.documents.length,
//                itemBuilder: (context, i) {
//                  return Container(
//                    padding: EdgeInsets.all(10.0),
//                    height: 500.0,
//                    width: 400,
//                    decoration: BoxDecoration(
//
//                    ),
//
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      children: <Widget>[
//                        Row(
//                          children: <Widget>[
//                            CircleAvatar(
//                              backgroundImage: NetworkImage(
//                                  snapshots.data.documents[i]
//                                      .data['posteduserprofile']),
//                            ),
//                            SizedBox(width: 15.0,),
//                            Text(snapshots.data.documents[i]
//                                .data['postedusername'], style: TextStyle(
//                              color: Colors.white,
//                              fontSize: 20.0,
//                              fontWeight: FontWeight.bold,
//                            ),)
//                          ],
//                        ),
//                        SizedBox(height: 15.0,),
//                        Container(
//                          padding: EdgeInsets.all(5.0), width: 400,
//                          height: 320,
//                          decoration: BoxDecoration(
//                              image: DecorationImage(image: NetworkImage(
//                                  snapshots.data.documents[i]
//                                      .data['timelinposturl']),
//                                  fit: BoxFit.cover)
//
//                          ),
//                        ),
//                        SizedBox(height: 20.0,),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.start,
//
//                          children: <Widget>[
//                            IconButton(icon: Icon(Icons.favorite),
//                                color: Colors.white,
//                                iconSize: 35,
//                                padding: EdgeInsets.all(0.0),
//                                onPressed: () {
//                                  Firestore.instance.collection('users')
//                                      .document(
//                                      snapshots.data.documents[0].data['uid'])
//                                      .collection('posts')
//                                      .document(snapshots.data.documents[0]
//                                      .data['postId'])
//                                      .updateData({'likes': 'liked'});
//                                }),
//                                }),
//                            IconButton(icon: Icon(Icons.comment),
//                                color: Colors.white,
//                                iconSize: 35,
//                                padding: EdgeInsets.all(0.0),
//                                onPressed: () {}),
//                            IconButton(icon: Icon(Icons.send),
//                                color: Colors.white,
//                                iconSize: 35,
//                                padding: EdgeInsets.all(0.0),
//                                onPressed: () {}),
//
//                          ],
//                        ),
//                        Text('${snapshots.data.documents[0]
//                            .data['postlikes']}  likes',
//                          style: TextStyle(color: Colors.white),)
//                      ],
//                    ),
//                  );
//                }
//            );
//          },
//        );
//      }
//      else {
//        return Center(
//            child: Text('Loading Please wait......',
//              style: TextStyle(color: Colors.white),)
//        );
//      }
//    }
 }


