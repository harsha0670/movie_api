import 'dart:async';
import 'dart:convert';
import 'dart:math' show Random;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Anime> fetchAnime() async {
  final response = await http.get('https://api.jikan.moe/v3/anime/1');

  if (response.statusCode == 200) {
    return Anime.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load Anime');
  }
}

class Anime {
  final String title;
  final String imageURL;

  Anime({this.title, this.imageURL});

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(title: json['title'], imageURL: json['image_url']);
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Anime> anime;

  @override
  void initState() {
    super.initState();
    anime = fetchAnime();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Anime Generator'),
        ),
        body: Center(
          child: FutureBuilder<Anime>(
            future: anime,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    SizedBox(height: 40.0),
                    Image.network(snapshot.data.imageURL),
                    Text(
                      snapshot.data.title,
                      style: TextStyle(fontSize: 15.0),
                    ),
                    SizedBox(height: 40.0),
                    RaisedButton(
                      onPressed: () {
                        var randomizer = new Random();
                        var num = randomizer.nextInt(100);
                      },
                      child: Text(
                        'Click to generate an anime',
                      ),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
