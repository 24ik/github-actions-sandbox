discard """
  action: "run"
  targets: "c cpp"
"""

import std/[bitops, unittest]
import nimsimd/[avx2]

when defined(gcc):
  {.passc: "-mavx2".}
  {.passl: "-mavx2".}

type
  Row = range[0 .. 12]
  Column = range[0 .. 5]

  WhichColor = object ## Indicates the color.
    color1: range[0'i64 .. 1'i64]
    color2: range[0'i64 .. 1'i64]

  BinaryField = M256i

func `==`(field1, field2: BinaryField): bool {.inline.} =
  bool mm256_testc_si256(mm256_setzero_si256(), mm256_xor_si256(field1, field2))

func `+`(field1, field2: BinaryField): BinaryField {.inline.} =
  mm256_or_si256(field1, field2)

func `-`(self, field: BinaryField): BinaryField {.inline.} =
  mm256_andnot_si256(field, self)

func initMask[T: int64 or uint64](left, right: T): BinaryField {.inline.} =
  ## Returns the mask.
  mm256_set_epi64x(left, right, left, right)

func leftRightMasks(col: Column): tuple[left: int64, right: int64] {.inline.} =
  ## Returns `(-1, 0)` if `col` is in {0, 1, 2}; otherwise returns `(0, -1)`.
  let left = [-1, -1, -1, 0, 0, 0][col]
  result = (left: left, right: -1 - left)

func cellMasks(row: Row, col: Column): tuple[left: int64, right: int64] {.inline.} =
  ## Returns two masks with only the bit at position `(row, col)` set to `1`.
  let (leftMask, rightMask) = col.leftRightMasks
  result = (
    left: bitand(0x0000_2000_0000_0000'i64 shr (16 * col + row), leftMask),
    right: bitand(
      0x0000_0000_0002_0000'i64 shl (16 * (Column.high - col) + Row.high - row),
      rightMask,
    ),
  )

func `[]`(self: BinaryField, row: Row, col: Column): WhichColor {.inline.} =
  let (left, right) = cellMasks(row, col)
  result = WhichColor(
    color1: mm256_testc_si256(self, mm256_set_epi64x(left, right, 0, 0)),
    color2: mm256_testc_si256(self, mm256_set_epi64x(0, 0, left, right)),
  )

func `[]=`(
    self: var BinaryField, row: Row, col: Column, which: WhichColor
) {.inline.} =
  let
    (left, right) = cellMasks(row, col)
    color1 = -which.color1
    color2 = -which.color2

  self =
    self - initMask(left, right) +
    mm256_set_epi64x(
      bitand(left, color1),
      bitand(right, color1),
      bitand(left, color2),
      bitand(right, color2),
    )

var field = mm256_setzero_si256()
when not defined(windows):
  for row in 3..5:
    check field[row, 2] == WhichColor(color1: 0, color2: 0)
    field[row, 2] = WhichColor(color1: 1, color2: 0)
    check field[row, 2] == WhichColor(color1: 1, color2: 0)
  for col in 1..3:
    check field[10, col] == WhichColor(color1: 0, color2: 0)
    field[10, col] = WhichColor(color1: 0, color2: 1)
    check field[10, col] == WhichColor(color1: 0, color2: 1)
