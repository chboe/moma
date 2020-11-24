lazy val root = (project in file("root"))
  .settings(
    fork in run := true,
    scalaVersion in ThisBuild := "2.12.10",
    version in ThisBuild := "0.0.1",
    name := "moma",
    libraryDependencies ++= Seq(
  "com.typesafe.akka" %% "akka-stream" % "2.6.8",
  "com.typesafe.akka" %% "akka-http" % "10.2.1"
    )
  )
