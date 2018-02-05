// Rectangle is Pivot (Bottom Left) and Size
type R4 is (V2, F32, F32)
"""
R4 (Rectangle) is Position, Width, Height

Position is always bottom left or more accurately minX, minY
"""

primitive R4fun
"""rectangle operations for R4"""
/** SIMULATED NEW:  CREATE R4  **/
  fun apply(x': F32, y': F32, w': F32, h': F32): R4 =>
    """create R4"""
    rectify(((x', y'), w', h'))

  fun zero(): R4 =>
    """create zero R4"""
    ((0, 0), 0, 0)
    
  fun unit(): R4 =>
    """create unit R4"""
    ((0, 0), 1, 1)
    
  fun sized(w': F32, h': F32): R4 =>
    """create R4 at zero with size *(w', h')*"""
    rectify(((0, 0), w', h'))

  fun centered(pt: V2, w': F32, h': F32): R4 =>
    """create R4 centered on point  *pt*  with size *(w', h')*"""
    rectify(((pt._1 - (w' / 2), pt._2 - (h' / 2)), w', h'))

  fun min(r: R4): V2 =>
    """smallest point in R4 (bottom left corner)"""
    r._1
  fun max(r: R4): V2 =>
    """largest point in R4 (top right corner)"""
    (r._1._1 + r._2, r._1._2 + r._3)
  fun xMin(r: R4): F32 => r._1._1
  fun yMin(r: R4): F32 => r._1._2
  fun xMax(r: R4): F32 => r._1._1 + r._2
  fun yMax(r: R4): F32 => r._1._2 + r._3

  fun width(r: R4): F32 => r._2
  fun height(r: R4): F32 => r._3
  fun size(r: R4): (F32, F32) => (r._2, r._3)

  fun center(r: R4): V2 =>
    """get center point of R4"""
    ((r._1._1 + r._2) / 2, (r._1._2 + r._3) / 2)

  fun move(r: R4, pt: V2): R4 =>
    """move R4 to point"""
   (pt, r._2, r._3)

  fun move_centered(r: R4, pt: V2): R4 =>
    """move R4 to be centered on point"""
    move(r, (pt._1 - (r._2 / 2), pt._2 - (r._3 / 2)))

  fun resize(r: R4, w': F32, h': F32): R4 =>
    rectify((r._1, w', h'))

  fun resize_centered(r: R4, w': F32, h': F32): R4 =>
    let pos_w = w'.abs()
    let pos_h = h'.abs()
    let c = V2fun.sub(center(r), (pos_w / 2, pos_h / 2))
    (c, pos_w, pos_h)

  fun grow(r: R4, dx: F32, dy: F32): R4 =>
    resize(r, r._2 + dx, r._3 + dy)

  fun grow_centered(r: R4, dx: F32, dy: F32): R4 =>
    resize_centered(r, r._2 + dx, r._3 + dy)

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
    """string format a rectangle"""
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

  fun rectify(r: R4): R4 =>
    ((var x', var y'), var w', var h') = r
    if w' < 0 then
      w' = -w'
      x' = x' - w'
    end
    if h' < 0 then
      h' = -h'
      y' = y' - h'
    end
    ((x', y'), w', h')

  fun is_rectified(r: R4): Bool =>
    if (r._2 < 0) or (r._3 < 0) then false else true end

type AnyRect is (Rect | R4)

class Rect is (Stringable & Equatable[Rect])
  var _x: F32 = 0
  var _y: F32 = 0
  var _w: F32 = 0
  var _h: F32 = 0


  fun ref apply(r: (Rect box | R4)): Rect =>
    ((_x, _y), _w, _h) =
    match r
    | let r' : R4 => R4fun.rectify(r')
    | let r' : Rect box => r'.r4()
    end
    this

  fun ref update(r: (Rect box | R4)) =>
    apply(r)

  new zero() =>(_x, _y, _w, _h) = (0, 0, 0, 0)
  new unit() =>(_x, _y, _w, _h) = (0, 0, 1, 1)

  new sized(w': F32, h': F32) =>
    ((_x, _y), _w, _h) = R4fun.sized(w', h')

  new centered(pt: V2, w': F32, h': F32) =>
    ((_x, _y), _w, _h) = R4fun.centered(pt, w', h')

  fun r4(): R4 => ((_x, _y), _w, _h)

   // @todo: check out .> operator.. return this
  fun ref move_to(pt: V2) => (_x, _y) = pt

  fun ref move_by(x': F32 = 0, y': F32 = 0) =>
    (_x, _y) = (_x + x', _y + y')

  fun ref resize(w': F32, h': F32) =>
    ((_x, _y), _w, _h) = R4fun(_x, _y, w', h')

  fun ref resize_centered(w': F32, h': F32) =>
    ((_x, _y), _w, _h) = R4fun.resize_centered(r4(), w', h')

  fun ref grow(x': F32 = 0, y': F32 = 0) =>
    ((_x, _y), _w, _h) = R4fun(_x, _y, _w + x', _h + y')

  fun ref grow_centered(x': F32 = 0, y': F32 = 0) =>
    ((_x, _y), _w, _h) =
    R4fun(_x - (x'.abs() / 2),
          _y - (y'.abs() / 2),
          _w + x', _h + y')

   // @todo: check out .> operator.. return this
  fun ref move_centered(pt: V2) =>
    ((_x, _y), _w, _h) = R4fun.move_centered(r4(), pt)

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
