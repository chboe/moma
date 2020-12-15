lazy val root = (project in file("root"))
  .settings(
    fork in run := true,
    scalaVersion in ThisBuild := "2.12.10",
    version in ThisBuild := "0.0.1",
    name := "moma",
    libraryDependencies ++= Seq(
      "com.typesafe.akka" %% "akka-stream" % "2.6.8",
      "com.typesafe.akka" %% "akka-http" % "10.2.1",
      "org.tpolecat" %% "doobie-core"      % "0.9.0",
      "org.tpolecat" %% "doobie-postgres"  % "0.9.0",
      "org.typelevel" %% "cats-core" % "2.3.0",
      "org.typelevel" %% "cats-effect" % "2.3.0",
      "io.circe" %% "circe-core" % "0.12.3",
      "io.circe" %% "circe-generic" % "0.12.3",
      "io.circe" %% "circe-parser" % "0.12.3"
    )
  )
