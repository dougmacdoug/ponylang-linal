use "ponytest"

class iso _TestVectorFun is UnitTest
  fun name():String => "Vector/Basic"
  
  fun apply(h: TestHelper) =>
    let test2 = {(a: V2, b: V2): Bool => 
      h.assert_eq[Vector2](Vector2(a), Vector2(b))}
    let test3 = {(a: V3, b: V3): Bool =>
     h.assert_eq[Vector3](Vector3(a), Vector3(b))}
    let test4 = {(a: V4, b: V4): Bool =>
      h.assert_eq[Vector4](Vector4(a), Vector4(b))}
// Vector as a type parameter fails due to tuple @Hack workaround
// so just use lambdas here
    _testVectorFun[V2, V2fun](test2, h)
    _testVectorFun[V3, V3fun](test3, h)
    _testVectorFun[V4, V4fun](test4, h)

fun _testVectorFun[V: Any val, VF: VectorFun[V val] val](
    test: {(V, V): Bool}, h: TestHelper) =>
  let v = VF
  let zero  = v.zero()
  let one   = v.id()
  let one'  = v.add(zero, one)
  let zero' = v.sub(one, one')
  let two   = v.add(one, one')
  let two'  = v.mul(one, 2)

  let mul1  = v.div(one, 1)
  let div1  = v.div(two, 2)
  let unit1 = v.unit(one)
  let unit2 = v.unit(two)

  let dist1 = v.dist(one, zero)
  let dist2 = v.dist(one, two)

  let dist1' = v.dist2(one, zero)
  let dist2' = v.dist2(one, two)

  let lerp0 = v.lerp(zero, one, 0)
  let lerp1 = v.lerp(zero, one, 1)
  let lerp1' = v.lerp(zero, two, 0.5)

  let half =  v.lerp(zero, one, 0.5)
  let half' = v.mul(one, 0.5)
  test(zero, zero')
  test(one, one')
  test(two, two')

  test(one, mul1)
  test(one, div1)
  test(unit1, unit2)

  test(zero, lerp0)
  test(one, lerp1)
  test(one, lerp1')

  test(half, half')

// F32 assert_eq fails here due to sqrt() precision
  let prec = F32(1000000)
  let len1 = (v.len(unit1) * prec).round()
  h.assert_eq[F32](1, len1/prec, "unit length")

  h.assert_eq[F32](v.len(one), v.len(v.neg(one)), "length")
  h.assert_eq[F32](dist1, dist2, "distance")
  h.assert_eq[F32](dist1', dist2', "distance squared")

  h.assert_eq[U32](v.size().u32(), v.sum(one).round().u32(), "Sum")
  var a = zero
  var out: F32 
  var i: USize = 0

  a = try v.set(a, i, 1)? else zero end
  out = try v.get(a, i)? else -1 end
  h.assert_eq[F32](1, out, "Get/Set: Head")

  i = v.size() - 1
  a = try v.set(a, i, 1)? else zero end
  out = try v.get(a, i)? else -1 end
  h.assert_eq[F32](1, out, "Get/Set: Tail")


  a = v.shift_left(one)
  out = try v.get(a, v.size() - 1)? else -1 end
  h.assert_eq[F32](0, out, "Shift Left")
  a = v.roll_right(a)
  out = try v.get(a, U32(0))? else -1 end
  h.assert_eq[F32](0, out, "Roll Right")
  
  a = v.shift_right(one)
  out = try v.get(a, U32(0))? else -1 end
  h.assert_eq[F32](0, out, "Shift Right")
  a = v.roll_left(a)
  out = try v.get(a, v.size() - 1)? else -1 end
  h.assert_eq[F32](0, out, "Roll Left")

  var b : V
  a = one
  b = one
  i = v.size()
  while i > 0 do
    i = i - 1
    a = v.shift_left(a)
    b = v.roll_left(b)
  end

  test(zero, a)
  test(one, b)

  a = one
  b = one
  i = v.size()
  while i > 0 do
    i = i - 1
    a = v.shift_right(a)
    b = v.roll_right(b)
  end

  test(zero, a)
  test(one, b)


class iso _TestVectorFunCross is UnitTest
  fun name():String => "Vector/Cross"

  fun apply(h: TestHelper) =>
    let a = V2fun(1,3)
    let b = V2fun(2,4)

    let axb = V2fun.cross(a, b)
    let bxa = V2fun.cross(b, a)
    h.assert_eq[F32](axb, -2)
    h.assert_eq[F32](bxa, 2)

    let f = V3fun(1, 3, 5)
    let g = V3fun(2, 4, 6)

    let fxg = V3fun.cross(f, g)
    let gxf = V3fun.cross(g, f)

    h.assert_eq[Vector3](Vector3(fxg), Vector3((-2, 4, -2)))
    h.assert_eq[Vector3](Vector3(gxf), Vector3((2, -4, 2)))
