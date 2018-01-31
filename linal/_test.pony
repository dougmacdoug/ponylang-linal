use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)
  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestVectorFun)
    test(_TestQuaternion)
    test(_TestVectorFunCross)
    test(_TestMatrixFun)
    test(_TestLinearString)
    test(_TestLinearEq)
    test(_TestLinearClamp)
    test(_TestLinearVec)
    test(_TestLinearFun)


class iso _TestQuaternion is UnitTest
  fun name(): String => "linal/Q4"

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


class iso _TestLinearString is UnitTest
  fun name():String => "Linear/String"

  fun apply(h: TestHelper) =>
    h.assert_eq[String]("(1,2)", Linear.to_string(V2fun(1, 2)))
    h.assert_eq[String]("(1,2,3)", Linear.to_string(V3fun(1, 2, 3)))
    h.assert_eq[String]("(1,2,3,4)", Linear.to_string(V4fun(1, 2, 3, 4)))
    h.assert_eq[String]("(1,2,3,4)", Linear.to_string(Q4fun(1, 2, 3, 4)))

    h.assert_eq[String]("((1,2),(3,4))",
     Linear.to_string(M2fun((1, 2),(3,4))))
    h.assert_eq[String]("((1,2,3),(4,5,6),(7,8,9))",
     Linear.to_string(M3fun((1,2,3),(4,5,6),(7,8,9))))

    h.assert_eq[String]("((1,2,3,4),(5,6,7,8),(9,10,11,12),(13,14,15,16))",
     Linear.to_string(M4fun((1,2,3,4),(5,6,7,8),(9,10,11,12),(13,14,15,16))))

class iso _TestLinearClamp is UnitTest
  fun name():String => "Linear/Clamp"

  fun apply(h: TestHelper) =>
    h.assert_eq[F32](-1, Linear.clamp(1, -2, -1))
    h.assert_eq[F32](-1.5, Linear.clamp(-1.5, -2, -1))
    h.assert_eq[F32](1, Linear.clamp(0, 1, 2))
    h.assert_eq[F32](1.5, Linear.clamp(1.5, 1, 2))

    h.assert_eq[F32](0, Linear.clamp01(0))
    h.assert_eq[F32](0, Linear.clamp01(-1))
    h.assert_eq[F32](1, Linear.clamp01(1))
    h.assert_eq[F32](1, Linear.clamp01(2))


class iso _TestLinearEq is UnitTest
  fun name():String => "Linear/Equality"

  fun apply(h: TestHelper) =>
    h.assert_true(Linear.eq(F32.epsilon()/F32.min_value(), 0))
    h.assert_true(Linear.eq(F32.epsilon()/F32.max_value(), 0))
    h.assert_true(Linear.eq(1, 1.1, 0.11))
    h.assert_false(Linear.eq(1, 1.1, 0.09))
    h.assert_true(Linear.eq(1, 1))
    h.assert_false(Linear.eq(1, 1.1))

class iso _TestLinearVec is UnitTest
  fun name():String => "Linear/Vec"

  fun apply(h: TestHelper) =>
    """"""
    // h.assert_eq[Vector2](Vector2((1, 2)),
    //                      Linear.vector2((1, 2)))
    // h.assert_eq[Vector3](Vector3((1, 2,3)),
    //                      Linear.vector3((1, 2, 3)))
    // h.assert_eq[Vector4](Vector4((1, 2, 3, 4)),
    //                      Linear.vector4((1, 2, 3, 4)))
 
    // h.assert_eq[Vector2](Vector2.zero(), Linear.vector2(None))
    // h.assert_eq[Vector3](Vector3.zero(), Linear.vector3(None))
    // h.assert_eq[Vector4](Vector4.zero(), Linear.vector4(None))

    // h.assert_eq[Vector2](Vector2.id(), Linear.vector2(V2fun.id()))
    // h.assert_eq[Vector2](Vector2.id(), Linear.vector2(V3fun.id()))
    // h.assert_eq[Vector2](Vector2.id(), Linear.vector2(V4fun.id()))
 
    // h.assert_eq[Vector3](Vector3((1, 1, 0)), Linear.vector3(V2fun.id()))
    // h.assert_eq[Vector3](Vector3.id(), Linear.vector3(V3fun.id()))
    // h.assert_eq[Vector3](Vector3.id(), Linear.vector3(V4fun.id()))
 
    // h.assert_eq[Vector4](Vector4((1, 1, 0, 0)), Linear.vector4(V2fun.id()))
    // h.assert_eq[Vector4](Vector4((1, 1, 1, 0)), Linear.vector4(V3fun.id()))
    // h.assert_eq[Vector4](Vector4.id(), Linear.vector4(V4fun.id()))

class iso _TestLinearFun is UnitTest
  fun name():String => "Linear/Fun"

  fun apply(h: TestHelper) =>
    h.assert_eq[F32](1, Linear.gamma(1, 1, 1))

    h.assert_eq[F32](0.25, Linear.gamma(1, 2, 3))
    h.assert_eq[F32](0.125, Linear.gamma(1, 2, 4))
    h.assert_true(Linear.eq(0.142857, Linear.gamma(1, 7, 2), 0.00001))

    h.assert_true(Linear.approx_eq(0,  0.0000001))
    h.assert_false(Linear.approx_eq(0, 0.000001))
    h.assert_true(Linear.approx_eq(1,  1.000001))
    h.assert_false(Linear.approx_eq(1, 1.00001))

    h.assert_true(Linear.approx_eq(999999.9, 1000000))
    h.assert_false(Linear.approx_eq(999999,  1000000))

    h.assert_eq[F32](1, Linear.toggle(1, 3))
    h.assert_eq[F32](2, Linear.toggle(2, 3))
    h.assert_eq[F32](0, Linear.toggle(3, 3))
    h.assert_eq[F32](1, Linear.toggle(4, 3))
    h.assert_eq[F32](2, Linear.toggle(5, 3))
    h.assert_eq[F32](0, Linear.toggle(6, 3))

    h.assert_eq[F32](1, Linear.ping_pong(1, 3))
    h.assert_eq[F32](2, Linear.ping_pong(2, 3))
    h.assert_eq[F32](3, Linear.ping_pong(3, 3))
    h.assert_eq[F32](2, Linear.ping_pong(4, 3))
    h.assert_eq[F32](1, Linear.ping_pong(5, 3))
    h.assert_eq[F32](0, Linear.ping_pong(6, 3))
    h.assert_eq[F32](1, Linear.ping_pong(7, 3))
    h.assert_eq[F32](2, Linear.ping_pong(8, 3))
    h.assert_eq[F32](3, Linear.ping_pong(9, 3))
