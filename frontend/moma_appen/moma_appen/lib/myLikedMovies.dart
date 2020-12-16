import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moma_appen/profile.dart';

import 'movie.dart';
import 'aboutDialog.dart';
import 'package:http/http.dart' as http;
class MyLikedMovies extends StatefulWidget {
  Profile me;
  MyLikedMovies({Key key, @required this.me}) : super(key: key);

  @override
  _MyLikedMoviesState createState() => _MyLikedMoviesState(me);
}

class _MyLikedMoviesState extends State<MyLikedMovies> {
  Profile me;
  List<Movie> likedMovies = List.empty();

  _MyLikedMoviesState(this.me){
    _initState(me);
  }

  _initState(Profile me) {
    _getLiked(me).then((f) => setState(() {
      likedMovies = f.toList();
    }));
  }

  Future<List<Movie>> _getLiked(Profile me) async {
    var url = 'http://10.0.2.2:8080/getLiked/' +
        me.id.toString();
    var response = await http.get(url);
    if (response.statusCode == 200)
      return (json.decode(response.body) as List)
          .map((i) => Movie.fromJson(i))
          .toList();
    return List.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Liked"),
        ),
        body:
        ListView.builder(
          itemCount: likedMovies.length,
          itemBuilder: (context, index){
            return ListTile(leading: Image.network(likedMovies[index].poster), title: Text(likedMovies[index].name), onTap: () => movieBioDialog(context, likedMovies[index]));
          },
        )
    );
  }
}