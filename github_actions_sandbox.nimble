# Package

version       = "0.4.0"
author        = "Keisuke Izumiya"
description   = "A new awesome nimble package"
license       = "MIT"

srcDir        = "src"
installExt    = @["nim"]
bin           = @["github_actions_sandbox"]


# Dependencies

requires "nim ^= 2.0.0"

requires "nigui ^= 0.2.7"


# Tasks

task test, "Test":
  exec "nimble -y build"
  exec "testament all"
