import sbt._
import Keys._

object BuildSettings {

  val commonSettings =
    Default.settings ++ Seq(
      organization := "hr.element.onetonine"
    )

//  ---------------------------------------------------------------------------

  val bsOneToNine = commonSettings ++ Seq(
    name    := "OneToNine",
    version := "0.0.1-SNAPSHOT"
  )
}

//  ---------------------------------------------------------------------------

object Dependencies {
  import Implicits._

  val scalaTest = "org.scalatest" %% "scalatest" % "1.6.1" % "test"
 
  val depsOneToNine = libDeps(
    twitterEval,
    //test
    scalaTest
  )
}

//  ---------------------------------------------------------------------------

object OneToNineBuild extends Build {
  import BuildSettings._
  import Dependencies._

  lazy val oneToNine = Project(
    "OneToNine",
    file("."),
    settings = bsOneToNine :+ depsOneToNine
  )
}
