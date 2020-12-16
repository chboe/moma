import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'movie.dart';


class ProfileWidget extends StatelessWidget {
  final List<Movie> likedMovies;

  //SecondRoute({this.inCommon});
  ProfileWidget({this.likedMovies});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: Center(
          child:
            CircularProfileAvatar(
              null,
              child: FlutterLogo(),
              borderColor: Colors.purpleAccent,
              borderWidth: 2,
              elevation: 5,
              radius: 50,
            )
          ),
        );
  }
}