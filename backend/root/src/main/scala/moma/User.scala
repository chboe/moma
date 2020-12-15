package moma

import cats.effect.{ExitCode, IO, IOApp}
import doobie.implicits._
import moma.Main.xa
import io.circe._
import io.circe.generic.auto._
import io.circe.parser._
import io.circe.syntax._

case class User(
               id: Int,
               username: String,
               name: String,
               email: String,
               password: String,
               liked: List[Int],
               superliked: List[Int],
               disliked: List[Int],
               friendIds: List[Int],
               picture: String,
               )

object User{

  def getSwipeableMovies(userId: Int): String = {
    getSwipeableMoviesHelper(userId,10)
  }

  def getSwipeableMoviesHelper(userId: Int, amount: Int): String = {
    val q1 = sql"SELECT id FROM movies ORDER BY popularity DESC LIMIT $amount"
    val unfinishedList = q1.query[(Int)].to[List].transact(xa).unsafeRunSync()

    val q2 = sql"SELECT liked, superliked, disliked FROM users WHERE id=$userId"
    val alreadySwiped = q2.query[(String, String, String)].to[List].transact(xa).unsafeRunSync().flatMap{ x =>
      decode[List[Int]](x._1).getOrElse(List.empty)++decode[List[Int]](x._2).getOrElse(List.empty)++decode[List[Int]](x._3).getOrElse(List.empty)
    }

    val finishedList = unfinishedList.filter(!alreadySwiped.contains(_))

    if(finishedList.length>10){
      println(finishedList)
      finishedList.map{id =>
        TMDBAPI.fetchMovie(id)
      }.asJson.noSpaces
    } else {
      getSwipeableMoviesHelper(userId, amount*2)
    }
  }

  def login(username: String, password: String): String = ???
  def dislikeMovie(userId: Int, movieId: Int): String = ???
  def likeMovie(userId: Int, movieId: Int): String = ???
  def superlikeMovie(userId: Int, movieId: Int): String = ???
  def addFriend(userId: Int, movieId: Int): String = ???

}
