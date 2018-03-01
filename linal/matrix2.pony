type M2 is (V2, V2)
""" tuple based matrix alias 2x2"""

type AnyMatrix2 is (Matrix2 | M2)

primitive M2fun
  """functions for a 2x2 matrix"""
  fun apply(r1: V2, r2: V2): M2 =>
  """create M2 from 2 V2 vectors"""
    (r1, r2)
  fun zero(): M2 =>
  """zeroed M2"""
    ((0, 0), (0, 0))
  fun id(): M2 =>
  """identity matrix 2x2"""
    ((1, 0), (0, 1))
  fun row_x(m: M2): V2 =>
  """x or 1st row"""
    m._1
  fun row_y(m: M2): V2 =>
    """y or 2nd row"""
    m._2
  fun col_x(m: M2): V2 =>
    """x or 1st column"""
    (m._1._1, m._2._1)
  fun col_y(m: M2): V2 =>
    """y or 2nd column"""
    (m._1._2, m._2._2)

  fun from_array(a: Array[F32] box, offset: USize=0): M2 ? =>
    """M2 from flat array starting at offset"""
    (V2fun.from_array(a, 0 + offset)?,
     V2fun.from_array(a, 2 + offset)?)

  fun rot(angle: F32): M2 =>
    """M2 from angle"""
    let c : F32 = angle.cos()
    let s : F32 = angle.sin()
    ((c, -s), (s, c))

  fun add(a: M2, b: M2): M2  =>
    """a + b"""
    ((a._1._1 + b._1._1, a._1._2 + b._1._2),
     (a._2._1 + b._2._1, a._2._2 + b._2._2))

  fun sub(a: M2, b: M2): M2 =>
    """a - b"""
    ((a._1._1 - b._1._1, a._1._2 - b._1._2),
     (a._2._1 - b._2._1, a._2._2 - b._2._2))

  fun neg(a: M2): M2 =>
    """-a"""
    ((-a._1._1, -a._1._2), (-a._2._1, -a._2._2))

  fun mul(a: M2, s: F32): M2 =>
    """scale *a* by factor *s*"""
    ((a._1._1 * s, a._1._2 * s),
     (a._2._1 * s, a._2._2 * s))

  fun div(a: M2, s: F32): M2 => 
    """scale *a* by factor *1/s*"""
    mul(a, F32(1) / s)

  fun trans(a: M2): M2 =>
    """translate"""
    ((a._1._1, a._2._1), (a._1._2, a._2._2))

  fun v2_mul(a: M2, v: V2): V2 =>
    """matrix * vector multiplication"""
    ( (a._1._1*v._1) + (a._1._2* v._2), (a._2._1*v._1) + (a._2._2*v._2))

  fun m2_mul(a: M2, b: M2): M2 =>
    """matrix * matrix multiplication"""
    (((a._1._1 * b._1._1) + (a._1._2 * b._2._1),
      (a._1._1 * b._1._2) + (a._1._2 * b._2._2)),
     ((a._2._1 * b._1._1) + (a._2._2 * b._2._1),
      (a._2._1 * b._1._2) + (a._2._2 * b._2._2)))

  fun trace(m: M2): F32 =>
    """trace / sum id"""
    m._1._1 + m._2._2
  fun det(m: M2): F32 =>
    """determinant"""
    (m._1._1 * m._2._2) - (m._1._2 * m._2._1)
  fun inv(m: M2): (M2 | None) =>
    """inverse"""
    let d = det(m)
    if Linear.eq(d, 0) then return None end
    let m2 = ((m._2._2, -m._1._2), (-m._2._1, m._1._1))
    mul(m2, 1/d)
  fun solve(m: M2, v: V2): (V2 | None) =>
    """solve [2x2][2]"""
    let d = -det(m)
    if d == 0 then return None end
    ((((m._1._2 * v._2) - (m._2._2 * v._1)) / d),
     (((m._2._1 * v._1) - (m._1._1 * v._2)) / d))

  fun eq(a: M2, b: M2, eps: F32 = F32.epsilon()): Bool =>
    """a == b"""
    Linear.eq(a._1._1, b._1._1, eps) and
    Linear.eq(a._1._2, b._1._2, eps) and
    Linear.eq(a._2._1, b._2._1, eps) and
    Linear.eq(a._2._2, b._2._2, eps)

  fun to_string(m: M2): String iso^  =>
    """string format a matrix"""
    recover
      var s = String(600)
      s.push('(')
      s.append(V2fun.to_string(m._1))
      s.push(',')
      s.append(V2fun.to_string(m._2))
      s.push(')')
      s.>recalc()
    end

class Matrix2 is (Stringable & Equatable[Matrix2])
  var _m11 : F32 = 0
  var _m12 : F32 = 0
  var _m21 : F32 = 0
  var _m22 : F32 = 0
  
  new create() =>
    """zeroed 2x2 matrix"""
  new id() => apply(M2fun.id())

  new rot(angle: F32) =>
    """rotation matrix from angle"""
    apply(M2fun.rot(angle))

  fun ref apply(m': box->AnyMatrix2): Matrix2 =>
    ((_m11, _m12),
     (_m21, _m22)) = _tuplize(m')
    this

  fun ref update(value: box->AnyMatrix2) => apply(value)

  fun m2(): M2 =>
    ((_m11, _m12),
     (_m21, _m22))

  fun _tuplize(that: box->AnyMatrix2): M2 =>
    match that
    | let m: M2 => m
    | let m: Matrix2 box => m.m2()
    end
  // convenience methods
  fun add(that: box->AnyMatrix2): M2 => M2fun.add(m2(), _tuplize(that))
  fun sub(that: box->AnyMatrix2): M2 => M2fun.sub(m2(), _tuplize(that))
  fun mul(s: F32): M2 => M2fun.mul(m2(), s)
  fun div(s: F32): M2 => M2fun.div(m2(), s)
  fun neg(): M2 => M2fun.neg(m2())
  fun row_x(): V2 => M2fun.row_x(m2())
  fun row_y(): V2 => M2fun.row_y(m2())
  fun col_x(): V2 => M2fun.col_x(m2())
  fun col_y(): V2 => M2fun.col_y(m2())

  fun trans(): M2 => M2fun.trans(m2())
  fun v2_mul(v: V2): V2 => M2fun.v2_mul(m2(), v)
  fun m2_mul(that: M2): M2 => M2fun.m2_mul(m2(), that)
  fun trace(): F32 => M2fun.trace(m2())
  fun det(): F32 => M2fun.det(m2())
  fun inv(): (M2 | None)  => M2fun.inv(m2())
  fun solve(v: V2): (V2 | None) => M2fun.solve(m2(), v)

  fun get(index: (USize | (USize, USize))): F32 ? =>
    """get cell value. flat array index or (row, col)"""
    match _Mindex(index, 2)
    | (1, 1) => _m11
    | (1, 2) => _m12
    | (2, 1) => _m21
    | (2, 2) => _m22
    else
      error
    end

  fun ref set(index: (USize | (USize, USize)), value: F32): F32 ? =>
    """set cell value return old value. flat array index or (row, col)"""
    let old = get(index)?
    match _Mindex(index, 2)
    | (1, 1) => _m11 = value
    | (1, 2) => _m12 = value
    | (2, 1) => _m21 = value
    | (2, 2) => _m22 = value
    else
      error
    end
    old

  fun string(): String iso^ => M2fun.to_string(m2())

  fun box eq(that: box->AnyMatrix2): Bool => M2fun.eq(m2(), _tuplize(that))
  fun box ne(that: box->AnyMatrix2): Bool => not(eq(that))
