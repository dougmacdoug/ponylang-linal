use "ponytest"

class iso _TestMatrixFun is UnitTest
  let arr: Array[F32] =
    [ 1; 2; 3; 4; 5; 6; 7; 8; 9;10;11;12;13;14;15;16
     17;18;19;20;21;22;23;24;25;26;27;28;29;30;31;32]

  fun name():String => "MatrixFun/Basic"

  fun apply(h: TestHelper) =>
    h.log("=============== M2 ===============")
    _testM2(h)
    h.log("=============== M3 ===============")
    _testM3(h)
    _testMatrix(h)

  fun _testM2(h: TestHelper) =>
    let test = _TestHelperHelper(h)
    let m2 = M2fun
    let v2 = V2fun
    let zero = m2.zero()
    let one = m2(v2.id(), v2.id())
    let two = m2.add(one, one)
    let a1 = try m2.from_array(arr)? else m2.zero() end
    let a2 = try m2.from_array(arr, 2)? else m2.zero() end

    let rx = m2.rowx(m2.id())
    let cx = m2.colx(m2.id())
    let ry = m2.rowy(m2.id())
    let cy = m2.coly(m2.id())
    test.assert_eq(rx, cx, "Row X == Col X")
    test.assert_eq(ry, cy, "Row Y == Col Y")
    test.assert_ne(rx, ry, "Row X =/= Row Y")
    test.assert_eq(((1,2),(3,4)), a1, "A1")
    test.assert_eq(((3,4),(5,6)), a2, "A2")
    test.assert_eq(((1,0),(0,1)), m2.rot(0), "Rotate 0")
    test.assert_eq(((0,-1),(1,0)), m2.rot(F32.pi()/2), "Rotate 90")
    test.assert_eq(((-1,0),(0,-1)), m2.rot(F32.pi()), "Rotate 180")
    test.assert_eq(((0,1),(-1,0)), m2.rot(3*(F32.pi()/2)), "Rotate 270")

    let hyp = F32(2).sqrt() / 2
    test.assert_eq(((hyp,-hyp),(hyp,hyp)), m2.rot(F32.pi()/4), "Rotate 45")

    test.assert_eq(((2,0),(0,2)), m2.add(m2.id(), m2.id()), "add")
    test.assert_eq(((0,0),(0,0)), m2.sub(m2.id(), m2.id()), "subtract")
    test.assert_eq(((3,0),(0,3)), m2.mul(m2.id(), 3), "scale")
    test.assert_eq(((0.5,0),(0,0.5)), m2.div(m2.id(), 2), "scale 1/s")
    test.assert_eq(((-1,0),(0,-1)), m2.neg(m2.id()), "negate")
    test.assert_eq(m2.id(), m2.trans(m2.id()), "translate id = id")
    test.assert_eq(((1,3),(2,4)), m2.trans(a1), "translate id = id")
    test.assert_eq((8,18), m2.v2_mul(a1, (2,3)), "m2 * v2")
    test.assert_eq(((13,16),(29,36)), m2.m2_mul(a1, a2), "m2 * m2")
    test.assert_eq(5, m2.trace(a1), "trace")
    test.assert_eq((5, -3), m2.solve(((2,3), (10,16)), (1,2)), "Ax=b")

    test.assert_eq(-2, m2.det(a1), "determinant")

  fun _testM3(h: TestHelper) =>
    let test = _TestHelperHelper(h)
    let m3 = M3fun
    let v3 = V3fun
    let zero = m3.zero()
    let one = m3(v3.id(), v3.id(), v3.id())
    let two = m3.add(one, one)
    let a1 = try m3.from_array(arr)? else m3.zero() end
    let a2 = try m3.from_array(arr, 2)? else m3.zero() end

    let rx = m3.rowx(m3.id())
    let cx = m3.colx(m3.id())
    let ry = m3.rowy(m3.id())
    let cy = m3.coly(m3.id())
    test.assert_eq(rx, cx, "Row X == Col X")
    test.assert_eq(ry, cy, "Row Y == Col Y")
    test.assert_ne(rx, ry, "Row X =/= Row Y")
    test.assert_eq(((1,2,3),(4,5,6),(7,8,9)), a1, "A1")
    test.assert_eq(((3,4,5),(6,7,8),(9,10,11)), a2, "A2")
/*
    test.assert_eq(((1,0),(0,1)), m3.rot(0), "Rotate 0")
    test.assert_eq(((0,-1),(1,0)), m3.rot(F32.pi()/2), "Rotate 90")
    test.assert_eq(((-1,0),(0,-1)), m3.rot(F32.pi()), "Rotate 180")
    test.assert_eq(((0,1),(-1,0)), m3.rot(3*(F32.pi()/2)), "Rotate 270")

    let hyp = F32(2).sqrt() / 2
    test.assert_eq(((hyp,-hyp),(hyp,hyp)), m3.rot(F32.pi()/4), "Rotate 45")
*/

    test.assert_eq(
      ((2, 0, 0), (0, 2, 0), (0, 0, 2)),
       m3.add(m3.id(), m3.id()), "add")
    test.assert_eq(zero, m3.sub(m3.id(), m3.id()), "subtract")
    test.assert_eq(
      ((3, 0, 0), (0, 3, 0), (0, 0, 3)),
       m3.mul(m3.id(), 3), "scale")
    test.assert_eq(
      ((0.5 ,0 ,0), (0, 0.5, 0), (0, 0, 0.5)),
       m3.div(m3.id(), 2), "scale 1/s")
    test.assert_eq(
      ((-1, 0, 0), (0, -1, 0), (0, 0, -1)),
       m3.neg(m3.id()), "negate")

    let m3_sample = m3((1, 2, 3), (0, 1, 4), (5, 6, 0))
    let m3_sample_inv = m3((-24, 18, 5), (20, -15, -4), (-5, 4, 1))
    let inv32 = try m3.inv(m3_sample)? else m3.zero() end
    test.assert_eq(1, m3.det(m3_sample), "det 1")

    test.assert_eq(m3_sample_inv,
      try m3.inv(m3_sample)? else m3.zero() end, "inverse det=1")

    test.assert_eq(m3.id(),
      try m3.inv(m3.id())? else m3.zero() end, "inverse id = id")

    h.log("try invalid inverse " + m3.to_string(a1))
    try
      m3.inv(a1)?
      h.fail("invalid inverse did not error")
    else
      h.log("passed invalid inverse check")
    end

    test.assert_eq(m3.id(), m3.trans(m3.id()), "translate id = id")
    test.assert_eq(
      ((1, 4, 7), (2, 5, 8), (3, 6, 9)),
       m3.trans(a1), "translate id = id")

    let m3xv3_sample = m3((2, -5, 1), (0, 3, 4), (-7, 1, 8))
    let m3xv3_sample_v3 = v3(3, -1, 2)

    test.assert_eq((13, 5, -6),
       m3.v3_mul(m3xv3_sample, m3xv3_sample_v3), "m3 * v3")

    test.assert_eq(
      ((42, 48, 54), (96, 111, 126), (150, 174, 198)),
      m3.m3_mul(a1, a2), "m3 * m3")

    let solve_m3 = m3((1, 2, 2), (3, -2, 1), (2, 1, -1))
    let solve_v3 = v3(5, -6, -1)
    test.assert_eq(v3(-1, 2, 1),
      m3.solve(solve_m3, solve_v3), "solve [m3][v3] equation")

    fun _testMatrix(h: TestHelper) =>
      let identity: Matrix4 box = Matrix4.id()
      let zero: Matrix4 box = Matrix4(M4fun.zero())
      let all1: Matrix4 box = Matrix4(M4fun(V4fun.id(), V4fun.id(),
        V4fun.id(), V4fun.id()))

      let x = M4fun.rowx(M4fun.id())
      let y = M4fun.rowy(M4fun.id())
      let z = M4fun.rowz(M4fun.id())
      let w = M4fun.roww(M4fun.id())
      let v4one = V4fun.add(V4fun.add(V4fun.add(x, y), z), w)

      let ma = Matrix4            // zero
      let mb = Matrix4(identity)  // copy constructor
      let mc = Matrix4(ma + mb)   // construct from tuples

      h.assert_eq[Matrix4](mb, mc)
      ma() = identity * 2
      mb() = identity + identity
      mc() = ma - mb
      h.assert_eq[Matrix4](ma, mb)
      h.assert_eq[Matrix4 box](zero, mc)

      mc() = M4fun(v4one, v4one, v4one, v4one)
      h.assert_eq[Matrix4 box](all1, mc)


