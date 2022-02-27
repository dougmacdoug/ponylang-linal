use "pony_test"

class iso _TestM2fun is UnitTest
  fun name():String => "MatrixFun/M2"
  fun apply(h: TestHelper) =>
    let arr = _TestData.arr()
    let test = _TestHelperHelper(h)
    let m2 = M2fun
    let v2 = V2fun
    let zero = m2.zero()
    let one = m2(v2.id(), v2.id())
    let two = m2.add(one, one)
    let a1 = try m2.from_array(arr)? else m2.zero() end
    let a2 = try m2.from_array(arr, 2)? else m2.zero() end 

    let rx = m2.row_x(m2.id())
    let cx = m2.col_x(m2.id())
    let ry = m2.row_y(m2.id())
    let cy = m2.col_y(m2.id())
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
    test.assert_eq((8,18), m2.mul_v2(a1, (2,3)), "m2 * v2")
    test.assert_eq(((13,16),(29,36)), m2.mul_m2(a1, a2), "m2 * m2")
    test.assert_eq(5, m2.trace(a1), "trace")
    let solve_answer = m2.solve(((2,3), (10,16)), (1,2))
    test.assert_eq((5, -3), solve_answer, "Ax=b")
    test.assert_eq(-13, m2.det(((5, -1),(2, -3))), "determinant")
    test.assert_eq(-2, m2.det(a1), "determinant a1")

class iso _TestM3fun is UnitTest
  fun name():String => "MatrixFun/M3"
  fun apply(h: TestHelper) =>
    let arr = _TestData.arr()
    let test = _TestHelperHelper(h)
    let m3 = M3fun
    let v3 = V3fun
    let zero = m3.zero()
    let one = m3(v3.id(), v3.id(), v3.id())
    let two = m3.add(one, one)
    let a1 = try m3.from_array(arr)? else m3.zero() end
    let a2 = try m3.from_array(arr, 2)? else m3.zero() end

    let rx = m3.row_x(m3.id())
    let cx = m3.col_x(m3.id())
    let ry = m3.row_y(m3.id())
    let cy = m3.col_y(m3.id())
    test.assert_eq(rx, cx, "Row X == Col X")
    test.assert_eq(ry, cy, "Row Y == Col Y")
    test.assert_ne(rx, ry, "Row X =/= Row Y")
    test.assert_eq(((1,2,3),(4,5,6),(7,8,9)), a1, "A1")
    test.assert_eq(((3,4,5),(6,7,8),(9,10,11)), a2, "A2")

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
    let inv32 = m3.inv(m3_sample)
    test.assert_eq(1, m3.det(m3_sample), "det 1")

    test.assert_eq(m3_sample_inv, m3.inv(m3_sample), "inverse det=1")

    test.assert_eq(m3.id(), m3.inv(m3.id()), "inverse id = id")

    test.assert_eq(None, m3.inv(a1), "invalid inverse")

    test.assert_eq(m3.id(), m3.trans(m3.id()), "translate id = id")
    test.assert_eq(
      ((1, 4, 7), (2, 5, 8), (3, 6, 9)),
       m3.trans(a1), "translate id = id")

    let m3xv3_sample = m3((2, -5, 1), (0, 3, 4), (-7, 1, 8))
    let m3xv3_sample_v3 = v3(3, -1, 2)

    test.assert_eq((13, 5, -6),
       m3.mul_v3(m3xv3_sample, m3xv3_sample_v3), "m3 * v3")

    test.assert_eq(
      ((42, 48, 54), (96, 111, 126), (150, 174, 198)),
      m3.mul_m3(a1, a2), "m3 * m3")

    let solve_m3 = m3((1, 2, 2), (3, -2, 1), (2, 1, -1))
    let solve_v3 = v3(5, -6, -1)
    let solve_answer = m3.solve(solve_m3, solve_v3)
    test.assert_eq(v3(-1, 2, 1), solve_answer, "solve [m3][v3] equation")

class iso _TestM4fun is UnitTest
  fun name():String => "MatrixFun/M4"
  fun apply(h: TestHelper) =>
    _testMatrix(h)
    _testM4Mul(h)

    fun _testMatrix(h: TestHelper) =>
      let identity: Matrix4 box = Matrix4.id()
      let zero: Matrix4 box = Matrix4(M4fun.zero())
      let all1: Matrix4 box = Matrix4(M4fun(V4fun.id(), V4fun.id(),
        V4fun.id(), V4fun.id()))

      let x = M4fun.row_x(M4fun.id())
      let y = M4fun.row_y(M4fun.id())
      let z = M4fun.row_z(M4fun.id())
      let w = M4fun.row_w(M4fun.id())
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
    
    fun _testM4Mul(h: TestHelper) =>
      let lhs : M4 = ((2, 3, 5, 7), (11, 13, 17, 19),
                      (23, 29, 31, 37), (41, 43, 47, 53))
      let rhs : M4 = ((59, 61, 67, 71), (73, 79, 83, 89),
                      (97, 101, 103, 107), (109, 113, 127, 131))
      let expected : M4 = (
                           (1585, 1655, 1787, 1861),
                           (5318, 5562, 5980, 6246),
                           (10514,11006,11840,12378),
                           (15894,16634,17888,18710)
                           )
      let result: M4 = M4fun.mul_m4(lhs, rhs)

      h.assert_eq[Matrix4 box](Matrix4(expected), Matrix4(result))
