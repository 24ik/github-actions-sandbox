discard """
  action: "run"
  targets: "c js"
"""

import unittest

check 1 + 2 == 3

import std/os
echo currentSourcePath().parentDir.parentDir.parentDir
echo currentSourcePath().parentDir.parentDir.parentDir.lastPathPart
