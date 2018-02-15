type Q4 is (F32, F32, F32, F32)
type AnyQuaternion is (Quaternion | Q4)

primitive RotXYZ
primitive RotZYX

type RotationSequence is (RotXYZ | RotZYX)

trait _Pole 
  fun apply() : U32
primitive _NorthPole is _Pole
  fun apply() : U32 => 1
primitive _SouthPole
  fun apply() : U32 => -1
type _GimbalLock is (_NorthPole | _SouthPole | None)

primitive Q4fun
  fun apply(x': F32, y': F32, z': F32, w': F32): Q4 => (x', y', z', w')
  fun zero(): Q4 => (0, 0, 0, 0)
  fun id():   Q4 => (0, 0, 0, 1)

  fun axis_angle(axis': V3, angle_radians: F32): Q4 =>
    let sina = (angle_radians * 0.5).sin()
    (let x, let y, let z) = V3fun.mul(V3fun.unit(axis'), sina)
    let w = (angle_radians * 0.5).cos()
    (x, y, z, w)

  // fun from_euler_v3(v: V3): Q4 =>
  //   from_euler(v._1, v._2, v._3)

  fun _rot2axes(r11: F32, r12: F32, r21: F32, r31: F32, r32: F32): V3 =>
    (r11.atan2(r12), r21.acos(), r31.atan2(r32))
 

 
/*

 
        case RotSeq.zyz:
            return twoaxisrot( 2*(q._2*q._3 - q._4*q._1),
                2*(q._1*q._3 + q._4*q._2),
                q._4*q._4 - q._1*q._1 - q._2*q._2 + q._3*q._3,
                2*(q._2*q._3 + q._4*q._1),
                -2*(q._1*q._3 - q._4*q._2));
           
 
        case RotSeq.zxy:
            return threeaxisrot( -2*(q._1*q._2 - q._4*q._3),
                q._4*q._4 - q._1*q._1 + q._2*q._2 - q._3*q._3,
                2*(q._2*q._3 + q._4*q._1),
                -2*(q._1*q._3 - q._4*q._2),
                q._4*q._4 - q._1*q._1 - q._2*q._2 + q._3*q._3);
           
 
        case RotSeq.zxz:
            return twoaxisrot( 2*(q._1*q._3 + q._4*q._2),
                -2*(q._2*q._3 - q._4*q._1),
                q._4*q._4 - q._1*q._1 - q._2*q._2 + q._3*q._3,
                2*(q._1*q._3 - q._4*q._2),
                2*(q._2*q._3 + q._4*q._1));
           
 
        case RotSeq.yxz:
            return threeaxisrot( 2*(q._1*q._3 + q._4*q._2),
                q._4*q._4 - q._1*q._1 - q._2*q._2 + q._3*q._3,
                -2*(q._2*q._3 - q._4*q._1),
                2*(q._1*q._2 + q._4*q._3),
                q._4*q._4 - q._1*q._1 + q._2*q._2 - q._3*q._3);
 
        case RotSeq.yxy:
            return twoaxisrot( 2*(q._1*q._2 - q._4*q._3),
                2*(q._2*q._3 + q._4*q._1),
                q._4*q._4 - q._1*q._1 + q._2*q._2 - q._3*q._3,
                2*(q._1*q._2 + q._4*q._3),
                -2*(q._2*q._3 - q._4*q._1));
           
 
        case RotSeq.yzx:
            return threeaxisrot( -2*(q._1*q._3 - q._4*q._2),
                q._4*q._4 + q._1*q._1 - q._2*q._2 - q._3*q._3,
                2*(q._1*q._2 + q._4*q._3),
                -2*(q._2*q._3 - q._4*q._1),
                q._4*q._4 - q._1*q._1 + q._2*q._2 - q._3*q._3);
           
 
        case RotSeq.yzy:
            return twoaxisrot( 2*(q._2*q._3 + q._4*q._1),
                -2*(q._1*q._2 - q._4*q._3),
                q._4*q._4 - q._1*q._1 + q._2*q._2 - q._3*q._3,
                2*(q._2*q._3 - q._4*q._1),
                2*(q._1*q._2 + q._4*q._3));
           
 
        case RotSeq.xyz:
            return threeaxisrot( -2*(q._2*q._3 - q._4*q._1),
                q._4*q._4 - q._1*q._1 - q._2*q._2 + q._3*q._3,
                2*(q._1*q._3 + q._4*q._2),
                -2*(q._1*q._2 - q._4*q._3),
                q._4*q._4 + q._1*q._1 - q._2*q._2 - q._3*q._3);
           
 
        case RotSeq.xyx:
            return twoaxisrot( 2*(q._1*q._2 + q._4*q._3),
                -2*(q._1*q._3 - q._4*q._2),
                q._4*q._4 + q._1*q._1 - q._2*q._2 - q._3*q._3,
                2*(q._1*q._2 - q._4*q._3),
                2*(q._1*q._3 + q._4*q._2));
           
 
        case RotSeq.xzy:
            return threeaxisrot( 2*(q._2*q._3 + q._4*q._1),
                q._4*q._4 - q._1*q._1 + q._2*q._2 - q._3*q._3,
                -2*(q._1*q._2 - q._4*q._3),
                2*(q._1*q._3 + q._4*q._2),
                q._4*q._4 + q._1*q._1 - q._2*q._2 - q._3*q._3);
           
 
        case RotSeq.xzx:
            return twoaxisrot( 2*(q._1*q._3 - q._4*q._2),
                2*(q._1*q._2 + q._4*q._3),
                q._4*q._4 + q._1*q._1 - q._2*q._2 - q._3*q._3,
                2*(q._1*q._3 + q._4*q._2),
                -2*(q._1*q._2 - q._4*q._3));
           
        default:
            Debug.LogError("No good sequence");
            return Vector3.zero;
 
        }
 
    }**/

  fun from_euler(v: V3): Q4 =>
    let hx: F64 = v._1.f64() * 0.5
    let hy: F64 = v._2.f64() * 0.5
    let hz: F64 = v._3.f64() * 0.5
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

  
  fun _gimbal(q: Q4) : _GimbalLock => 
    let t = (q._2 * q._1) + (q._3 * q._4)
    if  t > 0.4999 then
       _NorthPole
    elseif t < -0.4999 then
      _SouthPole
    else
      None
    end

  fun axis_x(q: Q4): F32 =>
    match _gimbal(q) 
    | None =>
      Linear.clamp((2 * ((q._4 * q._1) - (q._3 * q._2))).asin(), -1, 1)
    | let pole : _Pole val =>
       pole().f32() * F32.pi() * 0.5
     else
      0
   end
    //     let ii = (q._1 * q._2 * 2) + (q._3 * q._4)
    // let yy = ((q._1 * q._1) + (q._4 * q._4)) - (q._2 * q._2) - (q._3 * q._3)
    // ii.atan2(yy)

  fun axis_y(q: Q4): F32 =>
    let ii = (q._2 * q._3 * 2) + (q._1 * q._4)
    let yy = ((q._4 * q._4) - (q._1 * q._1) - (q._2 * q._2)) + (q._3 * q._3)
    ii.atan2(yy)

  // fun axis_z(q: Q4): F32 =>
  //   let ii = ((q._1 * q._3) - (q._4 * q._2)) * -2
  //   ii.asin()

  fun axis_z(q: Q4): F32 =>
    match _gimbal(q) 
    | None =>
      (2 * ((q._4 * q._3) + (q._2 * q._1)))
        .atan2(1 - (2 * ((q._1 * q._1) + (q._3 * q._3))))
    | let pole : _Pole val =>
       pole().f32() * 2 * q._2.atan2(q._4)
     else
      0
   end

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

  fun _rot3axes(r11: F32, r12: F32, r21: F32, r31: F32, r32: F32): V3 =>
    (r31.atan2(r32), r21.asin(), r11.atan2(r12))

  fun to_euler(q: Q4): V3 => 
    (axis_x(q), axis_y(q), axis_z(q))
//    to_euler_seq(q, RotZYX)

  fun to_euler_seq(q: Q4, s: RotationSequence): V3 =>
    let sqx = q._1 * q._1
    let sqy = q._2 * q._2
    let sqz = q._3 * q._3
    let sqw = q._4 * q._4
    let unit' = sqx + sqy + sqz + sqw
    // if normalised is one, otherwise is correction factor
    var test = (q._1 * q._2) + (q._3 * q._4)
    let v = if (test > (0.4999 * unit')) then // singularity at north pole
      (F32.pi() / 2, 2 * q._1.atan2(q._4), 0) 
     elseif (test < (-0.4909 * unit')) then // singularity at south pole
      (-F32.pi() / 2, -2 * q._1.atan2(q._4), 0) 
    else

    let heading = ((2 * q._2 * q._4) - (2 * q._1 * q._3))
              .atan2(1 - (2 * sqy) - (2 * sqz))
    let attitude = (2*test).asin()
    let bank = ((2 * q._1 * q._4) - (2 * q._2 * q._3))
              .atan2(1 - (2 * sqx) - (2*sqz))
    (attitude, heading, bank)
  end
    //   match s
    //   | (RotXYZ) =>
    //     _rot3axes(
    //      2 * test,
    //      sqw + sqx + (-sqy) + (-sqz),
    //     -2 * ((q._1 * q._3) - (q._4 * q._2)),
    //      2 * ((q._2 * q._3) + (q._4 * q._1)),
    //      sqw + (-sqx) + (-sqy) + sqz)

    //   | (RotZYX) =>
    //     _rot3axes(
    //      -2 * ((q._2 * q._3) - (q._4 * q._1)),
    //       sqw + (-sqx) + (-sqy) + sqz,
    //       2 * ((q._1 * q._3) + (q._4 * q._2)),
    //      -2 * ((q._1 * q._2) - (q._4 * q._3)),
    //      sqw + sqx + (-sqy) + (-sqz))
    //   end      
    // end
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
    let q: Q4 =
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
    unit(q)

  fun rot_m3(m: M3): Q4 =>
    (let v1, let v2, let v3) = m
    (let m00: F32, let m01: F32, let m02: F32) = v1
    (let m10: F32, let m11: F32, let m12: F32) = v2
    (let m20: F32, let m21: F32, let m22: F32) = v3

    let t = m00 + m11 + m22
    if t >= 0 then
      let s = (t + 1).sqrt()
      let s' = 0.5 / s
      ((m21 - m12) * s',
       (m02 - m20) * s',
       (m10 - m01) * s',
       0.5 * s)
    elseif ((m00 > m11) and (m00 > m22)) then
      let s = 1 + (m00 - m11 - m22)
      let s' = 0.5 / s
      (s * 0.5, (m10 + m01) * s',
        (m02 + m20) * s', (m21 - m12) * s')
    elseif (m11 > m22) then
      let s = (1 + (m11 - m00 - m22)).sqrt()
      let s' = 0.5 / s
      ((m10 + m01) * s', s * 0.5,
       (m21 + m12) * s', (m02 - m20) * s')
    else
      let s = (1 + (m22 - m00 - m11)).sqrt()
      let s' = 0.5 / s
      ((m02 + m20) * s', (m21 + m12) * s',
       s * 0.5, (m10 - m01) * s')
    end

/***

 public Quaternion fromRotationMatrix(let m00: F32, let m01: F32, let m02: F32,
            let m10: F32, let m11: F32, let m12: F32,
            let m20: F32, let m21: F32, let m22: F32) {
        // Use the Graphics Gems code, from 
        // ftp://ftp.cis.upenn.edu/pub/graphics/shoemake/quatut.ps.Z
        // *NOT* the "Matrix and Quaternions FAQ", which has errors!

        // the trace is the sum of the diagonal elements; see
        // http://mathworld.wolfram.com/MatrixTrace.html
        float t = m00 + m11 + m22;

        // we protect the division by s by ensuring that s>=1
        if (t >= 0) { // |w| >= .5
            float s = FastMath.sqrt(t + 1); // |s|>=1 ...
            w = 0.5f * s;
            s = 0.5f / s;                 // so this division isn't bad
            x = (m21 - m12) * s;
            y = (m02 - m20) * s;
            z = (m10 - m01) * s;
        } else if ((m00 > m11) && (m00 > m22)) {
            float s = FastMath.sqrt(1.0f + m00 - m11 - m22); // |s|>=1
            x = s * 0.5f; // |x| >= .5
            s = 0.5f / s;
            y = (m10 + m01) * s;
            z = (m02 + m20) * s;
            w = (m21 - m12) * s;
        } else if (m11 > m22) {
            float s = FastMath.sqrt(1.0f + m11 - m00 - m22); // |s|>=1
            y = s * 0.5f; // |y| >= .5
            s = 0.5f / s;
            x = (m10 + m01) * s;
            z = (m21 + m12) * s;
            w = (m02 - m20) * s;
        } else {
            float s = FastMath.sqrt(1.0f + m22 - m00 - m11); // |s|>=1
            z = s * 0.5f; // |z| >= .5
            s = 0.5f / s;
            x = (m02 + m20) * s;
            y = (m21 + m12) * s;
            w = (m10 - m01) * s;
        }

        return this;
    }

    /**
     * <code>toRotationMatrix</code> converts this quaternion to a rotational
     * matrix. Note: the result is created from a normalized version of this quat.
     * 
     * @return the rotation matrix representation of this quaternion.
     */
    public Matrix3f toRotationMatrix() {
        Matrix3f matrix = new Matrix3f();
        return toRotationMatrix(matrix);
    }

    /**
     * <code>toRotationMatrix</code> converts this quaternion to a rotational
     * matrix. The result is stored in result.
     * 
     * @param result
     *            The Matrix3f to store the result in.
     * @return the rotation matrix representation of this quaternion.
     */
    public Matrix3f toRotationMatrix(Matrix3f result) {

        float norm = norm();
        // we explicitly test norm against one here, saving a division
        // at the cost of a test and branch.  Is it worth it?
        float s = (norm == 1f) ? 2f : (norm > 0f) ? 2f / norm : 0;

        // compute xs/ys/zs first to save 6 multiplications, since xs/ys/zs
        // will be used 2-4 times each.
        float xs = x * s;
        float ys = y * s;
        float zs = z * s;
        float xx = x * xs;
        float xy = x * ys;
        float xz = x * zs;
        float xw = w * xs;
        float yy = y * ys;
        float yz = y * zs;
        float yw = w * ys;
        float zz = z * zs;
        float zw = w * zs;

        // using s=2/norm (instead of 1/norm) saves 9 multiplications by 2 here
        result.m00 = 1 - (yy + zz);
        result.m01 = (xy - zw);
        result.m02 = (xz + yw);
        result.m10 = (xy + zw);
        result.m11 = 1 - (xx + zz);
        result.m12 = (yz - xw);
        result.m20 = (xz - yw);
        result.m21 = (yz + xw);
        result.m22 = 1 - (xx + yy);

        return result;
    }**/
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


