discard """
  action: "run"
  targets: "c js"
"""

import unittest

check 1 + 2 == 3

import std/os
static:
  echo staticRead(currentSourcePath().parentDir.parentDir.parentDir / "github_actions_sandbox.nimble")
when defined(windows):
  check false
