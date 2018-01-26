use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)
  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestVectorFun)
    test(_TestQuaternion)
    test(_TestVectorFunCross)

primitive VectorTester

  fun testVectorFun[V: Any val](v: VectorFun[V val] val, h: TestHelper) =>
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
    
    h.log("0==0 " + _s[V](zero) + " == " + _s[V](zero'))
    h.assert_true(v.eq(zero, zero', F32.epsilon()))

    h.log("1==1 " + _s[V](one) + " == " + _s[V](one'))
    h.assert_true(v.eq(one, one', F32.epsilon()))

    h.log("2==2 " + _s[V](two) + " == " + _s[V](two'))
    h.assert_true(v.eq(two, two', F32.epsilon()))

    h.log("mul1 " + _s[V](one) + " == " + _s[V](mul1))
    h.assert_true(v.eq(one, mul1, F32.epsilon()))

    h.log("div1 " + _s[V](one) + " == " + _s[V](div1))
    h.assert_true(v.eq(one, div1, F32.epsilon()))

    h.log("unit " + _s[V](unit1) + " == " + _s[V](unit2))
    h.assert_true(v.eq(unit1, unit2, F32.epsilon()))

    h.log("dist " + dist1.string() + " == " + dist2.string())
    h.assert_true(Linear.eq(dist1, dist2))

    h.log("dist2 " + dist1'.string() + " == " + dist2'.string())
    h.assert_true(Linear.eq(dist1', dist2'))

    h.log("lerp0 " + _s[V](zero) + " == " + _s[V](lerp0))
    h.assert_true(v.eq(zero, lerp0, F32.epsilon()))

    h.log("lerp1 " + _s[V](one) + " == " + _s[V](lerp1))
    h.assert_true(v.eq(one, lerp1, F32.epsilon()))

    h.log("lerp1' " + _s[V](one) + " == " + _s[V](lerp1'))
    h.assert_true(v.eq(one, lerp1', F32.epsilon()))

    h.log("lerp0.5==0.5 " + _s[V](half) + " == " + _s[V](half'))
    h.assert_true(v.eq(half, half', F32.epsilon()))

    fun testScaleAndCross[V: Any val](v: VectorFun[V val] val, h: TestHelper) =>
      let one   = v.id()

    fun _s[V](a: V val) : String => 
      match a
      | let s: FixVector => Linear.to_string(s)
      else "n/a"
      end

class iso _TestVectorFun is UnitTest
    fun name():String => "VectorFun/Basic"

    fun apply(h: TestHelper) =>
      VectorTester.testVectorFun[V2](V2fun, h)
      VectorTester.testVectorFun[V3](V3fun, h)
      VectorTester.testVectorFun[V4](V4fun, h)

class iso _TestVectorFunCross is UnitTest
    fun name():String => "VectorFun/Cross"

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
      
      let fxg' = V3fun(-2, 4, -2)
      let gxf' = V3fun(2, -4, 2)

      h.log("fxg " + Linear.to_string(fxg) + " == " +  Linear.to_string(fxg'))
      h.assert_true(V3fun.eq(fxg, fxg', F32.epsilon()))

      h.log("gxf " + Linear.to_string(gxf) + " == " +  Linear.to_string(gxf'))
      h.assert_true(V3fun.eq(gxf, gxf', F32.epsilon()))

class iso _TestQuaternion is UnitTest
    fun name():String => "linal/Q4"

    fun apply(h: TestHelper) =>
      let eps = F32.epsilon()
      let v3 = V3fun // gives us nice shorthand to Vector3 Functions
      let v4 = V4fun // gives us nice shorthand to Vector4 Functions
      let quat = Q4fun // gives us nice shorthand to Q4 Functions

      h.assert_eq[F32](quat.len(quat.unit(quat.zero())), eps)
      var a = quat(0,0,0,2)
      var b : Q4
      var result : Q4
      h.assert_eq[F32](2,  quat.len(a))

      let qi = quat(1,0,0,0)
      let qj = quat(0,1,0,0)
      let qk = quat(0,0,1,0)
      let q_one = quat.id()

      h.assert_eq[F32](1,  quat.len(qi))
      h.assert_eq[F32](1,  quat.len(qj))
      h.assert_eq[F32](1,  quat.len(qk))
      h.assert_eq[F32](1,  quat.len(q_one))

      h.assert_true(v4.eq(quat.mulq4(qi,qj), qk))
      h.assert_true(v4.eq(quat.mulq4(qi,qi), v4.neg(q_one)))
      h.assert_true(v4.eq(quat.mulq4(qi,qk), v4.neg(qj)))
      h.assert_true(v4.eq(quat.mulq4(qj,qi), v4.neg(qk)))
      h.assert_true(v4.eq(quat.mulq4(qj,qj), v4.neg(q_one)))
      h.assert_true(v4.eq(quat.mulq4(qj,qk), qi))
      h.assert_true(v4.eq(quat.mulq4(qk,qi), qj))
      h.assert_true(v4.eq(quat.mulq4(qk,qj), v4.neg(qi)))
      h.assert_true(v4.eq(quat.mulq4(qk,qk), v4.neg(q_one)))
      h.assert_true(v4.eq(quat.mulq4(quat.mulq4(qi,qj), qk), v4.neg(q_one)))

      a = quat(0.0, 2.0, 0.0, 0)
      h.log("a=" + Linear.to_string(a))
      b = quat(1.0, 0.0, 3.0, 0)
      h.log("b=" + Linear.to_string(b))
      let axb = quat.mulq4(a,b)
      h.log("axb=" + Linear.to_string(axb))
      let dot_product = axb._4
      h.assert_eq[F32](0, dot_product)
      let cross_product = v3(axb._1, axb._2, axb._3)
      h.assert_true(v3.eq(v3(6,0,-2), cross_product))

      a = quat(1, 2, 3, 4)
      b = quat.div(quat.conj(a), v4.len2(a))
      h.assert_true(quat.eq(quat.inv(a), b))

      a = quat(2, 0, 0, 0)
      h.assert_true(quat.eq(quat.inv(a), quat(-0.5, 0, 0, 0)))

      a = quat(2, 3, 4, 1)
      h.log("a=" + Linear.to_string(a))
      b = quat(3, 4, 5, 2)
      h.log("b=" + Linear.to_string(b))
      result = quat.mulq4(a,b)
      h.log("r=" + Linear.to_string(result))
      h.assert_true(quat.eq(result, quat(6, 12, 12, -36)))
