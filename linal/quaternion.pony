type Q4 is (F32, F32, F32, F32)

class Quaternion
  var _x : F32
  var _y : F32
  var _z : F32
  var _w : F32

  new create(q4 : (Q4 | Quaternion box) = Q4fun.zero()) =>
    (_x, _y, _z, _w) = match q4
    | let q : Q4 => q
    | let q : Quaternion box => q.as_tuple()
    end

  fun as_tuple() : Q4 => (_x, _y, _z, _w)

  fun qfun() : Q4fun => Q4fun

  fun ref update(value : (Q4 | Quaternion box)) =>
    (_x, _y, _z, _w) = match value
    | let q : Q4 => q
    | let q : Quaternion box => q.as_tuple()
    end

primitive Q4fun
  fun apply(x': F32, y': F32, z': F32, w': F32) : Q4 => (x',y',z',w')
  fun zero() : Q4 => (0,0,0,0)
  fun id() :   Q4 => (0,0,0,1)

  fun axis_angle(axis' : V3, angle_radians : F32) : Q4 =>
    let sina = (angle_radians*0.5).sin()
    (let x, let y, let z) = V3fun.mul(V3fun.unit(axis'), sina)
    let w = (angle_radians*0.5).cos()
    (x,y,z,w)

  fun from_euler_v3(v: V3) : Q4 =>
    from_euler(v._1,v._2,v._3)

  fun from_euler(x : F32, y : F32, z : F32) : Q4 =>
    // @TODO: maybe drop this down to f32
    let x' : F64 = x.f64() * 0.5
    let sr : F64 = x'.sin()
    let cr : F64 = x'.cos()
  	let y' = y.f64() * 0.5
    let sp : F64 = y'.sin()
    let cp : F64 = y'.cos()
  	let z' = z.f64() * 0.5
    let sy : F64 = z'.sin()
    let cy : F64 = z'.cos()
    let cpcy : F64 = cp * cy
    let spcy : F64 = sp * cy
    let cpsy : F64 = cp * sy
    let spsy : F64 = sp * sy
    V4fun.unit((((sr * cpcy) - (cr * spsy)).f32(),
          ((cr * spcy) + (sr * cpsy)).f32(),
    	    ((cr * cpsy) - (sr * spcy)).f32(),
    	    ((cr * cpcy) + (sr * spsy)).f32()
          ))

// convenience aliases
  fun add(a: Q4, b: Q4) : Q4 => V4fun.add(a,b)
  fun sub(a: Q4, b: Q4) : Q4 => V4fun.sub(a,b)
  fun mul(q: Q4, s: F32) : Q4 => V4fun.mul(q,s)
  fun div(q: Q4, s: F32) : Q4 => V4fun.div(q,s)
  fun eq(a: Q4, b: Q4) : Bool => V4fun.eq(a,b)

  fun mulq4(a: Q4, b: Q4) : Q4 =>
    	(((a._4 * b._1) + (a._1 * b._4) + (a._2 * b._3)) - (a._3 * b._2),
    	  ((a._4 * b._2) - (a._1 * b._3)) + (a._2 * b._4) + (a._3 * b._1),
    	  (((a._4 * b._3) + (a._1 * b._2)) - (a._2 * b._1)) + (a._3 * b._4),
    	  (a._4 * b._4) - (a._1 * b._1) - (a._2 * b._2) - (a._3 * b._3))

  fun divq4(a: Q4, b: Q4) : Q4 => mulq4(a, inv(b))

  fun dot(a: Q4, b: Q4) : F32 =>
    V3fun.dot((a._1,a._2,a._3), (b._1,b._2,b._3)) + (a._4 * b._4)

  fun len2(q: Q4) : F32 => dot(q,q)
  fun len(q: Q4) : F32 => dot(q,q).sqrt()
  fun unit(q: Q4) : Q4 => div(q, len(q))
  fun conj(q: Q4) : Q4 => (-q._1, -q._2, -q._3, q._4)
  fun inv(q: Q4) : Q4 => div(conj(q), dot(q,q))

  fun angle(q: Q4) : F32 => (q._4 / len(q)).acos()
  fun axis(q: Q4) : V3 =>
    (let x, let y, let z, let w) = unit(q)
    V3fun.div((x,y,z), (q._4.acos()).sin())

  fun axis_x(q: Q4) : F32 =>
    let ii = (q._1*q._2 *2) + (q._3*q._4)
    let yy = ((q._1*q._1) + (q._4*q._4)) - (q._2*q._2) - (q._3*q._3)
    ii.atan2(yy)

  fun axis_y(q: Q4) : F32 =>
    let ii = (q._2*q._3 *2) + (q._1*q._4)
    let yy = ((q._4*q._4) - (q._1*q._1) - (q._2*q._2)) + (q._3*q._3)
    ii.atan2(yy)

  fun axis_z(q: Q4) : F32 =>
    let ii = ((q._1*q._3) - (q._4*q._2)) * -2
    ii.asin()

  fun rotv3(q: Q4, v: V3) : V3 =>
    let t = V3fun.mul(V3fun.cross((q._1,q._2,q._3), v), 2)
    let p = V3fun.cross((q._1,q._2,q._3), t)
    V3fun.add(V3fun.add(V3fun.mul(t, q._4), v), p)

  fun _force_pos_euler(v : V3) : V3 => 
    (var x, var y, var z) = v
      let n = F32(-0.005729578)
      let n2 = 360 + n
      x = if (x < n) then x + 360
      elseif (x > n2) then x - 360
      else x end

      y = if (y < n) then y + 360
      elseif (y > n2) then y - 360
      else y end

      z = if (z < n) then z + 360
      elseif (z > n2) then z - 360
      else z end
      (x,y,z)

  fun to_euler(q: Q4) : V3 =>
    let sqw = q._4*q._4
    let sqx = q._1*q._1
    let sqy = q._2*q._2
    let sqz = q._3*q._3
    let unit' = sqx + sqy + sqz + sqw
    // if normalised is one, otherwise is correction factor
    var test = (q._1*q._2) + (q._3*q._4)
    let v = if (test > (0.4999*unit')) then // singularity at north pole
      // Left hand coord
      (F32.pi()/2, 2 * q._1.atan2(q._4), 0) 
     elseif (test < (-0.4909*unit')) then // singularity at south pole
      (-F32.pi()/2, -2 * q._1.atan2(q._4), 0) 
    else
      // @TODO ; lets make this readable
      (((2*test)/unit').asin(), (((2*q._2) * q._4) - ((2*q._1)*q._3)).atan2(
        ((sqx - sqy) - sqz) + sqw), (((2*q._1)*q._4)-((2*q._2)*q._3)).atan2(((-sqx + sqy) - sqz) + sqw)) 
    end
    V3fun.mul(v, 57.29578)

