primitive Linear
  """
  linear functions and helpers for linal types
  """

  fun to_string(o: (Q4 | M2 | M3 | M4 | OptVector| F32)): String iso^ =>
    """convert linal tuple based objects to string"""
    match o
    | let v: V2 => V2fun.to_string(v)
    | let v: V3 => V3fun.to_string(v)
    | let v: V4 => V4fun.to_string(v)
    | let v: Q4 => V4fun.to_string(v)
    | let m: M2 => M2fun.to_string(m)
    | let m: M3 => M3fun.to_string(m)
    | let m: M4 => M4fun.to_string(m)
    | let f: F32 => f.string()
    else None.string()
    end

  fun eq(a: F32, b: F32, eps: F32 = F32.epsilon()): Bool =>
    """floating point equality with epsilon"""
    (a - b).abs() < eps
  fun lerp(a: F32, b: F32, t: F32): F32 =>
    """floating point lerp t% (0-1) from a to b"""
    let t' = clamp01(t)
    (a*(1-t')) + (b*t')
  fun unlerp(a: F32, b: F32, t: F32): F32 =>
    """floating point unlerp t% (0-1) from b to a"""
    let t' = clamp01(t)
    (t'-a)/(b-a)
  fun smooth_step(a: F32, b: F32, t: F32): F32 =>
    """floating point smooth step t% (0-1) from a to b"""
    let t' = clamp01(t)
    let x = (t' - a)/(b - a)
    x*x*(3.0 - (2.0*x))
  fun smoother_step(a: F32, b: F32, t: F32): F32 =>
    """floating point smoother step t% (0-1) from a to b"""
    let t' = clamp01(t)
    let x = (t' - a)/(b - a)
    x*x*x*((x*((6.0*x) - 15.0)) + 10.0)

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
    """approximate equality"""
    (b - a).abs() < (1e-6 * a.abs().max(b.abs())).max(F32.epsilon() * 8.0)

  fun toggle(t: F32, len: F32): F32 =>
    """returns t as a modded range from 0 to len"""
    clamp(t - ((t / len).floor() * len), 0, len)

  fun ping_pong(t: F32, len: F32): F32 =>
    let t' = toggle(t, len * 2)
    len - (t' - len).abs()
