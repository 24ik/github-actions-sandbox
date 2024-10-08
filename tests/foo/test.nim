discard """
  action: "run"
  targets: "js"
"""

import unittest

check 1 + 2 == 3

import std/os
static:
  echo when defined(js): "===JS===" else: "===C==="
  let s = currentSourcePath().parentDir.parentDir.parentDir / "github_actions_sandbox.nimble"
  echo "===DIR: ", s
  echo staticRead(s)
  echo "===FIN==="
when defined(windows):
  check false
