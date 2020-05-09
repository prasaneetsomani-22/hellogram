import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'headerappbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginpage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class NotificationPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NotificationPageState();
  }

}

class NotificationPageState extends State<NotificationPage>{
  final FirebaseMessaging _messaging = FirebaseMessaging();
  List<Message> messages = [];
  @override
  void initState() {
    // TODO: implement initState

    messages = [];
    configuringmessages();
    super.initState();
  }

  configuringmessages(){
    _messaging.configure(
      onMessage: (Map<String,dynamic> message)async{
        print('onMessage: $message');
        setmessage(message);
      },
      onResume: (Map<String,dynamic> message)async{
        print('onResume: $message');
        setmessage(message);
      },
      onLaunch: (Map<String,dynamic> message)async{
        print('onLaunch: $message');
        setmessage(message);
      },
    );
  }

  setmessage(Map<String,dynamic> message){
    var notifications = message['notification'];
    var data = message['data'];
    String title = notifications['title'];
    String body = notifications['body'];
    String mmessage = data['message'];
    String icon = notifications['icon'];
    Message msg = Message(title, body, mmessage,icon);
    messages.add(msg);
    print(icon);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: header(context,pagetitle: "Notification",disappearedbackbutton: false),
        body: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context,i){
//              return Card(
//                child: Padding(
//                    padding: EdgeInsets.all(15.0),
//                  child: Text(messages[i].message,
//                    style: TextStyle(color: Colors.black,
//                        fontSize: 17.0),
//                  ),
//                ),
//              );
              return Container(
                height:100,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(backgroundImage: NetworkImage('${messages[i].icon}'),),
                    SizedBox(width: 20.0,),
                    Text('${messages[i].message} posted in while',style: TextStyle(color: Colors.white,fontSize: 17.0),)
                  ],
                ),
              );


            })
    );
  }
}

class Message{
  final String title;
  final String body;
  final String message;
  final String icon;
//  final String postedusername;
//  final String posteduserprofile;
//  final String timelinposturl;
//  final String postId;
//  final String uid;
//  final String likes;

  Message(this.title,this.body,this.message,this.icon);//this.posteduserprofile,this.timelinposturl,this.postId,this.uid,this.likes);
}