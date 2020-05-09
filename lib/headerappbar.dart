import 'package:flutter/material.dart';

AppBar header(context, {bool isApptitle=false, String pagetitle,bool disappearedbackbutton = true}){
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      title: Text(
        isApptitle ? "Hellogram" : pagetitle,
        style: TextStyle(
          fontFamily: isApptitle? "Pacifico" : "",
          fontSize: isApptitle? 32.0 : 22.0,
          color: Colors.white,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      automaticallyImplyLeading: disappearedbackbutton? false : true,
      centerTitle: true,
      backgroundColor: Theme.of(context).accentColor,
    );
}