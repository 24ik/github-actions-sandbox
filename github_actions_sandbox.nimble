# Package

version       = "0.3.1"
author        = "Keisuke Izumiya"
description   = "A new awesome nimble package"
license       = "MIT"

srcDir        = "src"
installExt    = @["nim"]
bin           = @["github_actions_sandbox"]


# Dependencies

requires "nim >= 1.6.12"


# Tasks

task test, "Test":
  exec "nimble -y build"
  exec "testament all"
