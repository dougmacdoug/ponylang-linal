// Rectangle is Pivot (Bottom Left) and Size
type R4 is (V2, F32, F32)
"""
R4 (Rectangle) is Position, Width, Height

Position is always bottom left or more accurately minX, minY
"""

primitive R4fun
  fun apply(x': F32, y': F32, w': F32, h': F32): R4 =>((x', y'), w', h')

  fun zero(): R4 => ((0, 0), 0, 0)
  fun unit(): R4 => ((0, 0), 1, 1)
  fun sized(w': F32, h': F32): R4 => ((0, 0), w', h')
  fun moved(r: R4, pt: V2): R4 => (pt, r._2, r._3)

  fun min(r: R4): V2 => r._1
  fun max(r: R4): V2 => (r._1._1 + r._2, r._1._2 + r._3)
  fun xMin(r: R4): F32 => r._1._1
  fun yMin(r: R4): F32 => r._1._2
  fun xMax(r: R4): F32 => r._1._1 + r._2
  fun yMax(r: R4): F32 => r._1._2 + r._3

  fun width(r: R4): F32 => r._2
  fun height(r: R4): F32 => r._3
  fun size(r: R4): (F32, F32) => (r._2, r._3)

  fun center(r: R4): V2 => 
    ((r._1._1 + r._2) / 2, (r._1._2 + r._3) / 2)

  fun center_on(r: R4, pt: V2): R4 => 
    ((pt._1 - (r._2 / 2), pt._2 - (r._3 / 2)), r._2, r._3)

  fun from_center(pt: V2, w': F32, h': F32): R4 => 
    ((pt._1 - (w' / 2), pt._2 - (h' / 2)), w', h')

  fun contains(r: R4, pt: V2): Bool =>
    (r._1._1 <= pt._1) and ((r._1._1 + r._2) >= pt._1) and
    (r._1._2 <= pt._2) and ((r._1._2 + r._3) >= pt._2)

  fun contains(r: R4, pt: V3): Bool => contains(r, V3fun.v2(pt))

  fun overlaps(r: R4, other: R4): Bool =>
    (xMax(other) > xMin(r)) and
    (xMin(other) < xMax(r)) and
    (yMax(other) > yMin(r)) and
    (yMin(other) < yMax(r))

  fun normalized_to_point(r: R4, norm: V2): V2 =>
    (Linear.lerp(r._1._1, xMax(r), norm._1),
     Linear.lerp(r._1._2, yMax(r), norm._2))

  fun point_to_normalized(r: R4, pt: V2): V2 =>
      (Linear.unlerp(r._1._1, xMax(r), pt._1),
       Linear.unlerp(r._1._2, yMax(r), pt._2))

  fun eq(lhs: R4, rhs: R4): Bool =>
    (lhs._1._1 == rhs._1._1) and (lhs._1._2 == rhs._1._2) and
     (lhs._2 == rhs._2) and (lhs._3 == rhs._3)

  fun to_string(r: R4) : String iso^ =>
    """string format a vector"""
    recover
      var s = String(170)
      s.append("(x: ")
      s.append(r._1._1.string())
      s.append(", y: ")
      s.append(r._1._2.string())
      s.append(", w: ")
      s.append(r._2.string())
      s.append(", h: ")
      s.append(r._3.string())
      s.push(')')
      s.>recalc()
      s
    end

type AnyRect is (Rect | R4)

class Rect is (Stringable & Equatable[Rect])
  var _x: F32
  var _y: F32
  var _w: F32
  var _h: F32

  new create(x': F32, y': F32, w': F32, h': F32) =>
    (_x, _y, _w, _h) = (x', y', w', h')

  fun ref update(r: (Rect box | R4)) => 
    ((_x, _y), _w, _h) =
    match r
    | let r' : Rect box => r'.r4()
    | let r' : R4 => r'
    end

  fun r4(): R4 => ((_x, _y), _w, _h)

  new zero() =>(_x, _y, _w, _h) = (0, 0, 0, 0)
  new unit() =>(_x, _y, _w, _h) = (0, 0, 1, 1)

  new sized(w': F32, h': F32) => (_x, _y, _w, _h) = (0, 0, w', h')

  new from_center(pt: V2, w': F32, h': F32) => 
    ((_x, _y), _w, _h) = R4fun.from_center(pt, w', h')

   // @todo: check out .> operator.. return this
  fun ref move(pt: V2) => (_x, _y) = pt

   // @todo: check out .> operator.. return this
  fun ref center_on(pt: V2) =>
    update(R4fun.center_on(r4(), pt))

  fun min(): V2 => R4fun.min(r4())
  fun max(): V2 => R4fun.max(r4())
  fun xMin(): F32 => R4fun.xMin(r4())
  fun yMin(): F32 => R4fun.yMin(r4())
  fun xMax(): F32 => R4fun.xMax(r4())
  fun yMax(): F32 => R4fun.yMax(r4())
  fun width(): F32 => R4fun.width(r4())
  fun height(): F32 => R4fun.height(r4())
  fun size(): (F32, F32) => R4fun.size(r4())
  fun center(): V2 => R4fun.center(r4())

  fun contains(pt: V2): Bool => R4fun.contains(r4(), pt)
  fun contains(pt: V3): Bool => R4fun.contains(r4(), pt)

  fun overlaps(that: box->AnyRect): Bool => 
    let mine = r4()
    let that' =
    match that
    | let r' : Rect box => r'.r4()
    | let r' : R4 => r'
    end
    R4fun.overlaps(mine, that')

  fun normalized_to_point(norm: V2): V2 =>
    R4fun.normalized_to_point(r4(), norm)

  fun point_to_normalized(pt: V2): V2 =>
    R4fun.point_to_normalized(r4(), pt)

  fun box eq(that: box->AnyRect): Bool => 
    let mine = r4()
    let that' =
    match that
    | let r' : Rect box => r'.r4()
    | let r' : R4 => r'
    end
    R4fun.eq(mine, that')

  fun box ne(that: box->AnyRect): Bool => not eq(that)

  fun string(): String iso^ => R4fun.to_string(r4())
