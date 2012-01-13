::#!
@echo off

call scala -nocompdaemon -savecompiled "%~f0" %1
goto :EOF
::!#

import java.io._
import sys.process._

val target = args.head.toLong
val cls = "Calc_%d" format target
val tmp = sys.props("java.io.tmpdir")

if (!new File(cls+".class").exists) {
  
  val Numbers = 1 to 9
  val Operators = IndexedSeq("+", "-", "", "*", "/")

  val Length = Numbers.length
  val Height = Operators.length
  val Brackets = Length - 1

  def processIndex(index: Long) = {
    val ops = new Array[Int](Brackets); {
      var tr = index
      var cur = Brackets - 1

      while (tr > 0) {
        ops(cur) = (tr % Height).toInt
        tr /= Height
        cur -= 1
      }
    }

    val sB = new StringBuilder()
    var pos = 0

    while (pos < Brackets) {
      sB.append(Numbers(pos) + ". ")
        .append(Operators(ops(pos)))
      pos += 1
    }

    sB.append(Numbers(pos) + ". ").toString
  }

  val sB = new StringBuilder
  val bW = new BufferedWriter(new FileWriter(tmp + cls + ".java"))
    
  bW.write("""public class %s {
  public static void main(final String[] args) {
""" format cls)

  val dd = """(\d)\. (?=\d)"""r
  val tr = """[.\sL]+"""r

  def process(top: Long) {
    if (top > 0) {
      val clause = dd.replaceAllIn(processIndex(top), "$1")
      val eq = "%s == %dL".format(clause, target)
      val display = tr.replaceAllIn(eq, "")

      bW.write("    if (%50s) System.out.println(\"%25s\");\r\n" format(eq, display))
      process(top-1)
    }
  }

  process(math.pow(Height, Brackets).toLong -1)

  bW.write("""  }
}""");

  bW.close()
  
  "javac -d . " + tmp + cls + ".java" !
}

"java " + cls!
