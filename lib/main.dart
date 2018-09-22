import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/ImageData.dart';
import 'package:wallpaper/ImageDetail.dart';

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client
      .get('http://sampulbox.com/wallpaper/app/view/flatuiwallpaper');

  // Use the compute function to run parsePhotos in a separate isolate
  return compute(parsePhotos, response.body);
}

List<Photo> parsePhotos(String responseBody) {
  final parsed = json.decode(responseBody);

  return (parsed["alldata"] as List)
      .map<Photo>((json) => new Photo.fromJson(json))
      .toList();
}

void main() {
  runApp(new MaterialApp(home: new MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallpaper',
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new FutureBuilder<List<Photo>>(
        future: fetchPhotos(new http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new PhotosList(photos: snapshot.data)
              : new Center(child: new CircularProgressIndicator());
        },
      ),
    );
  }
}

class PhotosList extends StatefulWidget {
  int _count = 0;
  final List<Photo> photos;
  final String image;

  PhotosList({Key key, this.photos, this.image}) : super(key: key);

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 3));

    return null;
  }

  @override
  PhotosListState createState() {
    return new PhotosListState();
  }
}

class PhotosListState extends State<PhotosList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallpaper Base"),
        centerTitle: true,
      ),
      body: Container(
        child: new RefreshIndicator(
          onRefresh: widget._handleRefresh,
          child: new GridView.builder(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: widget.photos.length,
            itemBuilder: (context, index) => _buildImageItem(context, widget.photos[index]),
          ),
        ),
      ),
    );
  }
}

Widget _buildImageItem(BuildContext context, Photo image) {
    return Container(
      padding: new EdgeInsets.all(3.0),
          child: Material(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        elevation: 3.0,
        child: InkWell(
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new DetailImage(image: image.thumbnailUrl),
                ),
              ),
          child: Hero(
            tag: image.thumbnailUrl,
            child: new FadeInImage.assetNetwork(
              placeholder: 'assets/picture.png',
              image: image.thumbnailUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
