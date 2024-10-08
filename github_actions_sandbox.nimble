# Package

version       = "0.5.0"
author        = "Keisuke Izumiya"
description   = "A new awesome nimble package"
license       = "Apache-2.0"

srcDir        = "src"
installExt    = @["nim"]
bin           = @["github_actions_sandbox"]


# Dependencies

requires "nim ^= 2.2.0"

requires "karax ^= 1.3.3"
requires "nigui ^= 0.2.8"
requires "nimsimd ^= 1.2.13"


# Tasks

task test, "Test":
  exec "nimble -y build"
  exec "testament all"
