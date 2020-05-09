import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hellogram/profilefromsearch.dart';

class Search extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchState();
  }

}

class SearchState extends State<Search> {
  List searchresult = [];
  List tempresults = [];
  String searchkey;
  QuerySnapshot searchres;



  
  searchresults(String value) {

    if (value.length == 0) {
      setState(() {
        searchresult = [];
        tempresults = [];
      });
    }
    if (searchresult.length == 0 && value.length == 1) {
      Firestore.instance.collection('users')
          .where('userkey', isEqualTo: value)
          .getDocuments()
          .then((docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          setState(() {
            searchresult.add(docs.documents[i].data);
          });
        }
      });
    }
    else {
      tempresults = [];
      searchresult.forEach((element) {
        if(element['username'].toString().startsWith(value)){
          setState(() {
            tempresults.add(element);
          });
        }
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: TextField(
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search, color: Colors.grey,)
            ),
            onChanged: (value) {
              searchresults(value);
            },
          ),
        ),
        body: ListView(
          children: tempresults.length == 0?searchresult.map((element) {
            return buildsearchcard(element);
          }).toList():tempresults.map((element) {
            return buildsearchcard(element);
          }).toList()
        ),

    );
  }
  Widget buildsearchcard(element) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        child: Container(
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(element['profilepic']),
              ),
              SizedBox(width: 10.0,),
              Text(element['username'],style: TextStyle(color: Colors.white,fontSize: 20.0),)
            ],
          )
        ),
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileFromSearch(element)));
        },
      ),
    );
  }
}

