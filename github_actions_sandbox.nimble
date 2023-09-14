# Package

version       = "0.4.1"
author        = "Keisuke Izumiya"
description   = "A new awesome nimble package"
license       = "MIT"

srcDir        = "src"
installExt    = @["nim"]
bin           = @["github_actions_sandbox"]


# Dependencies

requires "nim ^= 2.0.0"

requires "nigui ^= 0.2.7"
requires "https://github.com/izumiya-keisuke/puyo-simulator ^= 0.11.7"


# Tasks

task test, "Test":
  exec "nimble install -d -p:\"-d:avx2=false\" -p:\"-d:bmi2=false\""
  exec "nimble -y build"
  exec "testament all"
