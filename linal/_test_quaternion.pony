use "ponytest"

class iso _TestQuaternion is UnitTest
  fun name(): String => "Quaternion/Q4fun"

  fun apply(h: TestHelper) =>
    let test = _TestHelperHelper(h)
    let v4 = V4fun // gives us nice shorthand to Vector4 Functions
    let q = Q4fun // gives us nice shorthand to Q4 Functions

    test.assert_eq(1, q.len(q.unit(q.id())), "Unit length")
    test.assert_eq(1, q.len(q.id()), "Identity length")
    test.assert_eq(2,  q.len(q(0, 0, 0, 2)), "Length: 2")
    var a = q(1, 2, 3, 4)
    var b = q.div(q.conj(a), v4.len2(a))
    test.assert_eq(q.inv(a), b, "Inv = conj/len2")

    a = q(2, 0, 0, 0)
    test.assert_eq(q.inv(a), q(-0.5, 0, 0, 0), "Inverse")

    a = q(2, 3, 4, 1)
    b = q(3, 4, 5, 2)
    test.assert_eq(q(6, 12, 12, -36), q.mulq4(a, b), "q4 * q4")

    test.assert_eq(q(5, 7, 9, 3), q.add(a, b), "q4 + q4")
    test.assert_eq(q(-1, -1, -1, -1), q.sub(a, b), "q4 + q4")
    test.assert_eq(q(-1, -1, -1, -1), q.neg(v4.id()), "-q4")

    test.assert_ne(v4.id(), q.id(), "V4 ID =/= Q4 ID")


    let qi = q(1,0,0,0)
    let qj = q(0,1,0,0)
    let qk = q(0,0,1,0)
    let q_one = q.id()

    test.assert_eq(1,  q.len(qi), "QI Length")
    test.assert_eq(1,  q.len(qj), "QJ Length")
    test.assert_eq(1,  q.len(qk), "QK Length")
    test.assert_eq(1,  q.len(q_one), "Q_ONE Length")

    test.assert_eq(qk, q.mulq4(qi,qj), "k = i*j")
    test.assert_eq(q.mulq4(qi,qi), v4.neg(q_one), "i*i = -1")
    test.assert_eq(q.mulq4(qi,qk), v4.neg(qj), "i*k = j")
    test.assert_eq(q.mulq4(qj,qi), v4.neg(qk), "j*i = k")
    test.assert_eq(q.mulq4(qj,qj), v4.neg(q_one), "j*j = -1")
    test.assert_eq(q.mulq4(qj,qk), qi, "j*k = i")
    test.assert_eq(q.mulq4(qk,qi), qj, "k*i = j")
    test.assert_eq(q.mulq4(qk,qj), v4.neg(qi), "k*j = -1")
    test.assert_eq(q.mulq4(qk,qk), v4.neg(q_one), "k*k = -1")
    test.assert_eq(q.mulq4(q.mulq4(qi,qj), qk), v4.neg(q_one), "(i*j)*k = -1")


