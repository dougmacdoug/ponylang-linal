use "ponytest"

class iso _TestQuaternion is UnitTest
  fun name(): String => "Quaternion/Q4fun"

  fun apply(h: TestHelper) =>
    let test = _TestHelperHelper(h)
    let v3 = V3fun // gives us nice shorthand to Vector4 Functions
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
    test.assert_eq(q(6, 12, 12, -36), q.q4_mul(a, b), "q4 * q4")

    test.assert_eq(q(5, 7, 9, 3), q.add(a, b), "q4 + q4")
    test.assert_eq(q(-1, -1, -1, -1), q.sub(a, b), "q4 + q4")
    test.assert_eq(q(-1, -1, -1, -1), q.neg(v4.id()), "-q4")

    test.assert_ne(v4.id(), q.id(), "V4 ID =/= Q4 ID")

    let qi = q(1, 0, 0, 0)
    let qj = q(0, 1, 0, 0)
    let qk = q(0, 0, 1, 0)
    let q_one = q.id()

    test.assert_eq(1,  q.len(qi), "QI Length")
    test.assert_eq(1,  q.len(qj), "QJ Length")
    test.assert_eq(1,  q.len(qk), "QK Length")
    test.assert_eq(1,  q.len(q_one), "Q_ONE Length")

    test.assert_eq(qk, q.q4_mul(qi, qj), "k = i*j")
    test.assert_eq(q.q4_mul(qi, qi), v4.neg(q_one), "i*i = -1")
    test.assert_eq(q.q4_mul(qi, qk), v4.neg(qj), "i*k = j")
    test.assert_eq(q.q4_mul(qj, qi), v4.neg(qk), "j*i = k")
    test.assert_eq(q.q4_mul(qj, qj), v4.neg(q_one), "j*j = -1")
    test.assert_eq(q.q4_mul(qj, qk), qi, "j*k = i")
    test.assert_eq(q.q4_mul(qk, qi), qj, "k*i = j")
    test.assert_eq(q.q4_mul(qk, qj), v4.neg(qi), "k*j = -1")
    test.assert_eq(q.q4_mul(qk, qk), v4.neg(q_one), "k*k = -1")
    test.assert_eq(q.q4_mul(q.q4_mul(qi, qj), qk),
                   v4.neg(q_one), "(i*j)*k = -1")

    let hs = F32(0.5).sqrt()
    let r90 = 90 * Linear.deg_to_rad()
    let qx90 = q.from_euler((r90, 0, 0))
    let qy90 = q.from_euler((0, r90, 0))
    let qz90 = q.from_euler((0, 0, r90))
    let qxy90 = q.from_euler((r90, r90, 0))
    let qxz90 = q.from_euler((r90, 0, r90))
    let qyz90 = q.from_euler((0, r90, r90))
    let qxyz90 = q.from_euler((r90, r90, r90))

    test.assert_eq((hs,0,0,hs), qx90, "Euler 90,0,0")
    test.assert_eq((0,hs,0,hs), qy90, "Euler 0,90,0")
    test.assert_eq((0,0,hs,hs), qz90, "Euler 0,0,90")
    test.assert_eq((0.5,0.5,-0.5,0.5), qxy90, "Euler 90,90,0")
    test.assert_eq((0.5,-0.5,0.5,0.5), qxz90, "Euler 90,0,90")
    test.assert_eq((0.5,0.5,0.5,0.5), qyz90, "Euler 0,90,90")
    test.assert_eq((hs,0,0,hs), qxyz90, "Euler 90,90,90")

    // ZXY ORDER
    test.assert_eq(qxyz90,
        q.q4_mul(qy90, q.q4_mul(qx90, qz90)), "q4 mul 90,90,90"
        where eps = 0.0001)

    var euler: V3 = (0, 0, 0)
    var ii: U32 = 0
    var qt : Q4 = Q4fun.id()

    test.assert_eq(q.id(), q.from_euler((0, 0, 0)), "id = xyz 0")
    test.assert_eq(q.neg(q.id()),
     q.unit(q.from_euler(v3.mul(v3.id(), F32.pi()*2))), "-id = xyz 360")

    test.assert_eq(qx90, q.axis_angle(v3(1,0,0), r90), "x axis angle 90")
    test.assert_eq(qy90, q.axis_angle(v3(0,1,0), r90), "y axis angle 90")
    test.assert_eq(qz90, q.axis_angle(v3(0,0,1), r90), "z axis angle 90")

    let r45 = r90 / 2
    // validated using alternate quaternion source for ZXY angles.
    var v = v3(r45, r90, 0)
    test.assert_eq(q(0.270598,0.653282,-0.270598,0.653282),
                    q.from_euler(v), "verified ZXY euler 1/4" where eps = 0.0001)

    v = v3(r45, r45, r90)
    test.assert_eq(q(0.5,0.0,0.5,0.707107),
                    q.from_euler(v), "verified ZXY euler 2/4" where eps = 0.0001)

    v = v3(r90*2, r45, r45*3)
    test.assert_eq(q(0.353553, -0.853553, -0.146447, 0.353553),
                    q.from_euler(v), "verified ZXY euler 3/4" where eps = 0.0001)
    v = v3(r90*3, r45, r45*7)
    test.assert_eq(q(-0.707107, 0, 0, 0.707107),
                    q.from_euler(v), "verified ZXY euler 4/4" where eps = 0.0001)
    let rq = q.unit((0.353553, -0.853553, -0.146447, 0.353553))

    test.assert_eq(q.angle(rq) * Linear.rad_to_deg(),
                   139,     "angles"
         where eps = 2)
        test.assert_eq(v3(0.4, -0.9, -0.1),
            q.axis(rq),     "axis"
         where eps = 0.1)
    
    // var euler: V3 = (0, 0, 0)
    // var ii: U32 = 0
    // var qt : Q4 = Q4fun.id()
    // while ii < 360 do
    //     let r = ii.f32() * Linear.deg_to_rad()
    //     euler = V3fun(r, 0, 0)
    //     qt = q.from_euler(euler)
    //     test.assert_eq(euler, q.to_euler(qt), "X :" + ii.string()
    //         where eps = 0.01)
    //     euler = V3fun(0, r, 0)
    //     qt = q.from_euler(euler)
    //     test.assert_eq(euler, q.to_euler(qt), "Y :" + ii.string()
    //         where eps = 0.01)
    //     euler = V3fun(0, 0, r)
    //     qt = q.from_euler(euler)
    //     test.assert_eq(euler, q.to_euler(qt), "Z :" + ii.string()
    //         where eps = 0.01)
    //     euler = V3fun(r, r, r)

    //     qt = q.from_euler(euler)
    //     let e' = q.to_euler(qt)
    //     let m1 = q.to_m3(qt)
    //     let mq = q.from_m3(m1)
    //     test.assert_eq(euler, q.to_euler(qt), "Z :" + ii.string()
    //         where eps = 0.01)
    //     // test.assert_eq(v3.mul(euler, Linear.rad_to_deg()),
    //     //                v3.mul(e', Linear.rad_to_deg()),
    //     //             "XYZ :" + ii.string() where eps = 1)

    //     ii = ii + 15
    // end

    // 