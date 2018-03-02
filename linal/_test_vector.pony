use "ponytest"


class iso _TestVectorFun is UnitTest
  fun name():String => "Vector/Basic"
  
  fun apply(h: TestHelper) =>
   let test = _TestHelperHelper(h)
   let vf: VectorFun[V2] val = V2fun
   h.log("======== V2 ========")
    _testVectorFun[V2](V2fun, test)
   h.log("======== V3 ========")
    _testVectorFun[V3](V3fun, test)
   h.log("======== V4 ========")
    _testVectorFun[V4](V4fun, test)

fun _testVectorFun[V: Any val](v: VectorFun[V val] val, test: _TestHelperHelper) =>
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
  test.assert_eq_t[V](zero, zero', "Zero")
  test.assert_eq_t[V](one, one', "One")
  test.assert_eq_t[V](two, two', "Two")
  test.assert_eq_t[V](one, mul1)
  test.assert_eq_t[V](one, div1)
  test.assert_eq_t[V](unit1, unit2)
  test.assert_eq_t[V](zero, lerp0)
  test.assert_eq_t[V](one, lerp1)
  test.assert_eq_t[V](one, lerp1')
  test.assert_eq_t[V](half, half')

// F32 assert_eq fails here due to sqrt() precision
  let prec = F32(1000000)
  let len1 = (v.len(unit1) * prec).round()
  test.assert_eq(1, len1/prec, "unit length")

  test.assert_eq(v.len(one), v.len(v.neg(one)), "length")
  test.assert_eq(dist1, dist2, "distance")
  test.assert_eq(dist1', dist2', "distance squared")

  test.h.assert_eq[U32](v.size().u32(), v.sum(one).round().u32(), "Sum")
  var a = zero
  var out: F32 
  var i: USize = 0

  a = try v.set(a, i, 1)? else zero end
  out = try v.get(a, i)? else -1 end
  test.assert_eq(1, out, "Get/Set: Head")

  i = v.size() - 1
  a = try v.set(a, i, 1)? else zero end
  out = try v.get(a, i)? else -1 end
  test.assert_eq(1, out, "Get/Set: Tail")


  a = v.shift_left(one)
  out = try v.get(a, v.size() - 1)? else -1 end
  test.assert_eq(0, out, "Shift Left")
  a = v.roll_right(a)
  out = try v.get(a, 0)? else -1 end
  test.assert_eq(0, out, "Roll Right")
  
  a = v.shift_right(one)
  out = try v.get(a, 0)? else -1 end
  test.assert_eq(0, out, "Shift Right")
  a = v.roll_left(a)
  out = try v.get(a, v.size() - 1)? else -1 end
  test.assert_eq(0, out, "Roll Left")

  var b : V
  a = one
  b = one
  i = v.size()
  while i > 0 do
    i = i - 1
    a = v.shift_left(a)
    b = v.roll_left(b)
  end

  test.assert_eq_t[V](zero, a)
  test.assert_eq_t[V](one, b)

  a = one
  b = one
  i = v.size()
  while i > 0 do
    i = i - 1
    a = v.shift_right(a)
    b = v.roll_right(b)
  end

  test.assert_eq_t[V](zero, a)
  test.assert_eq_t[V](one, b)


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
