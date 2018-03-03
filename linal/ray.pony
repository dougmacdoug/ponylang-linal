type R2 is (V3, V3)
"""R2 is a Ray as a tuple with (Position, Direction)"""
type AnyRay is (Ray | R2)

primitive R2fun
  fun zero(): R2 => (V3fun.zero(), V3fun(1, 0, 0))
  fun apply(p: V3, d: V3): R2 => (p, V3fun.unit(d))

  fun cast(a: V3, b: V3): R2 =>
  """casts a ray from Point a towards Point b"""
   apply(a, V3fun.sub(b, a))

  fun position(r3: R2): V3 => r3._1
  fun direction(r3: R2): V3 => r3._2

  fun to_string(r: R2): String iso^ =>
    recover
      let s = String(60)
      s.append("Ray[P:")
      s.append(V3fun.to_string(r._1))
      s.append(" D:")
      s.append(V3fun.to_string(r._2))
      s.push(']')
      s.>recalc()
    end

  fun get_point_at(r: R2, distance: F32): V3 =>
    """returns a point on ray at distance from position"""
    V3fun.add(r._1, V3fun.mul(r._2, distance))

  fun eq(a: R2, b: R2, eps: F32 = F32.epsilon()): Bool =>
    V3fun.eq(a._1, b._1, eps)  and V3fun.eq(a._2, b._2, eps)

class Ray is (Stringable & Equatable[Ray])
  embed _pos: Vector3 = Vector3
  embed _dir: Vector3 = Vector3.xyz(1, 0, 0)

  fun ref apply(r: box->AnyRay): Ray =>
    (let pos, let dir) =
    match r
    | let r' : R2 => r'
    | let r' : Ray box => r'.r2()
    end
    _pos() = pos
    _dir() = V3fun.unit(dir)
    this
  fun ref move_to(pt: box->AnyVector3): Ray =>
    _pos() = _MakeV3(pt)
    this

  fun ref aim_at(pt: box->AnyVector3): Ray =>
    let to = _MakeV3(pt)
    let rnew = R2fun.cast(_pos.v3(), to)
    _dir() = R2fun.direction(rnew)
    this

  fun ref update(r: (Ray box | R2)) =>
    apply(r)

  fun r2(): R2 => (_pos.v3(), _dir.v3())
  fun as_tuple(): R2 => r2()

  fun intersects_point(pt: V3): (V3 | None) =>
    Intersect.ray_point(r2(), pt)

  fun position(): Vector3 box => _pos
  fun direction(): Vector3 box => _dir

  fun box eq(that: box->AnyRay): Bool =>
    let mine = r2()
    let that' =
    match that
    | let r' : Ray box => r'.r2()
    | let r' : R2 => r'
    end
    R2fun.eq(mine, that')

  fun box ne(that: box->AnyRay): Bool => not eq(that)

  fun string(): String iso^ => R2fun.to_string(r2())
