discard """
  action: "run"
  targets: "c js"
"""

import unittest

check 1 + 2 == 3

import std/os
staic:
  echo staticRead(currentSourcePath().parentDir.parentDir.parentDir / "github_actions_sandbox.nimble")
