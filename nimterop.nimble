# Package

version = "0.4.4"
author      = "genotrance"
description = "C/C++ interop for Nim"
license     = "MIT"

# this gives Warning: Binary 'nimterop/toast' was already installed from source directory
# when running `nimble install --verbose -y`
bin = @["nimterop/toast"]
installDirs = @["nimterop"]
installFiles = @["config.nims"]

# Dependencies
requires "nim >= 0.19.6", "regex >= 0.13.0", "cligen >= 0.9.41"

import nimterop/docs

proc execCmd(cmd: string) =
  echo "execCmd:" & cmd
  exec cmd

proc execTest(test: string) =
  execCmd "nim c -f -r " & test
  execCmd "nim cpp -r " & test

task buildToast, "build toast":
  execCmd("nim c -f nimterop/toast.nim")

task bt, "build toast":
  execCmd("nim c -d:danger nimterop/toast.nim")

task docs, "Generate docs":
  buildDocs(@["nimterop/all.nim"], "build/htmldocs")

task test, "Test":
  buildToastTask()

  execTest "tests/tnimterop2.nim"

  # Commented out until newalgo is ready
  # execTest "tests/tnimterop_c.nim"
  # execCmd "nim cpp -f -r tests/tnimterop_cpp.nim"
  # execCmd "./nimterop/toast -pnk -E=_ tests/include/toast.h"
  # execTest "tests/tpcre.nim"

  # Platform specific tests
  # when defined(Windows):
  #   execTest "tests/tmath.nim"
  # if defined(OSX) or defined(Windows) or not existsEnv("TRAVIS"):
  #   execTest "tests/tsoloud.nim"

  # getHeader tests
  # withDir("tests"):
  #   execCmd("nim e getheader.nims")

  docsTask()
