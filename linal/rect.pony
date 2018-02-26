type R4 is (V2, F32, F32)
"""
R4 (Rectangle) is Position, Width, Height

Position is always bottom left, also called origin

Height and Width are kept positive. When actions such
as create or resize cause a negative width or height,
the rectangle is "rectified" having its point of origin
shifted down and left to accomadate the size

```
((0, 0), -2, -3) -> ((-2, -3), 2, 3) [rectified] 
((-1, 2), 3, -1) -> ((-1, 1), 3, 1) [rectified] 
```
"""
type AnyRect is (Rect | R4)

primitive R4fun
"""rectangle operations for R4"""
  fun apply(x': F32, y': F32, w': F32, h': F32): R4 =>
    """create rectified R4"""
    rectify(((x', y'), w', h'))

  fun zero(): R4 =>
    """create zero R4"""
    ((0, 0), 0, 0)
    
  fun unit(): R4 =>
    """create unit R4"""
    ((0, 0), 1, 1)
    
  fun sized(w': F32, h': F32): R4 =>
    """create R4 starting at zero with rectified size *(w', h')*"""
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
  fun x_min(r: R4): F32 => r._1._1
  fun y_min(r: R4): F32 => r._1._2
  fun x_max(r: R4): F32 => r._1._1 + r._2
  fun y_max(r: R4): F32 => r._1._2 + r._3
  fun origin(r: R4): V2 => r._1

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

  fun shift(r: R4, dx: F32=0, dy: F32=0): R4 =>
    """move R4 by delta x, delta y"""
   ((r._1._1 + dx, r._1._2 + dy), r._2, r._3)

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

  fun contains(r: R4, pt': (V2 | V3)): Bool => 
    let pt: V2 = match pt'
    | let v2: V2 => v2
    | let v3: V3 => V3fun.v2(v3)
    end
    (r._1._1 <= pt._1) and ((r._1._1 + r._2) >= pt._1) and
    (r._1._2 <= pt._2) and ((r._1._2 + r._3) >= pt._2)

  fun overlaps(r: R4, other: R4): Bool =>
    (x_max(other) > x_min(r)) and
    (x_min(other) < x_max(r)) and
    (y_max(other) > y_min(r)) and
    (y_min(other) < y_max(r))

  fun normalized_to_point(r: R4, norm: V2): V2 =>
    (Linear.lerp(r._1._1, x_max(r), norm._1),
     Linear.lerp(r._1._2, y_max(r), norm._2))

  fun point_to_normalized(r: R4, pt: V2): V2 =>
      (Linear.unlerp(r._1._1, x_max(r), pt._1),
       Linear.unlerp(r._1._2, y_max(r), pt._2))

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
    (let pt, var w', var h') = r
    (var x', var y') = pt
    if w' < 0 then
      w' = -w'
      x' = x' - w'
    end
    if h' < 0 then
      h' = -h'
      y' = y' - h'
    end
    ((x', y'), w', h')


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

  new at(x': F32 = 0, y': F32 = 0, w': F32 = 0, h': F32 = 0) =>
    apply(R4fun(x', y', h', w'))

  new zero() =>(_x, _y, _w, _h) = (0, 0, 0, 0)
  new unit() =>(_x, _y, _w, _h) = (0, 0, 1, 1)

  new sized(w': F32, h': F32) =>
    apply(R4fun.sized(w', h'))

  new centered(pt: V2, w': F32, h': F32) =>
    apply(R4fun.centered(pt, w', h'))

  fun r4(): R4 => ((_x, _y), _w, _h)
  fun origin(): V2 => (_x, _y)
   // @todo: check out .> operator.. return this
  fun ref move(pt: V2) =>
    """move to point"""
    apply(R4fun.move(r4(), pt))

  fun ref shift(dx: F32 = 0, dy: F32 = 0) =>
    """move by delta X, delta Y"""
    apply(R4fun.shift(r4(), dx, dy))

  fun ref resize(w': F32, h': F32) =>
    """resize (negative values rectified)"""
    apply(R4fun(_x, _y, w', h'))

  fun ref resize_centered(w': F32, h': F32) =>
    """resize and keep centered"""
    apply(R4fun.resize_centered(r4(), w', h'))

  fun ref grow(x': F32 = 0, y': F32 = 0) =>
    """grow or shrink rectangle (rectified)"""
    apply(R4fun(_x, _y, _w + x', _h + y'))

  fun ref grow_centered(dw: F32 = 0, dh: F32 = 0) =>
    apply(R4fun.grow_centered(r4(), dw, dh))

   // @todo: check out .> operator.. return this
  fun ref move_centered(pt: V2) =>
    apply(R4fun.move_centered(r4(), pt))

  fun min(): V2 => R4fun.min(r4())
  fun max(): V2 => R4fun.max(r4())
  fun x_min(): F32 => R4fun.x_min(r4())
  fun y_min(): F32 => R4fun.y_min(r4())
  fun x_max(): F32 => R4fun.x_max(r4())
  fun y_max(): F32 => R4fun.y_max(r4())
  fun width(): F32 => R4fun.width(r4())
  fun height(): F32 => R4fun.height(r4())
  fun size(): (F32, F32) => R4fun.size(r4())
  fun center(): V2 => R4fun.center(r4())
  fun contains(pt: (V2 | V3)): Bool => R4fun.contains(r4(), pt)

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
