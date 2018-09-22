import 'package:flutter/material.dart';

class DetailImage extends StatelessWidget {
  DetailImage({this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Material(
        child: Center(
          child: new Container(
            child: new Stack(
              fit: StackFit.expand,
              children: <Widget>[
                new Hero(
                    tag: image,
                    child: new Image.network(
                      '$image',
                      fit: BoxFit.cover,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
