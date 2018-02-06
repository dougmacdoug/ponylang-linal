type M3 is (V3, V3, V3)
""" tuple based matrix alias 3x3"""

primitive M3fun
  """functions for a 3x3 matrix"""

  fun apply(r1: V3, r2: V3, r3: V3): M3 =>
    """create M3 from 3 V3 vectors"""
    (r1, r2, r3)
  fun zero(): M3 =>
    """zeroed M3"""
    ((0, 0, 0), (0, 0, 0), (0, 0, 0))
  fun id(): M3 =>
    """identity matrix 3x3"""
    ((1, 0, 0), (0, 1, 0), (0, 0, 1))
  fun rowx(m: M3): V3 =>
    """x or 1st row"""
    m._1
  fun rowy(m: M3): V3 =>
    """y or 2nd row"""
    m._2
  fun rowz(m: M3): V3 =>
    """z or 3rd row"""
    m._3
  fun colx(m: M3): V3 =>
    """x or 1st column"""
    (m._1._1, m._2._1, m._3._1)
  fun coly(m: M3): V3 =>
    """y or 2nd column"""
    (m._1._2, m._2._2, m._3._2)
  fun colz(m: M3): V3 =>
    """z or 3rd column"""
    (m._1._3, m._2._3, m._3._3)

  fun from_array(a: Array[F32] box, offset: USize=0): M3 ? =>
    """M3 from flat array starting at offset"""
    (V3fun.from_array(a, 0 + offset)?,
     V3fun.from_array(a, 3 + offset)?,
     V3fun.from_array(a, 6 + offset)?)

  fun rotx(angle: F32): M3 =>
    """rotatation matrix around x axis"""
    let c : F32 = angle.cos()
    let s : F32 = angle.sin()
    ((1, 0, 0), (0, c, -s), (0, s, c))
  fun roty(angle: F32): M3 =>
    """rotatation matrix around y axis"""
    let c : F32 = angle.cos()
    let s : F32 = angle.sin()
    ((c, 0, s), (0, 1, 0), (-s, 0, c))
  fun rotz(angle: F32): M3 =>
    """rotatation matrix around z axis"""
    let c : F32 = angle.cos()
    let s : F32 = angle.sin()
    ((c, -s, 0), (s, c, 0), (0, 0, 1))

  fun add(a: M3, b: M3): M3 =>
    """a + b"""
    ((a._1._1 + b._1._1, a._1._2 + b._1._2, a._1._3 + b._1._3),
     (a._2._1 + b._2._1, a._2._2 + b._2._2, a._2._3 + b._2._3),
     (a._3._1 + b._3._1, a._3._2 + b._3._2, a._3._3 + b._3._3))

  fun sub(a: M3, b: M3)  : M3 =>
    """a - b"""
    ((a._1._1 - b._1._1, a._1._2 - b._1._2, a._1._3 - b._1._3),
     (a._2._1 - b._2._1, a._2._2 - b._2._2, a._2._3 - b._2._3),
     (a._3._1 - b._3._1, a._3._2 - b._3._2, a._3._3 - b._3._3))

  fun neg(a: M3): M3 =>
    """-a"""
    ((-a._1._1, -a._1._2, -a._1._3),
     (-a._2._1, -a._2._2, -a._2._3),
     (-a._3._1, -a._3._2, -a._3._3))

  fun mul(a: M3, s: F32): M3 =>
    """scale *a* by factor *s*"""
    ((a._1._1 * s, a._1._2 * s, a._1._3 * s),
     (a._2._1 * s, a._2._2 * s, a._2._3 * s),
     (a._3._1 * s, a._3._2 * s, a._3._3 * s))

  fun div(a: M3, s: F32): M3 =>
    """scale *a* by factor *1/s*"""
    mul(a, F32(1)/s)

  fun trans(a: M3): M3 =>
    """translate"""
    ((a._1._1, a._2._1, a._3._1),
     (a._1._2, a._2._2, a._3._2),
     (a._1._3, a._2._3, a._3._3))

  fun v3_mul(a: M3, v: V3): V3 =>
    """matrix * vector multiplication"""
    ((a._1._1 * v._1) + (a._1._2 * v._2) + (a._1._3 * v._3),
     (a._2._1 * v._1) + (a._2._2 * v._2) + (a._2._3 * v._3),
     (a._3._1 * v._1) + (a._3._2 * v._2) + (a._3._3 * v._3))

  fun m3_mul(a: M3, b: M3): M3 =>
    (((a._1._1 * b._1._1) + (a._1._2 * b._2._1) + (a._1._3 * b._3._1),
      (a._1._1 * b._1._2) + (a._1._2 * b._2._2) + (a._1._3 * b._3._2),
      (a._1._1 * b._1._3) + (a._1._2 * b._2._3) + (a._1._3 * b._3._3)),
     ((a._2._1 * b._1._1) + (a._2._2 * b._2._1) + (a._2._3 * b._3._1),
      (a._2._1 * b._1._2) + (a._2._2 * b._2._2) + (a._2._3 * b._3._2),
      (a._2._1 * b._1._3) + (a._2._2 * b._2._3) + (a._2._3 * b._3._3)),
     ((a._3._1 * b._1._1) + (a._3._2 * b._2._1) + (a._3._3 * b._3._1),
      (a._3._1 * b._1._2) + (a._3._2 * b._2._2) + (a._3._3 * b._3._2),
      (a._3._1 * b._1._3) + (a._3._2 * b._2._3) + (a._3._3 * b._3._3)))

  fun trace(m: M3): F32 =>
    """trace"""
    m._1._1 + m._2._2 + m._3._3

  fun det(m: M3): F32 =>
    """determinant"""
    (m._1._1 * m._2._2 * m._3._3) +
    (m._1._2 * m._2._3 * m._3._1) +
    ((m._2._1 * m._3._2 * m._1._3) -
     (m._1._3 * m._2._2 * m._3._1) -
     (m._1._1 * m._2._3 * m._3._2) -
     (m._1._2 * m._2._1 * m._3._3))

  fun inv(m: M3): M3 ? =>
    """inverse"""
    let d =  det(m)
    if d == 0 then error end
    ((((m._2._2 * m._3._3) - (m._2._3 * m._3._2)) / d,
      ((m._3._2 * m._1._3) - (m._3._3 * m._1._2)) / d,
      ((m._1._2 * m._2._3) - (m._1._3 * m._2._2)) / d),
     (((m._2._3 * m._3._1) - (m._2._1 * m._3._3)) / d,
      ((m._3._3 * m._1._1) - (m._3._1 * m._1._3)) / d,
      ((m._1._3 * m._2._1) - (m._1._1 * m._2._3)) / d),
     (((m._2._1 * m._3._2) - (m._2._2 * m._3._1)) / d,
      ((m._3._1 * m._1._2) - (m._3._2 * m._1._1)) / d,
      ((m._1._1 * m._2._2) - (m._1._2 * m._2._1)) / d))

  fun solve(m: M3, v: V3): V3 ? =>
    """solve"""
    let d  = det(m)
    if Linear.eq(d, 0) then error end
    let dx = det(((v._1, m._1._2, m._1._3),
                  (v._2, m._2._2, m._2._3),
                  (v._3, m._3._2, m._3._3)))
    let dy = det(((m._1._1, v._1, m._1._3),
                  (m._2._1, v._2, m._2._3),
                  (m._3._1, v._3, m._3._3)))
    let dz = det(((m._1._1, m._1._2, v._1),
                  (m._2._1, m._2._2, v._2),
                  (m._3._1, m._3._2, v._3)))
    (dx/d, dy/d, dz/d)

  fun eq(a: M3, b: M3, eps: F32 = F32.epsilon()): Bool =>
    """a == b"""
    Linear.eq(a._1._1, b._1._1, eps) and
    Linear.eq(a._1._2, b._1._2, eps) and
    Linear.eq(a._1._3, b._1._3, eps) and
    Linear.eq(a._2._1, b._2._1, eps) and
    Linear.eq(a._2._2, b._2._2, eps) and
    Linear.eq(a._2._3, b._2._3, eps) and
    Linear.eq(a._3._1, b._3._1, eps) and
    Linear.eq(a._3._2, b._3._2, eps) and
    Linear.eq(a._3._3, b._3._3, eps)

  fun to_string(m: M3): String iso^  =>
    """string format a matrix"""
    recover
      var s = String(600)
      s.push('(')
      s.append(V3fun.to_string(m._1))
      s.push(',')
      s.append(V3fun.to_string(m._2))
      s.push(',')
      s.append(V3fun.to_string(m._3))
      s.push(')')
      s.>recalc()
    end

type AnyMatrix3 is (Matrix3 | M3)

class Matrix3 is (Stringable & Equatable[Matrix3])
  var _m11 : F32 = 0
  var _m12 : F32 = 0
  var _m13 : F32 = 0
  var _m21 : F32 = 0
  var _m22 : F32 = 0
  var _m23 : F32 = 0
  var _m31 : F32 = 0
  var _m32 : F32 = 0
  var _m33 : F32 = 0

  new create() =>
    """zeroed 3x3 matrix"""
  new id() => apply(M3fun.id())

  new rotx(angle: F32) =>
    """rotation matrix from angle"""
    apply(M3fun.rotx(angle))
  
  new roty(angle: F32) =>
    """rotation matrix from angle"""
    apply(M3fun.roty(angle))
  
  new rotz(angle: F32) =>
    """rotation matrix from angle"""
    apply(M3fun.rotz(angle))

  fun ref apply(m': box->AnyMatrix3): Matrix3 =>
    ((_m11, _m12, _m13),
     (_m21, _m22, _m23),
     (_m31, _m32, _m33)) = _tuplize(m')
    this

  fun ref update(value: box->AnyMatrix3) => apply(value)

  fun m3(): M3 =>
    ((_m11, _m12, _m13),
     (_m21, _m22, _m23),
     (_m31, _m32, _m33))

  fun _tuplize(that: box->AnyMatrix3): M3 =>
    match that
    | let m: M3 => m
    | let m: Matrix3 box => m.m3()
    end

  // convenience methods
  fun add(that: box->AnyMatrix3): M3 => M3fun.add(m3(), _tuplize(that))
  fun sub(that: box->AnyMatrix3): M3 => M3fun.sub(m3(), _tuplize(that))
  fun mul(s: F32): M3 => M3fun.mul(m3(), s)
  fun div(s: F32): M3 => M3fun.div(m3(), s)
  fun neg(): M3 => M3fun.neg(m3())
  fun rowx(): V3 => M3fun.rowx(m3())
  fun rowy(): V3 => M3fun.rowy(m3())
  fun rowz(): V3 => M3fun.rowz(m3())
  fun colx(): V3 => M3fun.colx(m3())
  fun coly(): V3 => M3fun.coly(m3())
  fun colz(): V3 => M3fun.colz(m3())

  fun trans(): M3 => M3fun.trans(m3())
  fun v3_mul(v: V3): V3 => M3fun.v3_mul(m3(), v)
  fun m3_mul(that: M3): M3 => M3fun.m3_mul(m3(), that)
  fun trace(): F32 => M3fun.trace(m3())
  fun det(): F32 => M3fun.det(m3())
  fun inv(): M3 ? => M3fun.inv(m3())?
  fun solve(v: V3): V3 ? => M3fun.solve(m3(), v)?

  fun get(index: (USize | (USize, USize))): F32 ? =>
    """get cell value. flat array index or (row, col)"""
    match _Mindex(index, 3)
    | (1, 1) => _m11
    | (1, 2) => _m12
    | (1, 3) => _m13
    | (2, 1) => _m21
    | (2, 2) => _m22
    | (2, 3) => _m23
    | (3, 1) => _m31
    | (3, 2) => _m32
    | (3, 3) => _m33
   else
      error
    end

  fun ref set(index: (USize | (USize, USize)), value: F32): F32 ? =>
    """set cell value return old value. index flat 0-15 or (row, col)"""
    let old = get(index)?
    match _Mindex(index, 3)
    | (1, 1) => _m11 = value
    | (1, 2) => _m12 = value
    | (1, 3) => _m13 = value
    | (2, 1) => _m21 = value
    | (2, 2) => _m22 = value
    | (2, 3) => _m23 = value
    | (3, 1) => _m31 = value
    | (3, 2) => _m32 = value
    | (3, 3) => _m33 = value
    else
      error
    end
    old

  fun string(): String iso^ => M3fun.to_string(m3())

  fun box eq(that: box->AnyMatrix3): Bool => M3fun.eq(m3(), _tuplize(that))
  fun box ne(that: box->AnyMatrix3): Bool => not(eq(that))
