import 'movie.dart';

class Profile {
  //final List<String> photos;
  final String name;
  final List<Profile> friends;
  final List<Movie> myMovies;
  final String picture;

  Profile(this.name, this.friends, this.myMovies, this.picture);

  //Profile(this.name, List<Profile>(), List<Movie>());
}