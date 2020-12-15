import 'package:flutter/material.dart';

import 'movie.dart';
import 'aboutDialog.dart';


class SecondRoute extends StatelessWidget {
  final List<Movie> inCommon;

  SecondRoute({this.inCommon});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movies in Common"),
      ),
      body:
      ListView.builder(
            itemCount: inCommon.length,
            itemBuilder: (context, index){
              return ListTile(leading: Image.asset(inCommon[index].poster), title: Text(inCommon[index].name), onTap: () => movieBioDialog(context, inCommon[index]),);
            },
          )
      );
  }
}