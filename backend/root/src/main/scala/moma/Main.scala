package moma
import akka.actor.ActorSystem
import akka.http.scaladsl.Http
import akka.http.scaladsl.model._
import akka.http.scaladsl.server.Directives._

import scala.concurrent.Await
import scala.concurrent.duration.Duration
import scala.io.StdIn

object Main extends App {
   implicit val system = ActorSystem("my-system")
    // needed for the future flatMap/onComplete in the end
    implicit val executionContext = system.dispatcher

    val route =
      path("hello") {
        get {
          complete(HttpEntity(ContentTypes.`text/html(UTF-8)`, "<h1>Say hello to akka-http</h1>"))
        }
      } ~ path("hej") {
        get {
          complete(HttpEntity(ContentTypes.`text/html(UTF-8)`, Test.test()))
        }
      }


    val bindingFuture = Http().newServerAt("localhost", 8080).bind(route)

    println(s"Server online at http://localhost:8080/\nPress RETURN to stop...")
    Await.result(bindingFuture, Duration.Inf)
}
