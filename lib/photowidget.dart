import 'package:flutter/material.dart';

class PhotoWidget  extends StatelessWidget {
  final String data;
  PhotoWidget({this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Container(
    height: 300,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
    image: DecorationImage(image: NetworkImage(data)),
),
    ),
    );
  }
}
