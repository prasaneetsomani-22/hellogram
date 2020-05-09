import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hellogram/headerappbar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hellogram/loginpage.dart';
import 'package:hellogram/services/usermanagement.dart';
import 'photowidget.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();


class Timeline extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TimelineState();
  }

}

class TimelineState extends State<Timeline> {

  Stream posts;
  bool isliked = false;


  @override
  void initState() {
//    Usermanagement().getposts().then((results){
//      setState(() {
//        posts = results;
//      });
//    });
    // TODO: implement initState
    super.initState();
  }

   isLiked(postId){
    var k =0;
    FirebaseAuth.instance.currentUser().then((FirebaseUser user){
      Firestore.instance.collection('feedactivity').where('postId',isEqualTo: postId).getDocuments().then((docs){
        for(int i = 0;i< docs.documents[0].data['likes'].length; ++i){
          if(user.displayName == docs.documents[0].data['likes'][i]){
            k = 1;
            break;
          }
        }

      });
    });
    if( k==1){
      return true;
    }
    else{
      return false;
    }
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: header(context, isApptitle: true),
        //body: Image(image: firestore.collection("hellogram").document['posts']),
        body: StreamBuilder(
            stream: Firestore.instance.collection('timelineposts').snapshots(),
            builder: (context,snapshots){
              if(snapshots.data == null){
                return Center(child: Text('Loading Please wait.....',style: TextStyle(color: Colors.white),));
              }
              else{
              return ListView.builder(
                  itemCount: snapshots.data.documents.length,
                  itemBuilder: (context,i){
                    return Container(
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
                            snapshots.data.documents[i]
                            .data['posteduserprofile']),
                          ),
                          SizedBox(width: 15.0,),
                          Text(snapshots.data.documents[i]
                          .data['postedusername'], style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          ),)
                          ],
                          ),
                          SizedBox(height: 15.0,),
                          Container(
                          padding: EdgeInsets.all(5.0),                         width: 400,
                          height: 320,
                          decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage(
                          snapshots.data.documents[i].data['timelinposturl']),
                          fit: BoxFit.cover)

                          ),
                          ),
                          SizedBox(height: 20.0,),
                          Row(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: <Widget>[
                          IconButton(icon: Icon(Icons.favorite),color: isLiked(snapshots.data.documents[i].data['postId'])? Colors.red:Colors.white,iconSize: 35,padding: EdgeInsets.all(0.0),
                              onPressed: (){
                                FirebaseAuth.instance.currentUser().then((FirebaseUser user){
                                  Firestore.instance.collection('feedactivity').document(snapshots.data.documents[i].data['postId']).setData({
                                    'likes':FieldValue.arrayUnion([user.displayName]),
                                    'postId': snapshots.data.documents[i].data['postId']
                                  });
                                }).then((val){
                                  print(snapshots.data.documents[i].data['postId']);
                                });

                               print(snapshots.data.documents[i].data['postId']);
                          }),

                            IconButton(icon: Icon(Icons.comment),color: Colors.white

                                ,iconSize: 35,padding: EdgeInsets.all(0.0), onPressed: (){}),
                          IconButton(icon: Icon(Icons.send),color: Colors.white,iconSize: 35,padding: EdgeInsets.all(0.0), onPressed: (){}),

                          ],
                          ),
                          Text('${snapshots.data.documents[0].data['postlikes']}  likes',style: TextStyle(color: Colors.white),)
                          ],
                          ),
                          );
                          }
                          );
                          }
              }
                          )
    );
  }

//  Widget Postcard(){
//
//                return Container(
//                  padding: EdgeInsets.all(10.0),
//                  height: 500.0,
//                  width: 400,
//                  decoration: BoxDecoration(
//
//                  ),
//
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: <Widget>[
//                      Row(
//                        children: <Widget>[
//                          CircleAvatar(
//                            backgroundImage: NetworkImage(
//                                snapshots.data.documents[i]
//                                    .data['posteduserprofile']),
//                          ),
//                          SizedBox(width: 15.0,),
//                          Text(snapshots.data.documents[i]
//                              .data['postedusername'], style: TextStyle(
//                            color: Colors.white,
//                            fontSize: 20.0,
//                            fontWeight: FontWeight.bold,
//                          ),)
//                        ],
//                      ),
//                      SizedBox(height: 15.0,),
//                      Container(
//                        padding: EdgeInsets.all(5.0),                         width: 400,
//                        height: 320,
//                        decoration: BoxDecoration(
//                            image: DecorationImage(image: NetworkImage(
//                                snapshots.data.documents[i].data['timelinposturl']),
//                                fit: BoxFit.cover)
//
//                        ),
//                      ),
//                      SizedBox(height: 20.0,),
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.start,
//
//                        children: <Widget>[
//                         IconButton(icon: Icon(Icons.favorite),color: Colors.white,iconSize: 35,padding: EdgeInsets.all(0.0), onPressed: (){
//
//
//                           Firestore.instance.collection('users').document(snapshots.data.documents[0].data['uid']).collection('posts')
//                               .document(snapshots.data.documents[0].data['postId']).updateData({'likes':'liked'});
//
//
//                }),
//                          IconButton(icon: Icon(Icons.comment),color: Colors.white,iconSize: 35,padding: EdgeInsets.all(0.0), onPressed: (){}),
//                          IconButton(icon: Icon(Icons.send),color: Colors.white,iconSize: 35,padding: EdgeInsets.all(0.0), onPressed: (){}),
//
//                        ],
//                      ),
//                      Text('${snapshots.data.documents[0].data['postlikes']}  likes',style: TextStyle(color: Colors.white),)
//                    ],
//                  ),
//                );
}