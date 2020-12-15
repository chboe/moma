package moma
import akka.actor.ActorSystem
import akka.http.scaladsl.Http
import akka.http.scaladsl.model._
import akka.http.scaladsl.server.Directives._
import cats.effect.{ExitCode, IO, IOApp}
import doobie.util.transactor.Transactor

import scala.concurrent.Await
import scala.concurrent.duration.Duration
import scala.io.StdIn
import doobie._
import doobie.implicits._
import doobie.util.transactor.Transactor.Aux

object Main extends IOApp {
  implicit val system = ActorSystem("my-system")
  val xa: Aux[IO, Unit] = Transactor.fromDriverManager[IO](
    "org.postgresql.Driver", "jdbc:postgresql:moma", "postgres", "1234"
  )

  // needed for the future flatMap/onComplete in the end
  implicit val executionContext = system.dispatcher

  val route =
    get {
      path("hello") {
        val query = sql"select id, originaltitle, popularity from movies where id=775925"
        val result = query.query[(Int, String, Double)].to[List].transact(xa).unsafeRunSync()

        complete(HttpEntity(ContentTypes.`text/html(UTF-8)`, result.toString))
      }
    } ~
    get {
      path("getSwipeableMovies"/ IntNumber) { id =>
        User.getSwipeableMovies(id)
      }
    } ~
    get {
      path("getMatches"/ IntNumber / IntNumber) { (userId, friendId) =>
        User.getMatches(userId,friendId)
      }
    } ~
    get {
      path("dislikeMovie"/ IntNumber / IntNumber) { (userId, movieId) =>
        User.dislikeMovie(userId,movieId)
      }
    } ~
    get {
      path("likeMovie"/ IntNumber / IntNumber) { (userId, movieId) =>
        User.likeMovie(userId,movieId)
      }
    } ~
    get {
      path("superlikeMovie"/ IntNumber / IntNumber) { (userId, movieId) =>
        User.superlikeMovie(userId,movieId)
      }
    } ~
    get {
      path("addFriend"/ IntNumber / IntNumber) { (userId, friendId) =>
        User.addFriend(userId, friendId)
      }
    } ~
    get {
      path("getFriendsList"/ IntNumber ) { userId =>
        User.getFriendsList(userId)
      }
    } ~
    get {
      path("getUser"/ IntNumber ) { userId =>
        User.getUser(userId)
      }
    } ~
    get {
      path("login"/ Segment / Segment ) { (username, password) =>
        User.login(username, password)
      }
    }


  val bindingFuture = Http().newServerAt("localhost", 8080).bind(route)

  println(s"Server online at http://localhost:8080/\nPress RETURN to stop...")
  override def run(args: List[String]): IO[ExitCode] = IO.fromFuture(IO(bindingFuture)).as(ExitCode.Success)

}
