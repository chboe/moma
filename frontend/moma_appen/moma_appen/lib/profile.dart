import 'movie.dart';
import 'package:json_annotation/json_annotation.dart';

class Profile {
  //final List<String> photos;
  final int id;
  final String name;
  final String username;
  final String email;
  final String picture;

  Profile(this.id, this.name, this.username, this.email, this.picture);

  Profile.fromJson(Map<String,dynamic> json)
    : id = json['id'],
      name = json['name'],
      email = json['email'],
      username = json['username'],
      picture = json['picture'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'email': email,
        'username': username,
        'picture': picture
      };
}