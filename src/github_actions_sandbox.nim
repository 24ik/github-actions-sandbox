## GitHub Actions Sandbox.

const foo {.intdefine.} = 0
static:
  echo "defined danger", defined(danger)
  echo "foo", foo

when isMainModule:
  echo("Hello, sandbox!")

