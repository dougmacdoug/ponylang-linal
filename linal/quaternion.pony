type Q4 is (F32, F32, F32, F32)
type AnyQuaternion is (Quaternion | Q4)

class Quaternion is (Stringable & Equatable[Quaternion])
  var _x: F32 = 0
  var _y: F32 = 0
  var _z: F32 = 0
  var _w: F32 = 1

  new create() =>
    """create Quaternion"""
  new zero() =>
    """create zero Quaternion"""
    apply((0, 0, 0, 0))
 
  fun ref apply(q: (Q4 | Quaternion box) = Q4fun.zero()): Quaternion =>
    (_x, _y, _z, _w) = match q
    | let q': Q4 => q'
    | let q': Quaternion box => q'.q4()
    end
    this

  fun ref update(value: (Q4 | Quaternion box)) =>
    apply(value)

  fun x(): F32 => _x
  fun y(): F32 => _y
  fun z(): F32 => _z
  fun w(): F32 => _w
  fun ref set_x(x': F32): F32 =>
    let old = _x
    _x = x'
    old
  fun ref set_y(y': F32): F32 =>
    let old = _y
    _y = y'
    old
  fun ref set_z(z': F32): F32 =>
    let old = _z
    _z = z'
    old
  fun ref set_w(w': F32): F32 =>
    let old = _w
    _w = w'
    old

  fun q4(): Q4 => (_x, _y, _z, _w)

  fun _tuplize(that: box->AnyQuaternion): Q4 =>
    match that
    | let q: Q4 => q
    | let q: Quaternion box => q.q4()
    end

  fun add(that: box->AnyQuaternion): Q4 => V4fun.add(q4(), _tuplize(that))
  fun sub(that: box->AnyQuaternion): Q4 => V4fun.sub(q4(), _tuplize(that))
  fun mul(s: F32): Q4 => V4fun.mul(q4(), s)
  fun div(s: F32): Q4 => V4fun.div(q4(), s)
  fun neg(): Q4 => V4fun.neg(q4())
  
  fun q4_mul(that: box->AnyQuaternion): Q4 =>
    Q4fun.q4_mul(q4(), _tuplize(that))
  fun q4_div(that: box->AnyQuaternion): Q4 =>
    Q4fun.q4_mul(q4(), _tuplize(that))
  fun dot(that: box->AnyQuaternion): F32 =>
    Q4fun.dot(q4(), _tuplize(that))
  fun len2(): F32 => Q4fun.len2(q4())
  fun len(): F32 => Q4fun.len(q4())
  fun unit(): Q4 => Q4fun.unit(q4())
  fun conj(): Q4 => Q4fun.conj(q4())
  fun inv(): Q4 => Q4fun.inv(q4())
  fun angle(): F32 => Q4fun.angle(q4())
  fun axis(): V3 => Q4fun.axis(q4())
  fun axis_x(): F32 => Q4fun.axis_x(q4())
  fun axis_y(): F32 => Q4fun.axis_y(q4())
  fun axis_z(): F32 => Q4fun.axis_z(q4())
  fun to_euler(): V3 => Q4fun.to_euler(q4())

  fun string(): String iso^ => V4fun.to_string(q4())
  
  fun eq(that: (Quaternion box | Q4)): Bool  =>
    """test equality with this Quaternion and another instance|tuple"""
    let mine = q4()
    let that' =
    match that
    | let v: Quaternion box => v.q4()
    | let v: Q4 => v
    end
    V4fun.eq(mine, that', F32.epsilon())

  fun ne(that: (Quaternion box | Q4)): Bool => not eq(that)

primitive Q4fun
  fun apply(x': F32, y': F32, z': F32, w': F32): Q4 => (x', y', z', w')
  fun zero(): Q4 => (0, 0, 0, 0)
  fun id():   Q4 => (0, 0, 0, 1)

  fun axis_angle(axis': V3, angle_radians: F32): Q4 =>
    let sina = (angle_radians * 0.5).sin()
    (let x, let y, let z) = V3fun.mul(V3fun.unit(axis'), sina)
    let w = (angle_radians * 0.5).cos()
    (x, y, z, w)

  fun from_euler_v3(v: V3): Q4 =>
    from_euler(v._1, v._2, v._3)

  fun from_euler(x': F32, y': F32, z': F32): Q4 =>
    let hx: F64 = x'.f64() * 0.5
    let hy: F64 = y'.f64() * 0.5
    let hz: F64 = z'.f64() * 0.5
    let cr: F64 = hx.cos()
    let cp: F64 = hy.cos()
    let cy: F64 = hz.cos()

    let sr: F64 = hx.sin()
    let sp: F64 = hy.sin()
    let sy: F64 = hz.sin()

    let cpcy: F64 = cp * cy
    let spcy: F64 = sp * cy
    let cpsy: F64 = cp * sy
    let spsy: F64 = sp * sy
    let qx = ((cpcy * sr) - (spsy * cr)).f32()
    let qy = ((spcy * cr) + (cpsy * sr)).f32()
    let qz = ((cpsy * cr) - (spcy * sr)).f32()
    let qw = ((cpcy * cr) + (spsy * sr)).f32()
    unit((qx, qy, qz, qw))

// convenience aliases
  fun add(a: Q4, b: Q4): Q4 => V4fun.add(a, b)
  fun sub(a: Q4, b: Q4): Q4 => V4fun.sub(a, b)
  fun mul(q: Q4, s: F32): Q4 => V4fun.mul(q, s)
  fun div(q: Q4, s: F32): Q4 => V4fun.div(q, s)
  fun neg(q: Q4): Q4 => V4fun.neg(q)
  fun eq(a: Q4, b: Q4): Bool => V4fun.eq(a, b)

  fun q4_mul(a: Q4, b: Q4): Q4 =>
    	(((a._4 * b._1) + (a._1 * b._4)  + (a._2 * b._3)) - (a._3 * b._2),
    	 ((a._4 * b._2) - (a._1 * b._3)) + (a._2 * b._4)  + (a._3 * b._1),
    	(((a._4 * b._3) + (a._1 * b._2)) - (a._2 * b._1)) + (a._3 * b._4),
    	  (a._4 * b._4) - (a._1 * b._1)  - (a._2 * b._2)  - (a._3 * b._3))

  fun q4_div(a: Q4, b: Q4): Q4 => q4_mul(a, inv(b))

  fun dot(a: Q4, b: Q4): F32 => V4fun.dot(a, b)
  fun len2(q: Q4): F32 => dot(q, q)
  fun len(q: Q4): F32 => dot(q, q).sqrt()
  fun unit(q: Q4): Q4 => div(q, len(q))
  fun conj(q: Q4): Q4 => (-q._1, -q._2, -q._3, q._4)
  fun inv(q: Q4): Q4 => div(conj(q), dot(q, q))

  fun angle(q: Q4): F32 => (q._4 / len(q)).acos()
  fun axis(q: Q4): V3 =>
    (let x, let y, let z, let w) = unit(q)
    V3fun.div((x, y, z), (q._4.acos()).sin())

  fun axis_x(q: Q4): F32 =>
    let ii = (q._1 * q._2 * 2) + (q._3 * q._4)
    let yy = ((q._1 * q._1) + (q._4 * q._4)) - (q._2 * q._2) - (q._3 * q._3)
    ii.atan2(yy)

  fun axis_y(q: Q4): F32 =>
    let ii = (q._2 * q._3 * 2) + (q._1 * q._4)
    let yy = ((q._4 * q._4) - (q._1 * q._1) - (q._2 * q._2)) + (q._3 * q._3)
    ii.atan2(yy)

  fun axis_z(q: Q4): F32 =>
    let ii = ((q._1 * q._3) - (q._4 * q._2)) * -2
    ii.asin()

  fun v3_rot(q: Q4, v: V3): V3 =>
    let t = V3fun.mul(V3fun.cross((q._1, q._2, q._3), v), 2)
    let p = V3fun.cross((q._1, q._2, q._3), t)
    V3fun.add(V3fun.add(V3fun.mul(t, q._4), v), p)

  fun _force_pos_euler(v: V3): V3 => 
    (var x, var y, var z) = v
      let rad360 = F32.pi() * 2
      let n = F32(-0.005729578) * Linear.deg_to_rad()
      let n2 = rad360 + n
      x = if (x < n) then x + rad360
      elseif (x > n2) then x - rad360
      else x end

      y = if (y < n) then y + rad360
      elseif (y > n2) then y - rad360
      else y end

      z = if (z < n) then z + rad360
      elseif (z > n2) then z - rad360
      else z end
      (x, y, z)

  fun to_euler(q: Q4): V3 =>
    let sqx = q._1 * q._1
    let sqy = q._2 * q._2
    let sqz = q._3 * q._3
    let sqw = q._4 * q._4
    let unit' = sqx + sqy + sqz + sqw
    // if normalised is one, otherwise is correction factor
    var test = (q._1 * q._2) + (q._3 * q._4)
    let v = if (test > (0.4999 * unit')) then // singularity at north pole
      // Left hand coord
      (F32.pi() / 2, 2 * q._1.atan2(q._4), 0) 
     elseif (test < (-0.4909 * unit')) then // singularity at south pole
      (-F32.pi() / 2, -2 * q._1.atan2(q._4), 0) 
    else
      let x' = (((2 * q._1 * q._4) -(2 * q._2 * q._3)))
                .atan2((-sqx + sqy) - (sqz + sqw))
      let y' = ((2 * q._2 * q._4) - (2 * q._1 * q._3))
                .atan2((sqx - sqy - sqz) + sqw)
      let z' = ((2 * test) / unit').asin()
      (x', y', z')
    end
    _force_pos_euler(v)
//    V3fun.mul(v, Linear.rad_to_deg())

  fun to_m3(q: Q4): M3 =>
    let a1 = 1 - (2 * ((q._2 * q._2) + (q._3 * q._3)))
    let a2 = 2 * ((q._1 * q._2) - (q._3 * q._4))
    let a3 = 2 * ((q._1 * q._3) + (q._2 * q._4))
    let b1 = 2 * ((q._1 * q._2) + (q._3 * q._4))
    let b2 = 1 - (2 * ((q._1 * q._1) + (q._3 * q._3)))
    let b3 = 2 * ((q._2 * q._3) - (q._1 * q._4))
    let c1 = 2 * ((q._1 * q._3) - (q._2 * q._4))
    let c2 = 2 * ((q._2 * q._3) + (q._1 * q._4))
    let c3 = 1 - (2 * ((q._1 * q._1) + (q._2 * q._2)))
    ((a1, a2, a3), (b1, b2, b3), (c1, c2, c3))

  fun from_m3(m: M3): Q4 =>
    let t: F32 = 1 + m._1._1 + m._2._2 + m._3._3
    if t > 0.001 then
      let s = 2 * t.sqrt()
      ((m._3._2 - m._2._3) / s,
       (m._1._3 - m._3._1) / s,
       (m._2._1 - m._1._2) / s,
       0.25 * s)      
    elseif((m._1._1 > m._2._2) and (m._1._1 > m._3._3 )) then
      let s = 2 * (1 + (m._1._1 - m._2._2 - m._3._3)).sqrt()
      (0.25 * s,
       (m._2._1 + m._1._2) / s,
       (m._1._3 + m._3._1) / s,
       (m._3._2 - m._2._3) / s)
    elseif(m._2._2 > m._3._3) then
      let s = 2 * (1 + (m._2._2 - m._1._1 - m._3._3)).sqrt()
      ((m._2._1 + m._1._2) / s,
       0.25 * s,
       (m._3._2 + m._2._3) / s,
       (m._1._3 - m._3._1) / s)
    else
      let s = 2 * (1 + (m._3._3 - m._1._1 - m._2._2)).sqrt()
      ((m._1._3 + m._3._1) / s,
       (m._3._2 + m._2._3) / s,
       0.25 * s,
       (m._2._1 - m._1._2) / s)
    end
