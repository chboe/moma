package moma

import akka.http.scaladsl.model.{ContentTypes, HttpEntity}
import akka.http.scaladsl.server.Directives._
import akka.http.scaladsl.server.StandardRoute
import cats.effect.{ExitCode, IO, IOApp}
import doobie.implicits._
import moma.Main.xa
import io.circe._
import io.circe.generic.auto._
import io.circe.parser._
import io.circe.syntax._

case class Matches(
                  userSuperlikes: List[Int],
                  friendSuperLikes: List[Int],
                  bothLikes: List[Int],
                  )

case class PublicUser(
                       username: String,
                       name: String,
                       email: String,
                       picture: String,
                     )

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

  def getSwipeableMovies(userId: Int): StandardRoute = {
    val x = getSwipeableMoviesHelper(userId,10)
    if(x.isEmpty){
      failWith(new RuntimeException("No user found found!"))
    } else {
      val res = x.asJson.noSpaces
      complete(HttpEntity(ContentTypes.`application/json`,res))
    }
  }

  def getSwipeableMoviesHelper(userId: Int, amount: Int): List[Movie] = {
    val q1 = sql"SELECT id FROM movies ORDER BY popularity DESC LIMIT $amount"
    val unfinishedList = q1.query[(Int)].to[List].transact(xa).unsafeRunSync()

    val q2 = sql"SELECT liked, superliked, disliked FROM users WHERE id=$userId"
    val alreadySwiped = q2.query[(String, String, String)].to[List].transact(xa).unsafeRunSync().flatMap{ x =>
      decode[List[Int]](x._1).getOrElse(List.empty)++decode[List[Int]](x._2).getOrElse(List.empty)++decode[List[Int]](x._3).getOrElse(List.empty)
    }

    val finishedList = unfinishedList.filter(!alreadySwiped.contains(_))

    if(finishedList.length>10){
      finishedList.map{id =>
        TMDBAPI.fetchMovie(id)
      }
    } else {
      getSwipeableMoviesHelper(userId, amount*2)
    }
  }

  def getMatches(userId: Int, friendId: Int): StandardRoute ={
    val matches = for{
      liked1 <- sql"SELECT liked FROM USERS WHERE id=$userId".query[String].to[List].transact(xa).unsafeRunSync()
      liked2 <- sql"SELECT liked FROM USERS WHERE id=$friendId".query[String].to[List].transact(xa).unsafeRunSync()
    } yield {
      decode[List[Int]](liked1).getOrElse(List.empty).filter( x=> (decode[List[Int]](liked2).getOrElse(List.empty)).contains(x))
    }

    val res = matches.flatten.asJson.noSpaces
    complete(HttpEntity(ContentTypes.`application/json`,res))
  }

  def dislikeMovie(userId: Int, movieId: Int): StandardRoute = {
    val x = for{
      q1 <- sql"SELECT disliked FROM users WHERE id=$userId".query[String].to[List].transact(xa)
      dislikedList = (decode[List[Int]](q1.head).getOrElse(List.empty):+movieId).distinct.asJson.noSpaces
      q2 <- sql"UPDATE users SET disliked = $dislikedList WHERE id=$userId".update.run.transact(xa)
    } yield {
      q2
    }
    val updatedColumns = x.unsafeRunSync()
    if(updatedColumns ==0){
      failWith(new RuntimeException("No user found found!"))
    } else {
      val res = updatedColumns.asJson.noSpaces
      complete(HttpEntity(ContentTypes.`application/json`,res))
    }
  }
  def likeMovie(userId: Int, movieId: Int): StandardRoute = {
    val x = for{
      q1 <- sql"SELECT liked FROM users WHERE id=$userId".query[String].to[List].transact(xa)
      likedList = (decode[List[Int]](q1.head).getOrElse(List.empty):+movieId).distinct.asJson.noSpaces
      q2 <- sql"UPDATE users SET liked = $likedList WHERE id=$userId".update.run.transact(xa)
    } yield {
      q2
    }
    val updatedColumns = x.unsafeRunSync()
    if(updatedColumns ==0){
      failWith(new RuntimeException("No user found found!"))
    } else {
      val res = updatedColumns.asJson.noSpaces
      complete(HttpEntity(ContentTypes.`application/json`,res))
    }
  }
  def superlikeMovie(userId: Int, movieId: Int): StandardRoute = {
    val x = for{
      q1 <- sql"SELECT superliked FROM users WHERE id=$userId".query[String].to[List].transact(xa)
      superlikedList = (decode[List[Int]](q1.head).getOrElse(List.empty):+movieId).distinct.asJson.noSpaces
      q2 <- sql"UPDATE users SET superliked = $superlikedList WHERE id=$userId".update.run.transact(xa)
    } yield {
      q2
    }
    val updatedColumns = x.unsafeRunSync()
    if(updatedColumns ==0){
      failWith(new RuntimeException("No user found found!"))
    } else {
      val res = updatedColumns.asJson.noSpaces
      complete(HttpEntity(ContentTypes.`application/json`,res))
    }
  }
  def addFriend(userId: Int, friendId: Int): StandardRoute = {
    val x = for{
      q1 <- sql"SELECT friendids FROM users WHERE id=$userId".query[String].to[List].transact(xa)
      friendlist = (decode[List[Int]](q1.head).getOrElse(List.empty):+friendId).distinct.asJson.noSpaces
      q2 <- sql"UPDATE users SET friendids = $friendlist WHERE id=$userId".update.run.transact(xa)
    } yield {
      q2
    }
    val updatedColumns = x.unsafeRunSync()
    if(updatedColumns ==0){
      failWith(new RuntimeException("No user found found!"))
    } else {
      val res = updatedColumns.asJson.noSpaces
      complete(HttpEntity(ContentTypes.`application/json`,res))
    }
  }

  def getFriendsList(userId: Int): StandardRoute = {
    val q1 = sql"SELECT friendids FROM users WHERE id = $userId"
    val friendslist = decode[List[Int]](q1.query[String].to[List].transact(xa).unsafeRunSync().head).getOrElse(List.empty)
    if(friendslist.isEmpty){
      failWith(new RuntimeException("No user found!"))
    } else {
      val res = friendslist.map{x => getUserHelper(x)}.asJson.noSpaces
      complete(HttpEntity(ContentTypes.`application/json`,res))
    }
  }

  def getUserHelper(userId: Int):Option[PublicUser] = {
    val q1 = sql"SELECT username, name, email, picture FROM users WHERE id = $userId"
    q1.query[PublicUser].to[List].transact(xa).unsafeRunSync().headOption
  }

  def getUser(userId: Int): StandardRoute = {
    val user = getUserHelper(userId).toList
    if (user.isEmpty) {
      failWith(new RuntimeException("No user found!"))
    } else {
      val res = user.head.asJson.noSpaces
      complete(HttpEntity(ContentTypes.`application/json`, res))
    }
  }

  def login(username: String, password: String): StandardRoute = {
    val q1 = sql"SELECT username, name, email, picture FROM users WHERE username = $username AND password = $password".query[PublicUser].to[List].transact(xa).unsafeRunSync()
    if(q1.isEmpty){
      failWith(new RuntimeException("No user found!"))
    } else {
      val res = q1.head.asJson.noSpaces
      complete(HttpEntity(ContentTypes.`application/json`,res))
    }
  }

}
