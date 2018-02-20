type Q4 is (F32, F32, F32, F32)
type AnyQuaternion is (Quaternion | Q4)

primitive Q4fun
  fun apply(x: F32, y: F32, z: F32, w: F32): Q4 => (x, y, z, w)
  fun zero(): Q4 => (0, 0, 0, 0)
  fun id():   Q4 => (0, 0, 0, 1)
// convenience aliases
  fun add(a: Q4, b: Q4): Q4 => V4fun.add(a, b)
  fun sub(a: Q4, b: Q4): Q4 => V4fun.sub(a, b)
  fun mul(q: Q4, s: F32): Q4 => V4fun.mul(q, s)
  fun div(q: Q4, s: F32): Q4 => V4fun.div(q, s)
  fun neg(q: Q4): Q4 => V4fun.neg(q)
  fun eq(a: Q4, b: Q4): Bool => V4fun.eq(a, b)

  fun q4_mul(a: Q4, b: Q4): Q4 =>
    """multiply 2 quaternions. Can be used to combine rotations"""
  	((a._4 * b._1) +  (a._1 * b._4) +  (a._2 * b._3) + -(a._3 * b._2),
  	 (a._4 * b._2) + -(a._1 * b._3) +  (a._2 * b._4) +  (a._3 * b._1),
  	 (a._4 * b._3) +  (a._1 * b._2) + -(a._2 * b._1) +  (a._3 * b._4),
  	 (a._4 * b._4) + -(a._1 * b._1) + -(a._2 * b._2) + -(a._3 * b._3))

  fun q4_div(a: Q4, b: Q4): Q4 => q4_mul(a, inv(b))

  fun dot(a: Q4, b: Q4): F32 => V4fun.dot(a, b)
  fun len2(q: Q4): F32 => dot(q, q)
  fun len(q: Q4): F32 => dot(q, q).sqrt()
  fun unit(q: Q4): Q4 => div(q, len(q))
  fun conj(q: Q4): Q4 => (-q._1, -q._2, -q._3, q._4)
  fun inv(q: Q4): Q4 =>
    let l2 = dot(q, q)
    if l2 == 0 then zero()
    else div(conj(q), l2)
  end

  fun axis_angle(axis': V3, angle_radians: F32): Q4 =>
    let half = angle_radians * 0.5
    let hs = half.sin()
    let w = half.cos()
    (let x, let y, let z) = V3fun.mul(V3fun.unit(axis'), hs)
    (x, y, z, w)

  fun angle(q: Q4): F32 =>  
    if Linear.eq(q._1, 0) and Linear.eq(q._2, 0) and Linear.eq(q._3, 0) then
      0
    else
      Linear.clamp(q._4, -1, 1).acos() * 2
    end

  fun axis(q: Q4): V3 =>
    let v3 = V4fun.v3(q) // xyz
    let l2 = V3fun.len2(v3)
    if l2 == 0 then
      (1, 0, 0)
    else
      let inv' = 1 / l2.sqrt()
      (q._1 * inv', q._2 * inv', q._3 * inv')
    end

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

  fun from_rot_ab(a': V3, b': V3): Q4 =>
    """creates a quaternion for rotation from point a to point b"""
    let a = V3fun.unit(a')
    let b = V3fun.unit(b')
    let d = V3fun.dot(a, b)
    if (d > (-1 + F32.epsilon())) then
      let c = V3fun.cross(a, b)
      let s =  ((1 + d) * 2).sqrt()
      let s' = 1 / s

      (c._1 * s', c._2 * s', c._3 * s', 0.5 * s)
    else
      var axis' = V3fun.cross((1,0,0), a)
      if Linear.eq(V3fun.len(axis'), 0) then
        axis' = V3fun.cross((0,1,0), a)
      end
      axis_angle(axis', 180)
    end

// ZXY ORDER same as Unity3D
  fun from_euler(v: V3): Q4 =>
    let hy: F64 = v._1.f64() * 0.5 //x
    let hp: F64 = v._2.f64() * 0.5 //y
    let hr: F64 = v._3.f64() * 0.5 //z
    let cy: F64 = hy.cos() 
    let cp: F64 = hp.cos() 
    let cr: F64 = hr.cos()

    let sy: F64 = hy.sin()
    let sp: F64 = hp.sin()
    let sr: F64 = hr.sin()

    let cpcy: F64 = cp * cy
    let spcy: F64 = sp * cy
    let cpsy: F64 = cp * sy
    let spsy: F64 = sp * sy
    let qx = ((cpsy * cr) + (spcy * sr)).f32()
    let qy = ((spcy * cr) - (cpsy * sr)).f32()
    let qz = ((cpcy * sr) - (spsy * cr)).f32()
    let qw = ((cpcy * cr) + (spsy * sr)).f32()
    unit((qx, qy, qz, qw))

  fun from_axes(x: V3, y: V3, z: V3): Q4 =>
    let m: M3 = 
      ((x._1, y._1, z._1),
       (x._2, y._2, z._2),
       (x._3, y._3, z._3))
    from_m3(m)

  fun _force_pos_euler(v: V3): V3 => 
    (var x, var y, var z) = v
      let rad360 = F32.pi() * 2
      let n: F32 = -0.005729578 * Linear.deg_to_rad()
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

// YXZ
  fun to_euler(q: Q4): V3 => 
    let sqx = q._1 * q._1
    let sqy = q._2 * q._2
    let sqz = q._3 * q._3
    let sqw = q._4 * q._4

    let unit' = sqx + sqy + sqz + sqw
    var test = (q._1 * q._4) - (q._2 * q._3)
    let v =
    if (test > (0.4999 * unit')) then
      (F32.pi() / 2, 2 * q._1.atan2(q._4), 0)
      elseif (test < (-0.4909 * unit')) then
      (-F32.pi() / 2, -2 * q._1.atan2(q._4), 0)
    else
      let a1 = 2 * ((q._1 * q._3) + (q._4 * q._2))
      let a2 = sqw + -sqx + -sqy + sqz
      let b = -2 * ((q._2 * q._3) - (q._4 * q._1))
      let c1 = 2 * ((q._1 * q._2) + (q._4 * q._3))
      let c2 = sqw + -sqx + sqy + -sqz
      (a1.atan2(a2), b.asin(), c1.atan2(c2))
    end
  _force_pos_euler(v)

  fun to_m3(q: Q4): M3 =>
    let xx = q._1 * q._1
    let yy = q._2 * q._2
    let zz = q._3 * q._3
    let xy = q._1 * q._2
    let zw = q._3 * q._4
    let zx = q._3 * q._1
    let yw = q._2 * q._4
    let yz = q._2 * q._3
    let xw = q._1 * q._4
    ((1 - (2 * (yy + zz)), 2 * (xy + zw), 2 * (zx - yw)),
     (2 * (xy - zw), 1 - (2 * (zz + xx)), 2 * (yz + xw)),
     (2 * (zx + yw), 2 * (yz - xw), 1 - (2 * (yy + xx))))

  fun from_m3(m: M3): Q4 =>
    let t: F32 = m._1._1 + m._2._2 + m._3._3
    let q: Q4 =
    if t > 0 then
      let s = (1 + t).sqrt()
      let s' = 0.5 / s

      let x = (m._2._3 - m._3._2) * s'
      let y = (m._3._1 - m._1._3) * s'
      let z = (m._1._2 - m._2._1) * s'
      let w = s * 0.5      
      (x, y, z, w)
    elseif (m._1._1 >= m._2._2) and (m._1._1 >= m._3._3) then
      let s = ((1 + m._1._1) - m._2._2 - m._3._3).sqrt()
      let s' = 0.5 / s

      let x = 0.5 * s
      let y = (m._1._2 + m._2._1) * s'
      let z = (m._1._3 + m._3._1) * s'
      let w = (m._2._3 - m._3._2) * s'
      (x, y, z, w)
    elseif m._2._2 > m._3._3 then
      let s = ((1 + m._2._2) - m._1._1 - m._3._3).sqrt()
      let s' = 0.5 / s

      let x = (m._2._1 + m._1._2) * s'
      let y = 0.5 * s
      let z = (m._3._2 + m._2._3) * s'
      let w = (m._3._1 - m._1._3) * s'
      (x, y, z, w)
    else
      let s = ((1 + m._3._3) - m._1._1 - m._2._2).sqrt()
      let s' = 0.5 / s

      let x = (m._3._1 + m._1._3) * s'
      let y = (m._3._2 + m._2._3) * s'
      let z = 0.5 * s
      let w = (m._1._2 - m._2._1) * s'
      (x, y, z, w)
    end
    unit(q)


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
