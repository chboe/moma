import 'package:flutter/material.dart';
import 'main.dart';
import 'movie.dart';

void alertDialog(BuildContext context) {
  var alert = AlertDialog(
    title: Text("About"),
    content: Text("This product uses the TMDb API but is not endorsed or certified by TMDb\n\n Developed by: the bois"),
  );
  showDialog(context: context, builder: (BuildContext context) => alert);
}


void movieBioDialog(BuildContext context, Movie movie) {
  var alert = AlertDialog(
    title: Text("Movie Info"),
    content: Text('Language: ' + movie.language +
        "\nGenres: " + genreToString(movie.genres) +
        "\nRuntime: " + movie.runtime.toString() +
        "\nDescription: \n"+movie.description),
  );
  showDialog(context: context, builder: (BuildContext context) => alert);
}

String genreToString(List<String> genre){
  String result = "";
  //int n = genre.length;
  for(int i = 0; i< genre.length ; i++){
      result = result + genre[i] +", ";
  }
  return result.substring(0, result.length-2); //remove the last commar and space
}