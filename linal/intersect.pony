
primitive Intersect
  """provides hit test methods for linal types"""

  fun ray_point(ray: R2, pt: V3) : Bool =>
    false
  fun plane_plane(a: P4, b: P4): (R2 | None) =>
    None
  
  fun v2_rect(v2: V2, r: R4): (V2 | None) =>
    """if intersects return point translated from origin"""
    if R4fun.contains(r, v2) then
      V2fun.sub(v2, R4fun.origin(r))
    else
      None
    end

  fun rect_rect(a: R4, b: R4): (R4 | None) =>
    """if intersects return point translated from origin"""
    let a_max_x = R4fun.x_max(a)
    let b_min_x = R4fun.x_min(b)
    if a_max_x < b_min_x then return None end
    
    let b_max_x = R4fun.x_max(b)
    let a_min_x = R4fun.x_min(a)
    if b_max_x < a_min_x then return None end

    let a_max_y = R4fun.y_max(a)
    let b_min_y = R4fun.y_min(b)
    if a_max_y < b_min_y then return None end
    
    let b_max_y = R4fun.y_max(b)
    let a_min_y = R4fun.y_min(a)
    if b_max_y < a_min_y then return None end

    let min_x = a_min_x.max(b_min_x)
    let max_x = a_max_x.min(b_max_x)
    let min_y = a_min_y.max(b_min_y)
    let max_y = a_max_y.min(b_max_y)
    R4fun(min_x, min_y, max_x - min_x, max_y - min_y)

  fun ray_ray(a: R2, b: R2): (V3 | None) =>
    let axb = V3fun.cross(a._2, b._2)
    var d = V3fun.len(axb)
    if Linear.approx_eq(d, 0) and
      Linear.approx_eq(a._1._1, b._1._1) and
      Linear.approx_eq(a._1._2, b._1._2) and
      Linear.approx_eq(a._1._3, b._1._3) then
      return V3fun.zero()
    end
    d = d * d
    let ma: M3 = (V3fun.sub(b._1, a._1), b._2, axb)
    let ds = M3fun.det(ma)
    let mb: M3 = (ma._1, a._2, ma._3)
    let dt = M3fun.det(mb)
    let s = ds / d
    let t = dt / d

    let p1 = V3fun.add(a._1, V3fun.mul(a._2, s))
    let p2 = V3fun.add(b._1, V3fun.mul(b._2, t))
    if V3fun.eq(p1, p2, Linear.tolerance()) then
      p1
    else
      None
    end
