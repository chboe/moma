import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moma_appen/profile.dart';
import 'package:http/http.dart' as http;
import 'movie.dart';
import 'aboutDialog.dart';


class FriendMatches extends StatefulWidget {
  Profile me;
  Profile friend;
  FriendMatches({Key key, @required this.me, this.friend}) : super(key: key);

  @override
  _FriendMatchesState createState() => _FriendMatchesState(me,friend);
}

class _FriendMatchesState extends State<FriendMatches> {
  Profile me;
  Profile friend;
  List<Movie> matches = List.empty();
  _FriendMatchesState(this.me,this.friend){
    _initState(me, friend);
  }

  _initState(Profile loggedInAs, Profile friend) {
    _getMatches(loggedInAs,friend).then((f) => setState(() {
      matches = f.toList();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Movies in Common"),
        ),
        body:
        ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index){
            return ListTile(leading: Image.network(matches[index].poster), title: Text(matches[index].name), onTap: () => movieBioDialog(context, matches[index]),);
          },
        )
    );
  }

  Future<List<Movie>> _getMatches(Profile me, Profile friend) async {
    var url = 'http://10.0.2.2:8080/getMatches/' +
        me.id.toString() +
        "/" +
        friend.id.toString();
    var response = await http.get(url);
    if (response.statusCode == 200)
      return (json.decode(response.body) as List)
          .map((i) => Movie.fromJson(i))
          .toList();
    return List.empty();
  }
}