type R3 is (V3, V3)
"""R3 is a Ray as a tuple with (Position, Direction)"""

primitive R3fun
  fun zero(): R3 => (V3fun.zero(), V3fun.zero())
  fun position(r3: R3): V3 => r3._1
  fun direction(r3: R3): V3 => r3._2
  fun intersect_point(r3: R3, pt: V3) =>
    let m = V3fun.sub(r3._1, pt)
    let b = V3fun.dot(m, r3._2)
    let c = V3fun.dot(m, m) - Linear.tolerance()
    
    if (c > 0) and (b > 0) then 
      false
    else
      let d = (b * b) - c
      d >= 0
    end

  fun intersect_ray(a: R3, b: R3): V3 ? =>
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
    if not V3fun.eq(p1, p2, Linear.tolerance()) then
      error
    end
    
    p1