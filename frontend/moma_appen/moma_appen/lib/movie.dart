class Movie {
  //final List<String> photos;
  final int id;
  final String name;
  final String language;
  final String description;
  final List<dynamic> genres;
  final String releaseDate;
  final int runtime;
  final String poster;


  Movie(  this.id,
          this.name,
          this.language,
          this.description,
          this.genres,
          this.releaseDate,
          this.runtime,
          this.poster,
          );


  Movie.fromJson(Map<String,dynamic> json)
      : id = json['id'],
        name = json['name'],
        language = json['language'],
        description = json['description'],
        genres = json['genres'] as List,
        releaseDate = json['releaseDate'],
        runtime = json['runtime'],
        poster = json['poster'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'language': language,
        'description': description,
        'genres': genres,
        'releaseDate': releaseDate,
        'runtime': runtime,
        'poster': poster
      };
}