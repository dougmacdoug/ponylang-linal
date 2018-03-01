type R2 is (V3, V3)
"""R2 is a Ray as a tuple with (Position, Direction)"""
type AnyRay is (Ray | R2)

primitive R2fun
  fun zero(): R2 => (V3fun.zero(), V3fun.zero())
  fun apply(p: V3, d: V3): R2 => (p, d)

  fun position(r3: R2): V3 => r3._1
  fun direction(r3: R2): V3 => r3._2
  fun intersect_point(r3: R2, pt: V3) =>
    let m = V3fun.sub(r3._1, pt)
    let b = V3fun.dot(m, r3._2)
    let c = V3fun.dot(m, m) - Linear.tolerance()
    
    if (c > 0) and (b > 0) then 
      false
    else
      let d = (b * b) - c
      d >= 0
    end

  fun to_string(r: R2): String iso^ =>
    recover
      let s = String(60)
      s.append("Ray[P:")
      s.append(V3fun.to_string(r._1))
      s.append(" D:")
      s.append(V3fun.to_string(r._2))
      s.push(']')
      s.>recalc()
    end

   fun eq(a: R2, b: R2, eps: F32 = F32.epsilon()): Bool =>
     V3fun.eq(a._1, b._1, eps)  and V3fun.eq(a._2, b._2, eps)

class Ray is (Stringable & Equatable[Ray])
 fun string(): String iso^ => recover String() end
