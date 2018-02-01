type M2 is (V2, V2)
""" tuple based matrix alias 2x2"""
type M3 is (V3, V3, V3)
""" tuple based matrix alias 3x3"""
type M4 is (V4, V4, V4, V4)
""" tuple based matrix alias 4x4"""

primitive M2fun
  fun apply(r1: V2, r2: V2): M2 => (r1, r2)
  fun zero(): M2 => ((0, 0), (0, 0))
  fun id(): M2 => ((1, 0), (0, 1))
  fun rowx(m: M2): V2 => m._1
  fun rowy(m: M2): V2 => m._2
  fun colx(m: M2): V2 => (m._1._1, m._2._1)
  fun coly(m: M2): V2 => (m._1._2, m._2._2)

  fun from_array(a: Array[F32] box): M2 ? =>
    (V2fun.from_array(a, 0)?, V2fun.from_array(a, 2)?)

  fun rot(angle: F32): M2 =>
      let c : F32 = angle.cos()
      let s : F32 = angle.sin()
      ((c, -s), (s, c))
  fun add(a: M2, b: M2): M2  =>
     ( (a._1._1 + b._1._1, a._1._2 + b._1._2),
       (a._2._1 + b._2._1, a._2._2 + b._2._2) )

  fun sub(a: M2, b: M2): M2 =>
    ( (a._1._1 - b._1._1, a._1._2 - b._1._2),
      (a._2._1 - b._2._1, a._2._2 - b._2._2) )

  fun neg(a: M2): M2 =>((-a._1._1, -a._1._2), (-a._2._1, -a._2._2))

  fun mul(a: M2, s: F32): M2 =>
    ((a._1._1*s, a._1._2*s), (a._2._1*s, a._2._2*s))

  fun div(a: M2, s: F32): M2 => mul(a, F32(1) / s)

  fun trans(a: M2): M2 => ((a._1._1, a._2._1), (a._1._2, a._2._2))

  fun mulv2(a: M2, v: V2): V2 =>
      ( (a._1._1*v._1) + (a._1._2* v._2), (a._2._1*v._1) + (a._2._2*v._2))

  fun mulm2(a: M2, b: M2): M2 =>
    (((a._1._1 * b._1._1) + (a._1._2 * b._2._1),
      (a._1._1 * b._1._2) + (a._1._2 * b._2._2)),
     ((a._2._1 * b._1._1) + (a._2._2 * b._2._1),
      (a._2._1 * b._1._2) + (a._2._2 * b._2._2)))

  fun trace(m: M2): F32 => m._1._1 + m._2._2
  fun det(m: M2): F32 => (m._1._1 * m._2._2) - (m._1._2 * m._2._1)
  fun inv(m: M2): M2 =>
     let m2 = ((m._2._2, -m._1._2), (-m._2._1, m._1._1))
     div(m2, det(m))
  fun solve(m: M2, v: V2): V2 =>
    ((((m._1._2 * v._2)    - (m._2._2 * v._1)) /
      ((m._1._2 * m._2._1) - (m._1._1 * m._2._2))),
     (((m._2._1 * v._1)    - (m._1._1 * v._2)) /
      ((m._1._2 * m._2._1) - (m._1._1 * m._2._2))))

  fun eq(a: M2, b: M2, eps: F32 = F32.epsilon()): Bool =>
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

primitive M3fun
  fun apply(r1: V3, r2: V3, r3: V3): M3 => (r1, r2, r3)
  fun zero(): M3 => ((0, 0, 0), (0, 0, 0), (0, 0, 0))
  fun id(): M3 => ((1, 0, 0), (0, 1, 0), (0, 0, 1))
  fun rowx(m: M3): V3 => m._1
  fun rowy(m: M3): V3 => m._2
  fun rowz(m: M3): V3 => m._3
  fun colx(m: M3): V3 => (m._1._1, m._2._1, m._3._1)
  fun coly(m: M3): V3 => (m._1._2, m._2._2, m._3._2)
  fun colz(m: M3): V3 => (m._1._3, m._2._3, m._3._3)

  fun from_array(a: Array[F32] box): M3 ? =>
    (V3fun.from_array(a, 0)?, V3fun.from_array(a, 3)?, V3fun.from_array(a, 6)?)

  fun rotx(angle: F32): M3 =>
    let c : F32 = angle.cos()
    let s : F32 = angle.sin()
    ((1, 0, 0), (0, c, -s), (0, s, c))
  fun roty(angle: F32): M3 =>
    let c : F32 = angle.cos()
    let s : F32 = angle.sin()
    ((c, 0, s), (0, 1, 0), (-s, 0, c))
  fun rotz(angle: F32): M3 =>
    let c : F32 = angle.cos()
    let s : F32 = angle.sin()
    ((c, -s, 0), (s, c, 0), (0, 0, 1))

  fun add(a: M3, b: M3): M3 =>
    ((a._1._1 + b._1._1, a._1._2 + b._1._2, a._1._3 + b._1._3),
     (a._2._1 + b._2._1, a._2._2 + b._2._2, a._2._3 + b._2._3),
     (a._3._1 + b._3._1, a._3._2 + b._3._2, a._3._3 + b._3._3))

  fun sub(a: M3, b: M3)  : M3 =>
    ((a._1._1 - b._1._1, a._1._2 - b._1._2, a._1._3 - b._1._3),
     (a._2._1 - b._2._1, a._2._2 - b._2._2, a._2._3 - b._2._3),
     (a._3._1 - b._3._1, a._3._2 - b._3._2, a._3._3 - b._3._3))

  fun neg(a: M3): M3 =>
    ((-a._1._1, -a._1._2, -a._1._3),
     (-a._2._1, -a._2._2, -a._2._3),
     (-a._3._1, -a._3._2, -a._3._3))

  fun mul(a: M3, s: F32): M3 =>
    ((a._1._1 * s, a._1._2 * s, a._1._3 * s),
     (a._2._1 * s, a._2._2 * s, a._2._3 * s),
     (a._3._1 * s, a._3._2 * s, a._3._3 * s))

  fun div(a: M3, s: F32): M3 => mul(a, F32(1)/s)

  fun trans(a: M3): M3 =>
    ((a._1._1, a._2._1, a._3._1),
     (a._1._2, a._2._2, a._3._2),
     (a._1._3, a._2._3, a._3._3))

  fun mulv3(a: M3, v: V3): V3 =>
    ((a._1._1 * v._1) + (a._1._2 * v._2) + (a._1._3 * v._3),
     (a._2._1 * v._1) + (a._2._2 * v._2) + (a._2._3 * v._3),
     (a._3._1 * v._1) + (a._3._2 * v._2) + (a._3._3 * v._3))

  fun mulm3(a: M3, b: M3): M3 =>
    (((a._1._1 * b._1._1) + (a._1._2 * b._2._1) + (a._1._3 * b._3._1),
      (a._1._1 * b._1._2) + (a._1._2 * b._2._2) + (a._1._3 * b._3._2),
      (a._1._1 * b._1._3) + (a._1._2 * b._2._3) + (a._1._3 * b._3._3)),
     ((a._2._1 * b._1._1) + (a._2._2 * b._2._1) + (a._2._3 * b._3._1),
      (a._2._1 * b._1._2) + (a._2._2 * b._2._2) + (a._2._3 * b._3._2),
      (a._2._1 * b._1._3) + (a._2._2 * b._2._3) + (a._2._3 * b._3._3)),
     ((a._3._1 * b._1._1) + (a._3._2 * b._2._1) + (a._3._3 * b._3._1),
      (a._3._1 * b._1._2) + (a._3._2 * b._2._2) + (a._3._3 * b._3._2),
      (a._3._1 * b._1._3) + (a._3._2 * b._2._3) + (a._3._3 * b._3._3)))

  fun trace(m: M3): F32 => m._1._1 + m._2._2 + m._3._3

  fun det(m: M3): F32 =>
    (m._1._1 * m._2._2 * m._3._3) +
    (m._1._2 * m._2._3 * m._3._1) +
    ((m._2._1 * m._3._2 * m._1._3) -
     (m._1._3 * m._2._2 * m._3._1) -
     (m._1._1 * m._2._3 * m._3._2) -
     (m._1._2 * m._2._1 * m._3._3))

  fun inv(m: M3): M3 ? =>
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

  fun solve(m: M3, v: V3): V3 =>
    let d  = det(m)
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

primitive M4fun
  fun apply(r1: V4, r2: V4, r3: V4, r4: V4): M4 => (r1, r2, r3, r4)
  fun zero(): M4 => ((0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0))
  fun id(): M4 => ((1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1))
  fun rowx(m: M4): V4 => m._1
  fun rowy(m: M4): V4 => m._2
  fun rowz(m: M4): V4 => m._3
  fun roww(m: M4): V4 => m._4
  fun colx(m: M4): V4 => (m._1._1, m._2._1, m._3._1, m._4._1)
  fun coly(m: M4): V4 => (m._1._2, m._2._2, m._3._2, m._4._2)
  fun colz(m: M4): V4 => (m._1._3, m._2._3, m._3._3, m._4._3)
  fun colw(m: M4): V4 => (m._1._4, m._2._4, m._3._4, m._4._4)
  fun from_array(a: Array[F32] box): M4 ? =>
    (V4fun.from_array(a, 0)?, V4fun.from_array(a, 4)?,
      V4fun.from_array(a, 8)?, V4fun.from_array(a, 12)?)
  fun add(a: M4, b: M4): M4 =>
    ((a._1._1 + b._1._1,  a._1._2 + b._1._2,
      a._1._3 + b._1._3,  a._1._4 + b._1._4),
     (a._2._1 + b._2._1,  a._2._2 + b._2._2,
      a._2._3 + b._2._3,  a._2._4 + b._2._4),
     (a._3._1 + b._3._1,  a._3._2 + b._3._2,
      a._3._3 + b._3._3,  a._3._4 + b._3._4),
     (a._4._1 + b._4._1,  a._4._2 + b._4._2,
      a._4._3 + b._4._3,  a._4._4 + b._4._4))

  fun sub(a: M4, b: M4): M4 =>
    ((a._1._1 - b._1._1,  a._1._2 - b._1._2,
      a._1._3 - b._1._3,  a._1._4 - b._1._4),
     (a._2._1 - b._2._1,  a._2._2 - b._2._2,
      a._2._3 - b._2._3,  a._2._4 - b._2._4),
     (a._3._1 - b._3._1,  a._3._2 - b._3._2,
      a._3._3 - b._3._3,  a._3._4 - b._3._4),
     (a._4._1 - b._4._1,  a._4._2 - b._4._2,
      a._4._3 - b._4._3,  a._4._4 - b._4._4))

  fun neg(a: M4): M4 =>
    ((-a._1._1, -a._1._2, -a._1._3, -a._1._4),
     (-a._2._1, -a._2._2, -a._2._3, -a._2._4),
     (-a._3._1, -a._3._2, -a._3._3, -a._3._4),
     (-a._4._1, -a._4._2, -a._4._3, -a._4._4))

  fun mul(a: M4, s: F32): M4 =>
    ((a._1._1 * s, a._1._2 * s, a._1._3 * s, a._1._4 * s),
     (a._2._1 * s, a._2._2 * s, a._2._3 * s, a._2._4 * s),
     (a._3._1 * s, a._3._2 * s, a._3._3 * s, a._3._4 * s),
     (a._4._1 * s, a._4._2 * s, a._4._3 * s, a._4._4 * s))

  fun div(a: M4, s: F32): M4 =>
    ((a._1._1 / s, a._1._2 / s, a._1._3 / s, a._1._4 / s),
     (a._2._1 / s, a._2._2 / s, a._2._3 / s, a._2._4 / s),
     (a._3._1 / s, a._3._2 / s, a._3._3 / s, a._3._4 / s),
     (a._4._1 / s, a._4._2 / s, a._4._3 / s, a._4._4 / s))

  fun trans(a: M4): M4 =>
    ((a._1._1, a._2._1, a._3._1, a._4._1),
     (a._1._2, a._2._2, a._3._2, a._4._2),
     (a._1._3, a._2._3, a._3._3, a._4._3),
     (a._1._4, a._2._4, a._3._4, a._4._4))

  fun v3trans(v : V3): M4 =>
    ((1, 0, 0, v._1),
    (0, 1, 0, v._2),
    (0, 0, 1, v._3),
    (0, 0, 0, 1))

  fun v3scale(v: V3): M4 =>
    ((v._1,     0,   0, 0),
     (   0,  v._2,   0, 0),
     (   0,     0, v._3, 0),
     (   0,     0,   0, 1))

  fun v3mul(a: M4, v: V3): V3 =>
    ((a._1._1 * v._1) + (a._1._2 * v._2) + (a._1._3 * v._3),
     (a._2._1 * v._1) + (a._2._2 * v._2) + (a._2._3 * v._3),
     (a._3._1 * v._1) + (a._3._2 * v._2) + (a._3._3 * v._3))

  fun v3mul_point_3x4(a: M4, v: V3): V3 =>
    ((a._1._1 * v._1) + (a._1._2 * v._2) + (a._1._3 * v._3) + a._1._4,
     (a._2._1 * v._1) + (a._2._2 * v._2) + (a._2._3 * v._3) + a._2._4,
     (a._3._1 * v._1) + (a._3._2 * v._2) + (a._3._3 * v._3) + a._3._4)

  fun v3mul_point(a: M4, v: V3): V3 =>
    let v3 = v3mul_point_3x4(a, v)
    let n  = (a._4._1 * v._1) + (a._4._2 * v._2) + (a._4._3 * v._3) + a._4._4
    V3fun.div(v3, n)

  fun v4mul(a: M4, v: V4): V4 =>
    ((a._1._1 * v._1) + (a._1._2 * v._2) +
     (a._1._3 * v._3) + (a._1._4 * v._4),

     (a._2._1 * v._1) + (a._2._2 * v._2) +
     (a._2._3 * v._3) + (a._2._4 * v._4),

     (a._3._1 * v._1) + (a._3._2 * v._2) +
     (a._3._3 * v._3) + (a._3._4 * v._4),

     (a._4._1 * v._1) + (a._4._2 * v._2) +
     (a._4._3 * v._3) + (a._4._4 * v._4))

  fun mulm4(a: M4, b: M4): M4 =>
    (((a._1._1 * b._1._1) + (a._1._2 * b._2._1) +
      (a._1._3 * b._3._1) + (a._1._4 * b._4._1),
      (a._1._1 * b._1._2) + (a._1._2 * b._2._2) +
      (a._1._3 * b._3._2) + (a._1._4 * b._4._2),
      (a._1._1 * b._1._3) + (a._1._2 * b._2._3) +
      (a._1._3 * b._3._3) + (a._1._4 * b._4._3),
      (a._1._1 * b._1._4) + (a._1._2 * b._2._4) +
      (a._1._3 * b._3._4) + (a._1._4 * b._4._3)),

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

  fun trace(m: M4): F32 => m._1._1 + m._2._2 + m._3._3 + m._4._4

  fun det(m: M4): F32 =>
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

  fun inv(m: M4): M4 ? =>
    // inline det reduces operations
    let n = _det1(m)
    let d = _det2(n)
    if Linear.eq(d, 0) then error end
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

fun solve(m: M4, v: V4): V4 ? =>
    // inline det reduces operations
    let n = _det1(m)
    let d = _det2(n)
    if Linear.eq(d, 0) then error end
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

  fun rot(m: M4, q: Q4): M4 =>
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
    ((q._1, -q._2, -q._3, -q._4),
     (q._2,  q._1, -q._4,  q._3),
     (q._3,  q._4,  q._1, -q._2),
     (q._4, -q._3,  q._2,  q._1))

  fun eq(a: M4, b: M4, eps: F32 = F32.epsilon()): Bool =>
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

type AnyMatrix4 is (Matrix4 | M4)

class Matrix4 is (Stringable & Equatable[Matrix4])
  var _m11 : F32 = 0
  var _m12 : F32 = 0
  var _m13 : F32 = 0
  var _m14 : F32 = 0
  var _m21 : F32 = 0
  var _m22 : F32 = 0
  var _m23 : F32 = 0
  var _m24 : F32 = 0
  var _m31 : F32 = 0
  var _m32 : F32 = 0
  var _m33 : F32 = 0
  var _m34 : F32 = 0
  var _m41 : F32 = 0
  var _m42 : F32 = 0
  var _m43 : F32 = 0
  var _m44 : F32 = 0

  fun ref apply(m': box->AnyMatrix4) =>
    ((_m11, _m12, _m13, _m14),
     (_m21, _m22, _m23, _m24),
     (_m31, _m32, _m33, _m34),
     (_m41, _m42, _m43, _m44)) = _tuplize(m')

  fun ref update(value: box->AnyMatrix4) => apply(value)

  fun m4(): M4 =>
    ((_m11, _m12, _m13, _m14),
     (_m21, _m22, _m23, _m24),
     (_m31, _m32, _m33, _m34),
     (_m41, _m42, _m43, _m44))

  fun _tuplize(that: box->AnyMatrix4): M4 =>
    match that
    | let m: M4 => m
    | let m: Matrix4 box => m.m4()
    end

  fun add(that: box->AnyMatrix4): M4 => M4fun.add(m4(), _tuplize(that))
  fun sub(that: box->AnyMatrix4): M4 => M4fun.sub(m4(), _tuplize(that))
  fun mul(s: F32): M4 => M4fun.mul(m4(), s)
  fun div(s: F32): M4 => M4fun.div(m4(), s)

  fun get(index: (Int | (Int, Int))): F32 ? =>
    """get cell value. index flat 0-15 or (row, col)"""
    (let row: U32, let col: U32) =
    match index
    | let i: Int => (i.u32() / 4, i.u32() % 4)
    | (let r: Int, let c: Int) => (r.u32(), c.u32())
    end
    match (row, col)
    | (0, 0) => _m11
    | (0, 1) => _m12
    | (0, 2) => _m13
    | (0, 3) => _m14
    | (1, 0) => _m21
    | (1, 1) => _m22
    | (1, 2) => _m23
    | (1, 3) => _m24
    | (2, 0) => _m31
    | (2, 1) => _m32
    | (2, 2) => _m33
    | (2, 3) => _m34
    | (3, 0) => _m41
    | (3, 1) => _m42
    | (3, 2) => _m43
    | (3, 3) => _m44
    else
      error
    end

  fun ref set(index: (Int | (Int, Int)), value: F32): F32 ? =>
    """set cell value return old value. index flat 0-15 or (row, col)"""
    let old = get(index)?
    (let row: U32, let col: U32) =
    match index
    | let i: Int => (i.u32() / 4, i.u32() % 4)
    | (let r: Int, let c: Int) => (r.u32(), c.u32())
    end
    match (row.u32(), col.u32())
    | (0, 0) => _m11 = value
    | (0, 1) => _m12 = value
    | (0, 2) => _m13 = value
    | (0, 3) => _m14 = value
    | (1, 0) => _m21 = value
    | (1, 1) => _m22 = value
    | (1, 2) => _m23 = value
    | (1, 3) => _m24 = value
    | (2, 0) => _m31 = value
    | (2, 1) => _m32 = value
    | (2, 2) => _m33 = value
    | (2, 3) => _m34 = value
    | (3, 0) => _m41 = value
    | (3, 1) => _m42 = value
    | (3, 2) => _m43 = value
    | (3, 3) => _m44 = value
    else
      error
    end
    old

  fun string(): String iso^ => M4fun.to_string(m4())

  fun box eq(that: box->AnyMatrix4): Bool => M4fun.eq(m4(), _tuplize(that))
  fun box ne(that: box->AnyMatrix4): Bool => not(eq(that))