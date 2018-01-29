primitive Linear
  """
  linear functions and helpers for linal types
  """

  fun vector2(v' : OptVector) : Vector2 =>
    """create Vector2 instance from any vector"""
    Vector2(v2(v'))
  fun vector3(v' : OptVector) : Vector3 =>
    """create Vector3 instance from any vector"""
    Vector3(v3(v'))
  fun vector4(v' : OptVector) : Vector4 =>
    """create Vector4 instance from any vector"""
    Vector4(v4(v'))

  fun v2(v' : OptVector) : V2 =>
    """create V2 tuple from any vector"""
    match v'
    | let v : V2 => v
    | let v : V3 => (v._1, v._2)
    | let v : V4 => (v._1, v._2)
    else (0, 0)
    end

  fun v3(v' : OptVector) : V3 =>
    """create V3 tuple from any vector"""
    match v'
    | let v : V2 => (v._1, v._2, 0)
    | let v : V3 => v
    | let v : V4 => (v._1, v._2, v._3)
    else (0, 0, 0)
    end

  fun v4(v' : OptVector) : V4 =>
    """create V4 tuple from any vector"""
    match v'
    | let v : V2 => (v._1, v._2, 0, 0)
    | let v : V3 => (v._1, v._2, v._3, 0)
    | let v : V4 => v
    else (0, 0, 0, 0)
    end

  fun _smat(a: V4, b: V4, c: V4 = V4fun.zero(),
            d: V4 = V4fun.zero(), n: USize) : String iso^  =>
    """string format a matrix"""
    recover
      var s = String(600)
      s.push('(')
      s.append(_svec(a, n))
      s.push(',')
      s.append(_svec(b, n))
      if n > 2 then
        s.push(',')
        s.append(_svec(c, n))
        if n > 3 then
          s.push(',')
          s.append(_svec(d, n))
        end
      end
      s.push(')')
      s.>recalc()
      s
    end

  fun _svec(v: V4, n: USize) : String iso^ =>
    """string format a vector"""
    recover
      var s = String(160)
      s.push('(')
      s.append(v._1.string())
      s.push(',')
      s.append(v._2.string())
      if n > 2 then
        s.push(',')
        s.append(v._3.string())
        if n > 3 then
          s.push(',')
          s.append(v._4.string())
        end
      end
      s.push(')')
      s.>recalc()
      s
    end

  fun to_string(o: (Q4 | M2 | M3 | M4 | OptVector)) : String iso^ =>
    """convert linal tuple based objects to string"""
    match o
    | let v : V2 => _svec(v4(v), 2)
    | let v : V3 => _svec(v4(v), 3)
    | let v : V4 => _svec(v, 4)
    | let v : Q4 => _svec(v, 4)
    | let m : M2 => _smat(v4(m._1), v4(m._2) where n=2 )
    | let m : M3 => _smat(v4(m._1), v4(m._2), v4(m._3) where n=3)
    | let m : M4 => _smat(m._1, m._2, m._3, m._4, 4)
    else "None".string()
    end

  fun eq(a: F32, b: F32, eps: F32 = F32.epsilon())  : Bool =>
    """floating point equality with epsilon"""
    (a - b).abs() < eps
  fun lerp(a: F32, b: F32, t: F32) : F32 =>
    """floating point lerp t% (0-1) from a to b"""
    let t' = clamp01(t)
    (a*(1-t')) + (b*t')
  fun unlerp(a: F32, b: F32, t: F32) : F32 =>
    """floating point unlerp t% (0-1) from b to a"""
    let t' = clamp01(t)
    (t'-a)/(b-a)
  fun smooth_step(a: F32, b: F32, t: F32) : F32 =>
    """floating point smooth step t% (0-1) from a to b"""
    let t' = clamp01(t)
    let x = (t' - a)/(b - a)
    x*x*(3.0 - (2.0*x))
  fun smoother_step(a: F32, b: F32, t: F32) : F32 =>
    """floating point smoother step t% (0-1) from a to b"""
    let t' = clamp01(t)
    let x = (t' - a)/(b - a)
    x*x*x*((x*((6.0*x) - 15.0)) + 10.0)

  fun clamp01(t: F32) : F32 =>
    """clamps t to normalized 0<=t<=1"""
    clamp(t, 0, 1)

  fun clamp(t: F32, min': F32, max': F32) : F32 =>
    """clamps t to min<=t<=max"""
    if \unlikely\ t < min' then min'
    elseif \unlikely\ t > max' then max'
    else \likely\ t end

  fun deg_to_rad() : F32 => 0.0174532924
  fun rad_to_deg() : F32 => 57.29578

  fun min(a: F32, b: F32) : F32 =>
    """returns smallest value"""
    if a < b then a else b end
  fun max(a: F32, b: F32) : F32 =>
    """returns largest value"""
    if a > b then a else b end

  fun gamma(value: F32, abs_max: F32, gamma': F32) : F32 =>
    """floating point gamma function"""
    if value.abs() > abs_max then
      value
    else
      let r =  (value.abs() / abs_max).pow(gamma') * abs_max
      if value < 0 then -r  else r end
    end

  fun approx_eq(a:F32, b:F32) : Bool  =>
    """approximate equality"""
    (b - a).abs() < max(1e-6 * max(a.abs(), b.abs()), F32.epsilon() * 8.0)

  fun toggle(t: F32, len: F32) : F32 =>
    """returns t as a modded range from 0 to len"""
    clamp(t - ((t / len).floor() * len), 0, len)

  fun ping_pong(t : F32, len : F32) : F32 =>
    let t' = toggle(t, len * 2)
    len - (t' - len).abs()
