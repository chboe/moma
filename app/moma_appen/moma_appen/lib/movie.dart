class Movie {
  //final List<String> photos;
  final int id;
  final String name;
  final String language;
  final String description;
  final List<String> genres;
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
}