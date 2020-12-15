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
        complete(HttpEntity(ContentTypes.`application/json`, User.getSwipeableMovies(id)))
      }
    }


  val bindingFuture = Http().newServerAt("localhost", 8080).bind(route)

  println(s"Server online at http://localhost:8080/\nPress RETURN to stop...")
  override def run(args: List[String]): IO[ExitCode] = IO.fromFuture(IO(bindingFuture)).as(ExitCode.Success)

}
