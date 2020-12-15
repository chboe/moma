import 'package:flutter/material.dart';

import 'movie.dart';
import 'aboutDialog.dart';


class MyLikedMovies extends StatelessWidget {
  final List<Movie> likedMovies;

  MyLikedMovies({this.likedMovies});
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
            return ListTile(leading: Image.asset(likedMovies[index].poster), title: Text(likedMovies[index].name), onTap: () => movieBioDialog(context, likedMovies[index]));
          },
        )
    );
  }
}