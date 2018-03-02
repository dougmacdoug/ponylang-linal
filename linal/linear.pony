type LinalType is (V2 | V3 | V4 | M2 | M3 | M4 |
                      Q4 | R4 | R2 | P4 | F32)
"""All tuple types defined in linal"""

primitive Linear
"""
linear functions and helpers for linal types
"""
  fun vector2(): V2fun => V2fun
  fun vector3(): V3fun => V3fun
  fun vector4(): V4fun => V4fun
  fun matrix2(): M2fun => M2fun
  fun matrix3(): M3fun => M3fun
  fun matrix4(): M4fun => M4fun
  fun quaternion(): Q4fun => Q4fun
  fun rectangle(): R4fun => R4fun
  fun ray(): R2fun => R2fun
  fun plane(): P4fun => P4fun

  fun is_scalar(o: LinalType): Bool =>
    match o
    | let f: F32 => true
    else false end
  fun is_vector2(o: LinalType): Bool =>
    match o
    | let v: V2 => true
    else false end
  fun is_vector3(o: LinalType): Bool =>
    match o
    | let v: V3 => true
    else false end
  fun is_vector4(o: LinalType): Bool =>
    match o
    | let v: V4 => true
    else false end
  fun is_matrix2(o: LinalType): Bool =>
    match o
    | let m: M2 => true
    else false end
  fun is_matrix3(o: LinalType): Bool =>
    match o
    | let m: M3 => true
    else false end
  fun is_matrix4(o: LinalType): Bool =>
    match o
    | let m: M4 => true
    else false end
  fun is_quaternion(o: LinalType): Bool =>
    match o
    | let q: Q4 => true
    else false end
  fun is_rectangle(o: LinalType): Bool =>
    match o
    | let r: R4 => true
    else false end
  fun is_ray(o: LinalType): Bool =>
    match o
    | let r: R2 => true
    else false end
  fun is_plane(o: LinalType): Bool =>
    match o
    | let p: P4 => true
    else false end

  fun to_string(o: (LinalType | None)): String iso^ =>
    """convert linal tuple based objects to string"""
    match o
    | let v: V2 => V2fun.to_string(v)
    | let v: V3 => V3fun.to_string(v)
    | let v: V4 => V4fun.to_string(v)
    | let v: Q4 => V4fun.to_string(v)
    | let m: M2 => M2fun.to_string(m)
    | let m: M3 => M3fun.to_string(m)
    | let m: M4 => M4fun.to_string(m)
    | let r: R4 => R4fun.to_string(r)
    | let r: R2 => R2fun.to_string(r)
    | let p: P4 => P4fun.to_string(p)
    | let f: F32 => f.string()
    | None =>  None.string()
    end

  fun eq(a: F32, b: F32, eps: F32 = F32.epsilon()): Bool =>
    """floating point equality with epsilon"""
    (a - b).abs() < eps

  fun lerp_unclamped(a: F32, b: F32, t: F32): F32 =>
    """floating point lerp t% unclamped from a to b"""
    ((1 - t) * a) + (b * t)

  fun lerp(a: F32, b: F32, t: F32): F32 =>
    """floating point lerp t% clamped(0-1) from a to b"""
    let t' = clamp01(t)
    (a * (1 - t')) + (b * t')

  fun unlerp(a: F32, b: F32, t: F32): F32 =>
    """floating point unlerp t% (0-1) from b to a"""
    let t' = clamp01(t)
    (t' - a) / (b - a)
  fun smooth_step(a: F32, b: F32, t: F32): F32 =>
    """floating point smooth step t% (0-1) from a to b"""
    let t' = clamp01(t)
    let x = (t' - a) / (b - a)
    x * x * (3 - (2 * x))
  fun smoother_step(a: F32, b: F32, t: F32): F32 =>
    """floating point smoother step t% (0-1) from a to b"""
    let t' = clamp01(t)
    let x = (t' - a) / (b - a)
    x * x * x * ((x * ((6 * x) - 15)) + 10)

  fun clamp01(t: F32): F32 =>
    """clamps t to normalized 0<=t<=1"""
    clamp(t, 0, 1)

  fun clamp(t: F32, min': F32, max': F32): F32 =>
    """clamps t to min<=t<=max"""
    if \unlikely\ t < min' then min'
    elseif \unlikely\ t > max' then max'
    else \likely\ t end

  fun deg_to_rad(): F32 => 0.0174532924
  fun rad_to_deg(): F32 => 57.29578

  fun gamma(value: F32, abs_max: F32, gamma': F32): F32 =>
    """floating point gamma function"""
    if value.abs() > abs_max then
      value
    else
      let r =  (value.abs() / abs_max).pow(gamma') * abs_max
      if value < 0 then -r  else r end
    end

  fun approx_eq(a: F32, b: F32): Bool  =>
    """approximate equality (better than near_zero for larger numbers)"""
    (b - a).abs() < (tolerance() * a.abs().max(b.abs()))
                    .max(F32.epsilon() * 8)

  fun toggle(t: F32, len: F32): F32 =>
    """returns t as a modded range from 0 to len"""
    clamp(t - ((t / len).floor() * len), 0, len)

  fun ping_pong(t: F32, len: F32): F32 =>
    """ping pong t as a modded range from 0 to len back to 0"""
    let t' = toggle(t, len * 2)
    len - (t' - len).abs()

  fun tolerance(): F32 =>
    """1.0e-6"""
    1.0e-6

  fun near_zero(a: F32): Bool =>
    """test if a == 0 within tolerance"""
    a.abs() < tolerance()

  fun near_eq(a: F32, b: F32): Bool =>
    """test if a == b within tolerance"""
    near_zero(a - b)

 