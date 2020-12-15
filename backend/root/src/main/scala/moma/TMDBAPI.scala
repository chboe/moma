package moma

import akka.parboiled2.RuleTrace.StringMatch
import io.circe._, io.circe.generic.auto._, io.circe.parser._, io.circe.syntax._
import scala.io.Source

case class Genres(
                 id: Option[Int],
                 name: Option[String],
                 )

case class APIResponse(
                      id: Option[Int],
                      original_title: Option[String],
                      original_language: Option[String],
                      overview: Option[String],
                      genres: Option[List[Genres]],
                      release_date: Option[String],
                      runtime: Option[Int],
                      poster_path: Option[String],
                      )
case class Movie(
                id: Int,
                name: String,
                language: String,
                description: String,
                genres: List[String],
                releaseDate: String,
                runtime: Int,
                poster: String,
                )

object TMDBAPI {
  val apiKey = "df6fbb05a1f348fd5805a88bcc231efd"

  def fetchMovie(id: Int): Movie = {
    val jsonMovieOpt = decode[APIResponse](get("https://api.themoviedb.org/3/movie/"+id+"?api_key="+apiKey+"&language=en-US")).toOption
    jsonMovieOpt.map{ jsonMovie =>
      Movie(
        jsonMovie.id.getOrElse(0),
        jsonMovie.original_title.getOrElse(""),
        jsonMovie.original_language.getOrElse(""),
        jsonMovie.overview.getOrElse(""),
        jsonMovie.genres.toList.flatten.flatMap(_.name),
        jsonMovie.release_date.getOrElse(""),
        jsonMovie.runtime.getOrElse(0),
        "http://image.tmdb.org/t/p/w500"+jsonMovie.poster_path.getOrElse("")
      )
    }.getOrElse(
      Movie(
        0,
        "",
        "",
        "",
        List.empty,
        "",
        0,
        "",
      )
    )
  }

  def get(url: String): String = {
    Source.fromURL(url,"UTF-8").mkString
  }
}
