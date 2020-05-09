import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hellogram/signuppage.dart';
import 'timeline.dart';
import 'searchpage.dart';
import 'uploadpage.dart';
import 'notificationpage.dart';
import 'profilepage.dart';



class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {

  String _email;
  String _password;
  bool isSigned = false;
  int currentindex = 0;
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    controlsignin();
  }

  controlsignin() {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        setState(() {
          isSigned = true;
        });
      }
      else {
        isSigned = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: isSigned ? buildhomepage() : buildloginpage()
    );
  }


  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  whenpagechanges(int pageindex) {
    setState(() {
      currentindex = pageindex;
    });
  }

  changepage(int pageindex) {
    pageController.animateToPage(
        pageindex, duration: Duration(milliseconds: 400),
        curve: Curves.bounceInOut);
  }

  buildhomepage() {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: <Widget>[
          Timeline(),
          Search(),
          Upload(),
          NotificationPage(),
          Profile()
        ],
        onPageChanged: whenpagechanges,
        physics:NeverScrollableScrollPhysics() ,
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: currentindex,
        onTap: changepage,
        backgroundColor: Colors.black87,
        activeColor: Colors.white,
        inactiveColor: Colors.blueGrey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
    );
  }

  buildloginpage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter your email',
                hintStyle: TextStyle(
                  color: Colors.grey,
                )
            ),
            onChanged: (value) {
              _email = value;
            },
          ),
        ),
        SizedBox(height: 20.0,),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Password',
                hintStyle: TextStyle(
                  color: Colors.grey,
                )
            ),
            onChanged: (value) {
              _password = value;
            },
          ),
        ),
        SizedBox(height: 20.0,),
        RaisedButton(
          color: Colors.blue,
          child: Text('Log in'),
          onPressed: () {
            FirebaseAuth.instance.signInWithEmailAndPassword(
                email: _email, password: _password).then((val){
                  setState(() {
                    isSigned = true;
                  });
            });
          },
        ),
        SizedBox(height: 20.0,),
        RaisedButton(
          color: Colors.blue,
          child: Text('Sign up'),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MySignUpPage()));
          },
        )
      ],
    );
  }

}