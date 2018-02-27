type P4 is (V3, F32)
"""P4 is a tuple based plane represented as (Normal, Distance)"""

primitive Intersects
  fun ray_point(ray: R3, pt: V3) : Bool =>
    false
  fun plane_plane(a: P4, b: P4): R3 ? =>
    error

primitive P4fun
  fun apply(norm: V3, d: F32): P4 => (norm, d)
  fun normal(p: P4): V3 => p._1
  fun distance(p: P4): F32 => p._2

  fun at_point(norm: V3, pt: V3): P4 =>
    (norm, -V3fun.dot(norm, pt))

  fun from_triangle(p1: V3, p2: V3, p3: V3): P4 =>
    (let ax, let ay, let az) = V3fun.sub(p2, p1)
    (let bx, let by, let bz) = V3fun.sub(p3, p1)

    let c = ((ay * bz) - (az * by),
             (az * bx) - (ax * bz),
             (ax * by) - (ay * bx))
    let norm = V3fun.unit(c)
    let dist = -V3fun.dot(norm, p1)
    (norm, dist)

  fun unit(p: P4): P4 =>
    let len' = V3fun.len(p._1)
    (V3fun.div(p._1, len'), p._2 / len')

  fun reflect_m4(p: P4): M4 =>
    (let x, let y, let z) = p._1
    (let x2, let y2, let z2) = V3fun.mul(p._1, -2)

    let m11 = (x2 * x) + 1
    let m12 = y2 * x
    let m13 = z2 * x
    let m14: F32 = 0
    let m21 = x2 * y
    let m22 = (y2 * y) + 1
    let m23 = z2 * y
    let m24: F32 = 0
    let m31 = x2 * z
    let m32 = y2 * z
    let m33 = (z2 * z) + 1
    let m34: F32 = 0
    let m41: F32 = x2 * p._2
    let m42: F32 = y2 * p._2
    let m43: F32 = z2 * p._2
    let m44: F32 = 1

    ((m11, m12, m13, m14),
     (m21, m22, m23, m24),
     (m31, m32, m33, m34),
     (m41, m42, m43, m44))

  fun reflect_m3(p: P4): M3 =>
    let m = reflect_m4(p)
    ((m._1._1, m._1._2, m._1._3),
     (m._2._1, m._2._2, m._2._3),
     (m._3._1, m._3._2, m._3._3))

  fun dot(p: P4, v: V4): F32 =>
    V3fun.dot(p._1, V4fun.v3(v)) + (p._2 * v._4)

  fun dot_coordinate(p: P4, v: V3): F32 =>
    V3fun.dot(p._1, v) + p._2

  fun dot_normal(p: P4, v: V3): F32 =>
    V3fun.dot(p._1, v)

  fun transform(p: P4, q: Q4): P4 =>  
    let v =  V3fun.mul(V4fun.v3(q), 2)

    let wx = q._4 * v._1
    let wy = q._4 * v._2
    let wz = q._4 * v._3
    let xx = q._1 * v._1
    let xy = q._1 * v._2
    let xz = q._1 * v._3
    let yy = q._2 * v._2
    let yz = q._2 * v._3
    let zz = q._3 * v._3

    let n = p._1
    let rx = (n._1 * (1 - yy - zz)) + (n._2 * (xy - wz)) + (n._3 * (xz + wy))
    let ry = (n._1 * (xy + wz)) + (n._2 * (1 - xx - zz)) + (n._3 * (yz - wx))
    let rz = (n._1 * (xz - wy)) + (n._2 * (yz + wx)) + (n._3 * (1 - xx - yy))
    ((rx, ry, rz),  p._2)

  fun eq(a: P4, b: P4): Bool =>
    V3fun.eq(a._1, b._1) and Linear.eq(a._2, b._2)


  fun to_string(p: P4): String iso^ =>
    recover
      let s = String(60)
      s.append("Plane[N:")
      s.append(V3fun.to_string(p._1))
      s.append(" D:")
      s.append(p._2.string())
      s.push(']')
      s.>recalc()
    end
