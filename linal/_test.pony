use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)
  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestVector)
    test(_TestQuaternion)


class iso _TestVector is UnitTest
    fun name():String => "linal/Vector"

    fun apply(h: TestHelper) =>
      let v2 = V2fun // gives us nice shorthand to Vector2 Functions
      let pt_a = (F32(1),F32(1))
      let pt_b : V2 = (3,3)
      let d = v2.dist(pt_a,pt_b)
      h.assert_true(Linear.eq(2.828, d, 0.001))

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
