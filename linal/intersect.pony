
primitive Intersect
  """provides hit test methods for linal types"""

  fun ray_point(ray: R2, pt: V3) : (V3 | None) =>
    let m = V3fun.sub(ray._1, pt)
    let b = V3fun.dot(m, ray._2)
    let c = V3fun.dot(m, m) - Linear.tolerance()
    let d = (b * b) - c
    if ((c > 0) and (b > 0)) or (d < 0) then 
      None
    else pt end

  fun plane_plane(a: P4, b: P4): (R2 | None) =>
    (let a_norm, let a_dist) = a
    (let b_norm, let b_dist) = b
    let dir = V3fun.cross(a_norm, b_norm)
    let d =  V3fun.dot(dir, dir)
    if Linear.near_zero(d) then return None end
    
    let a_x = V3fun.mul(a_norm, b_dist)
    let b_x = V3fun.mul(b_norm, a_dist)
    let tmp = V3fun.sub(b_x, a_x)
    let pt: V3 = V3fun.cross(tmp, dir)

    R2fun(pt, V3fun.unit(dir))
  
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
    (let a_pt, let a_dir) = a
    (let b_pt, let b_dir) = b
    let axb = V3fun.cross(a_dir, b_dir)
    var d = V3fun.len(axb)
    if Linear.near_zero(d) and
      Linear.near_eq(a_pt._1, b_pt._1) and
      Linear.near_eq(a_pt._2, b_pt._2) and
      Linear.near_eq(a_pt._3, b_pt._3) then
      return V3fun.zero()
    end
    d = d * d
    let ma: M3 = (V3fun.sub(b_pt, a_pt), b_dir, axb)
    let ds = M3fun.det(ma)
    let mb: M3 = (ma._1, a_dir, ma._3)
    let dt = M3fun.det(mb)
    let s = ds / d
    let t = dt / d

    let p1 = V3fun.add(a_pt, V3fun.mul(a_dir, s))
    let p2 = V3fun.add(b_pt, V3fun.mul(b_dir, t))
    if V3fun.eq(p1, p2, Linear.tolerance()) then
      p1
    else
      None
    end
