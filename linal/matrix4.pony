type M4 is (V4, V4, V4, V4)
""" tuple based matrix alias 4x4"""

primitive M4fun
  """functions for a 4x4 matrix"""
  fun apply(r1: V4, r2: V4, r3: V4, r4: V4): M4 =>
    """create M4 from 4 V4 vectors"""
    (r1, r2, r3, r4)
  fun zero(): M4 =>
    """zeroed M4"""
    ((0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0))
  fun id(): M4 =>
    """identity matrix 4x4"""
    ((1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1))
  fun row_x(m: M4): V4 =>
    """x or 1st row"""
    m._1
  fun row_y(m: M4): V4 =>
    """y or 2nd row"""
    m._2
  fun row_z(m: M4): V4 =>
    """z or 3rd row"""
    m._3
  fun row_w(m: M4): V4 =>
    """w or 4th row"""
    m._4
  fun col_x(m: M4): V4 =>
    """x or 1st column"""
    (m._1._1, m._2._1, m._3._1, m._4._1)
  fun col_y(m: M4): V4 =>
    """y or 2nd column"""
    (m._1._2, m._2._2, m._3._2, m._4._2)
  fun col_z(m: M4): V4 =>
    """z or 3rd column"""
    (m._1._3, m._2._3, m._3._3, m._4._3)
  fun col_w(m: M4): V4 =>
    """w or 3rd column"""
    (m._1._4, m._2._4, m._3._4, m._4._4)
  fun from_array(a: Array[F32] box, offset: USize=0): M4 ? =>
    """M4 from flat array starting at offset"""
    (V4fun.from_array(a, 0 + offset)?, V4fun.from_array(a,  4 + offset)?,
     V4fun.from_array(a, 8 + offset)?, V4fun.from_array(a, 12 + offset)?)

  fun add(a: M4, b: M4): M4 =>
    """a + b"""
    ((a._1._1 + b._1._1,  a._1._2 + b._1._2,
      a._1._3 + b._1._3,  a._1._4 + b._1._4),
     (a._2._1 + b._2._1,  a._2._2 + b._2._2,
      a._2._3 + b._2._3,  a._2._4 + b._2._4),
     (a._3._1 + b._3._1,  a._3._2 + b._3._2,
      a._3._3 + b._3._3,  a._3._4 + b._3._4),
     (a._4._1 + b._4._1,  a._4._2 + b._4._2,
      a._4._3 + b._4._3,  a._4._4 + b._4._4))

  fun sub(a: M4, b: M4): M4 =>
    """a - b"""
    ((a._1._1 - b._1._1,  a._1._2 - b._1._2,
      a._1._3 - b._1._3,  a._1._4 - b._1._4),
     (a._2._1 - b._2._1,  a._2._2 - b._2._2,
      a._2._3 - b._2._3,  a._2._4 - b._2._4),
     (a._3._1 - b._3._1,  a._3._2 - b._3._2,
      a._3._3 - b._3._3,  a._3._4 - b._3._4),
     (a._4._1 - b._4._1,  a._4._2 - b._4._2,
      a._4._3 - b._4._3,  a._4._4 - b._4._4))

  fun neg(a: M4): M4 =>
    """-a"""
    ((-a._1._1, -a._1._2, -a._1._3, -a._1._4),
     (-a._2._1, -a._2._2, -a._2._3, -a._2._4),
     (-a._3._1, -a._3._2, -a._3._3, -a._3._4),
     (-a._4._1, -a._4._2, -a._4._3, -a._4._4))

  fun mul(a: M4, s: F32): M4 =>
    """scale *a* by factor *s*"""
    ((a._1._1 * s, a._1._2 * s, a._1._3 * s, a._1._4 * s),
     (a._2._1 * s, a._2._2 * s, a._2._3 * s, a._2._4 * s),
     (a._3._1 * s, a._3._2 * s, a._3._3 * s, a._3._4 * s),
     (a._4._1 * s, a._4._2 * s, a._4._3 * s, a._4._4 * s))

  fun div(a: M4, s: F32): M4 =>
    """scale *a* by factor *1/s*"""
    ((a._1._1 / s, a._1._2 / s, a._1._3 / s, a._1._4 / s),
     (a._2._1 / s, a._2._2 / s, a._2._3 / s, a._2._4 / s),
     (a._3._1 / s, a._3._2 / s, a._3._3 / s, a._3._4 / s),
     (a._4._1 / s, a._4._2 / s, a._4._3 / s, a._4._4 / s))

  fun trans(a: M4): M4 =>
    """translate"""
    ((a._1._1, a._2._1, a._3._1, a._4._1),
     (a._1._2, a._2._2, a._3._2, a._4._2),
     (a._1._3, a._2._3, a._3._3, a._4._3),
     (a._1._4, a._2._4, a._3._4, a._4._4))

  fun trans_v3(v : V3): M4 =>
    """translate vector 3"""
    ((1, 0, 0, v._1),
    (0, 1, 0, v._2),
    (0, 0, 1, v._3),
    (0, 0, 0, 1))

  fun scale_v3(v: V3): M4 =>
    """scale v3"""
    ((v._1,     0,   0, 0),
     (   0,  v._2,   0, 0),
     (   0,     0, v._3, 0),
     (   0,     0,   0, 1))

  fun mul_v3(a: M4, v: V3): V3 =>
    """multiply matrix4 * vector3"""
    ((a._1._1 * v._1) + (a._1._2 * v._2) + (a._1._3 * v._3),
     (a._2._1 * v._1) + (a._2._2 * v._2) + (a._2._3 * v._3),
     (a._3._1 * v._1) + (a._3._2 * v._2) + (a._3._3 * v._3))

  fun mul_v3_point_3x4(a: M4, v: V3): V3 =>
    """multiply point matrix * vector"""
    ((a._1._1 * v._1) + (a._1._2 * v._2) + (a._1._3 * v._3) + a._1._4,
     (a._2._1 * v._1) + (a._2._2 * v._2) + (a._2._3 * v._3) + a._2._4,
     (a._3._1 * v._1) + (a._3._2 * v._2) + (a._3._3 * v._3) + a._3._4)

  fun mul_v3_point(a: M4, v: V3): V3 =>
    """multiply point matrix * vector"""
    let v3 = mul_v3_point_3x4(a, v)
    let n  = (a._4._1 * v._1) + (a._4._2 * v._2) + (a._4._3 * v._3) + a._4._4
    V3fun.div(v3, n)

  fun mul_v4(a: M4, v: V4): V4 =>
    """multiply matrix * vector"""
    ((a._1._1 * v._1) + (a._1._2 * v._2) +
     (a._1._3 * v._3) + (a._1._4 * v._4),

     (a._2._1 * v._1) + (a._2._2 * v._2) +
     (a._2._3 * v._3) + (a._2._4 * v._4),

     (a._3._1 * v._1) + (a._3._2 * v._2) +
     (a._3._3 * v._3) + (a._3._4 * v._4),

     (a._4._1 * v._1) + (a._4._2 * v._2) +
     (a._4._3 * v._3) + (a._4._4 * v._4))

  fun mul_m4(a: M4, b: M4): M4 =>
    """multiply matrix * matrix"""
    (((a._1._1 * b._1._1) + (a._1._2 * b._2._1) +
      (a._1._3 * b._3._1) + (a._1._4 * b._4._1),
      (a._1._1 * b._1._2) + (a._1._2 * b._2._2) +
      (a._1._3 * b._3._2) + (a._1._4 * b._4._2),
      (a._1._1 * b._1._3) + (a._1._2 * b._2._3) +
      (a._1._3 * b._3._3) + (a._1._4 * b._4._3),
      (a._1._1 * b._1._4) + (a._1._2 * b._2._4) +
      (a._1._3 * b._3._4) + (a._1._4 * b._4._4)),

     ((a._2._1 * b._1._1) + (a._2._2 * b._2._1) +
      (a._2._3 * b._3._1) + (a._2._4 * b._4._1),
      (a._2._1 * b._1._2) + (a._2._2 * b._2._2) +
      (a._2._3 * b._3._2) + (a._2._4 * b._4._2),
      (a._2._1 * b._1._3) + (a._2._2 * b._2._3) +
      (a._2._3 * b._3._3) + (a._2._4 * b._4._3),
      (a._2._1 * b._1._4) + (a._2._2 * b._2._4) +
      (a._2._3 * b._3._4) + (a._2._4 * b._4._4)),

     ((a._3._1 * b._1._1) + (a._3._2 * b._2._1) +
      (a._3._3 * b._3._1) + (a._3._4 * b._4._1),
      (a._3._1 * b._1._2) + (a._3._2 * b._2._2) +
      (a._3._3 * b._3._2) + (a._3._4 * b._4._2),
      (a._3._1 * b._1._3) + (a._3._2 * b._2._3) +
      (a._3._3 * b._3._3) + (a._3._4 * b._4._3),
      (a._3._1 * b._1._4) + (a._3._2 * b._2._4) +
      (a._3._3 * b._3._4) + (a._3._4 * b._4._4)),

     ((a._4._1 * b._1._1) + (a._4._2 * b._2._1) +
      (a._4._3 * b._3._1) + (a._4._4 * b._4._1),
      (a._4._1 * b._1._2) + (a._4._2 * b._2._2) +
      (a._4._3 * b._3._2) + (a._4._4 * b._4._2),
      (a._4._1 * b._1._3) + (a._4._2 * b._2._3) +
      (a._4._3 * b._3._3) + (a._4._4 * b._4._3),
      (a._4._1 * b._1._4) + (a._4._2 * b._2._4) +
      (a._4._3 * b._3._4) + (a._4._4 * b._4._4)))

  fun trace(m: M4): F32 =>
    """trace"""
    m._1._1 + m._2._2 + m._3._3 + m._4._4

  fun det(m: M4): F32 =>
    """determinant"""
    let n = _det1(m)
    _det2(n)

  fun _det1(m: M4): (V4, V4, V4) =>
    let n1  = (m._1._1 * m._2._2) - (m._1._2 * m._2._1)
    let n2  = (m._1._1 * m._2._3) - (m._1._3 * m._2._1)
    let n3  = (m._1._1 * m._2._4) - (m._1._4 * m._2._1)
    let n4  = (m._1._2 * m._2._3) - (m._1._3 * m._2._2)
    let n5  = (m._1._2 * m._2._4) - (m._1._4 * m._2._2)
    let n6  = (m._1._3 * m._2._4) - (m._1._4 * m._2._3)
    let n7  = (m._3._1 * m._4._2) - (m._3._2 * m._4._1)
    let n8  = (m._3._1 * m._4._3) - (m._3._3 * m._4._1)
    let n9  = (m._3._1 * m._4._4) - (m._3._4 * m._4._1)
    let n10 = (m._3._2 * m._4._3) - (m._3._3 * m._4._2)
    let n11 = (m._3._2 * m._4._4) - (m._3._4 * m._4._2)
    let n12 = (m._3._3 * m._4._4) - (m._3._4 * m._4._3)
    ((n1, n2, n3, n4), (n5, n6, n7, n8), (n9, n10, n11, n12))

  fun _det2(n: (V4, V4, V4)): F32 =>
    ((let n1, let n2, let n3, let n4),
     (let n5, let n6, let n7, let n8),
     (let n9, let n10, let n11, let n12)) = n
    (n1 * n12) + (-n2 * n11) + (n3 * n10) +
    (n4 * n9)  + (-n5 * n8)  + (n6 * n7)

  fun inv(m: M4): (M4 | None) =>
    """inverse"""
    // inline det reduces operations
    let n = _det1(m)
    let d = _det2(n)
    if Linear.eq(d, 0) then return None end
    let d' = 1 / d

    ((let n1, let n2, let n3, let n4),
     (let n5, let n6, let n7, let n8),
     (let n9, let n10, let n11, let n12)) = n

    let b11 = (( m._2._2 * n12) + (-m._2._3 * n11) + ( m._2._4 * n10)) * d'
    let b12 = ((-m._1._2 * n12) + ( m._1._3 * n11) + (-m._1._4 * n10)) * d'
    let b13 = (( m._4._2 * n6 ) + (-m._4._3 * n5 ) + ( m._4._4 * n4 )) * d'
    let b14 = ((-m._3._2 * n6 ) + ( m._3._3 * n5 ) + (-m._3._4 * n4 )) * d'
    let b21 = ((-m._2._1 * n12) + ( m._2._3 * n9 ) + (-m._2._4 * n8 )) * d'
    let b22 = (( m._1._1 * n12) + (-m._1._3 * n9 ) + ( m._1._4 * n8 )) * d'
    let b23 = ((-m._4._1 * n6 ) + ( m._4._3 * n3 ) + (-m._4._4 * n2 )) * d'
    let b24 = (( m._3._1 * n6 ) + ( m._3._3 * n3 ) + ( m._3._4 * n2 )) * d'
    let b31 = (( m._2._1 * n11) + (-m._2._2 * n9 ) + ( m._2._4 * n7 )) * d'
    let b32 = ((-m._1._1 * n11) + ( m._1._2 * n9 ) + (-m._1._4 * n7 )) * d'
    let b33 = (( m._4._1 * n5 ) + (-m._4._2 * n3 ) + ( m._4._4 * n1 )) * d'
    let b34 = ((-m._3._1 * n5 ) + ( m._3._2 * n3 ) + (-m._3._4 * n1 )) * d'
    let b41 = ((-m._2._1 * n10) + ( m._2._2 * n8 ) + (-m._2._3 * n7 )) * d'
    let b42 = (( m._1._1 * n10) + (-m._1._2 * n8 ) + ( m._1._3 * n7 )) * d'
    let b43 = ((-m._4._1 * n4 ) + ( m._4._2 * n2 ) + (-m._4._3 * n1 )) * d'
    let b44 = (( m._3._1 * n4 ) + (-m._3._2 * n2 ) + ( m._3._3 * n1 )) * d'

    ((b11, b12, b13, b14), (b21, b22, b23, b24),
     (b31, b32, b33, b34), (b41, b42, b43, b44))

  fun solve(m: M4, v: V4): (V4 | None) =>
    """solve"""
    // inline det reduces operations
    let n = _det1(m)
    let d = _det2(n)
    if Linear.eq(d, 0) then return None end
    let d' = 1 / d

    ((let n1, let n2, let n3, let n4),
     (let n5, let n6, let n7, let n8),
     (let n9, let n10, let n11, let n12)) = n

    let x' = d' *
      ((((m._2._2 * n12) + (-m._2._3 * n11) + (m._2._4 * n10)) * v._1) +
      (-((m._2._1 * n12) + (-m._2._3 * n9 ) + (m._2._4 * n8 )) * v._2) +
      (( (m._2._1 * n11) + (-m._2._2 * n9 ) + (m._2._4 * n7 )) * v._3) +
      (-((m._2._1 * n10) + (-m._2._2 * n8 ) + (m._2._3 * n7 )) * v._4))

    let y' = -d' *
      ((((m._1._2 * n12) + (-m._1._3 * n11) + (m._1._4 * n10)) * v._1) +
      (-((m._1._1 * n12) + (-m._1._3 * n9 ) + (m._1._4 * n8 )) * v._2) +
      (( (m._1._1 * n11) + (-m._1._2 * n9 ) + (m._1._4 * n7 )) * v._3) +
      (-((m._1._1 * n10) + (-m._1._2 * n8 ) + (m._1._3 * n7 )) * v._4))

    let z' = d' *
      ((((m._4._2 * n6 ) + (-m._4._3 * n5 ) + (m._4._4 * n4 )) * v._1) +
      (-((m._4._1 * n6 ) + (-m._4._3 * n3 ) + (m._4._4 * n2 )) * v._2) +
      (( (m._4._1 * n5 ) + (-m._4._2 * n3 ) + (m._4._4 * n1 )) * v._3) +
      (-((m._4._1 * n4 ) + (-m._4._2 * n2 ) + (m._4._3 * n1 )) * v._4))

    let w' =-d' *
      ((((m._3._2 * n6 ) + (-m._3._3 * n5 ) + (m._3._4 * n4 )) * v._1) +
      (-((m._3._1 * n6 ) + (-m._3._3 * n3 ) + (m._3._4 * n2 )) * v._2) +
      (( (m._3._1 * n5 ) + (-m._3._2 * n3 ) + (m._3._4 * n1 )) * v._3) +
      (-((m._3._1 * n4 ) + (-m._3._2 * n2 ) + (m._3._3 * n1 )) * v._4))

    (x', y', z', w')

  fun rot(q: Q4): M4 =>
    """rotation M4 from Q4"""
    let n1  : F32  = q._1 * 2
    let n2  : F32  = q._2 * 2
    let n3  : F32  = q._3 * 2
    let n4  : F32  = q._1 * n1
    let n5  : F32  = q._2 * n2
    let n6  : F32  = q._3 * n3
    let n7  : F32  = q._1 * n2
    let n8  : F32  = q._1 * n3
    let n9  : F32  = q._2 * n3
    let n10 : F32  = q._4 * n1
    let n11 : F32  = q._4 * n2
    let n12 : F32  = q._4 * n3

    ((1 - (n5 + n6), n7 - n12, n8 + n11, 0),
     (n7 + n12, 1 - (n4 + n6), n9 - n10, 0),
     (n8 - n11, n9 + n10, 1 - (n4 + n5), 0),
     (0, 0, 0, 1))

  fun from_q4(q: Q4): M4 =>
    """matrix from quaternion"""
    ((q._1, -q._2, -q._3, -q._4),
     (q._2,  q._1, -q._4,  q._3),
     (q._3,  q._4,  q._1, -q._2),
     (q._4, -q._3,  q._2,  q._1))

  fun eq(a: M4, b: M4, eps: F32 = F32.epsilon()): Bool =>
    """a == b"""
    Linear.eq(a._1._1, b._1._1, eps) and
    Linear.eq(a._1._2, b._1._2, eps) and
    Linear.eq(a._1._3, b._1._3, eps) and
    Linear.eq(a._1._4, b._1._4, eps) and
    Linear.eq(a._2._1, b._2._1, eps) and
    Linear.eq(a._2._2, b._2._2, eps) and
    Linear.eq(a._2._3, b._2._3, eps) and
    Linear.eq(a._2._4, b._2._4, eps) and
    Linear.eq(a._3._1, b._3._1, eps) and
    Linear.eq(a._3._2, b._3._2, eps) and
    Linear.eq(a._3._3, b._3._3, eps) and
    Linear.eq(a._3._4, b._3._4, eps) and
    Linear.eq(a._4._1, b._4._1, eps) and
    Linear.eq(a._4._2, b._4._2, eps) and
    Linear.eq(a._4._3, b._4._3, eps) and
    Linear.eq(a._4._4, b._4._4, eps)

  fun to_string(m: M4): String iso^  =>
    """string format a matrix"""
    recover
      var s = String(600)
      s.push('(')
      s.append(V4fun.to_string(m._1))
      s.push(',')
      s.append(V4fun.to_string(m._2))
      s.push(',')
      s.append(V4fun.to_string(m._3))
      s.push(',')
      s.append(V4fun.to_string(m._4))
      s.push(')')
      s.>recalc()
    end

  fun tuplize(m': box->AnyMatrix4): M4 =>
    match m'
    | let m: M4 => m
    | let m: Matrix4 box => m.m4()
    end

type AnyMatrix4 is (Matrix4 | M4)

class Matrix4 is (Stringable & Equatable[Matrix4])
  """wrapper class"""
  embed _x : Vector4 = Vector4.zero()
  embed _y : Vector4 = Vector4.zero()
  embed _z : Vector4 = Vector4.zero()
  embed _w : Vector4 = Vector4.zero()

  new create() =>
    """zeroed 4x4 matrix"""

  new id() => apply(M4fun.id())

  new rot(q: Q4)=>apply(M4fun.rot(q))

  new trans_v3(v : V3) =>
    """translate vector 3"""
    apply(M4fun.trans_v3(v))

  new scale_v3(v: V3) =>
    """scale v3"""
    apply(M4fun.scale_v3(v))

  fun ref apply(m': box->AnyMatrix4): Matrix4 =>
    (let x', let y', let z', let w') = M4fun.tuplize(m')
    _x(x')
    _y(y')
    _z(z')
    _w(w')
    this

  fun ref update(value: box->AnyMatrix4) => apply(value)

  fun m4(): M4 =>
    """as tuple"""
    (_x.v4(), _y.v4(), _z.v4(), _w.v4())

  fun as_tuple(): M4 => m4()

  fun add(that: box->AnyMatrix4): M4 => M4fun.add(m4(), M4fun.tuplize(that))
  fun sub(that: box->AnyMatrix4): M4 => M4fun.sub(m4(), M4fun.tuplize(that))
  fun mul(s: F32): M4 => M4fun.mul(m4(), s)
  fun div(s: F32): M4 => M4fun.div(m4(), s)
  fun neg(): M4 => M4fun.neg(m4())
  fun row_x(): V4 => M4fun.row_x(m4())
  fun row_y(): V4 => M4fun.row_y(m4())
  fun row_z(): V4 => M4fun.row_z(m4())
  fun row_w(): V4 => M4fun.row_w(m4())
  fun col_x(): V4 => M4fun.col_x(m4())
  fun col_y(): V4 => M4fun.col_y(m4())
  fun col_z(): V4 => M4fun.col_z(m4())
  fun col_w(): V4 => M4fun.col_w(m4())

  fun trans(): M4 => M4fun.trans(m4())
  fun mul_v4(v: V4): V4 => M4fun.mul_v4(m4(), v)
  fun mul_m4(that: box->AnyMatrix4): M4 => 
    M4fun.mul_m4(m4(), M4fun.tuplize(that))
  fun trace(): F32 => M4fun.trace(m4())
  fun det(): F32 => M4fun.det(m4())
  fun inv(): (M4 | None) => M4fun.inv(m4())
  fun solve(v: V4): (V4 | None) => M4fun.solve(m4(), v)

  fun get(index: (USize | (USize, USize))): F32 ? =>
    """get cell value. flat array index or (row, col)"""
    match _Mindex(index, 4)
    | (1, let col: USize) => _x.get(col)?
    | (2, let col: USize) => _y.get(col)?
    | (3, let col: USize) => _z.get(col)?
    | (4, let col: USize) => _w.get(col)?
    else
      error
    end

  fun ref set(index: (USize | (USize, USize)), value: F32): F32 ? =>
    """set cell value return old value. index flat 0-15 or (row, col)"""
    let old = get(index)?
    match _Mindex(index, 4)
    | (1, let col: USize) => _x.set(col, value)?
    | (2, let col: USize) => _y.set(col, value)?
    | (3, let col: USize) => _z.set(col, value)?
    | (4, let col: USize) => _w.set(col, value)?
    else
      error
    end
    old

  fun string(): String iso^ => M4fun.to_string(m4())

  fun box eq(that: box->AnyMatrix4): Bool =>
    M4fun.eq(m4(), M4fun.tuplize(that))
  fun box ne(that: box->AnyMatrix4): Bool => not(eq(that))

primitive _Mindex
  """simplify getting a matrix index from row, col or flat array style"""
  fun apply(index: (USize | (USize, USize)), n: USize): (USize, USize) =>
    match index
    | let i: USize => ((i / n)  + 1, (i % n) + 1)
    | (let r: USize, let c: USize) => (r + 1, c  + 1)
    end

