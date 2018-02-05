use "ponytest"

class iso _TestMatrixFun is UnitTest
  let arr: Array[F32] = 
    [ 1; 2; 3; 4; 5; 6; 7; 8; 9;10;11;12;13;14;15;16
     17;18;19;20;21;22;23;24;25;26;27;28;29;30;31;32]
  
  fun name():String => "MatrixFun/Basic"

  fun apply(h: TestHelper) =>
    _testM2(h)
    _testMatrix(h)


  fun _testM2(h: TestHelper) =>
    let test = _TestHelperHelper(h)
    let m2 = M2fun
    let v2 = V2fun

    let rx = m2.rowx(m2.id())
    let cx = m2.colx(m2.id())
    let ry = m2.rowy(m2.id())
    let cy = m2.coly(m2.id())
    test.assert_eq(rx, cx, "Row X == Col X")
    test.assert_eq(ry, cy, "Row Y == Col Y")
    test.assert_ne(rx, ry, "Row X =/= Row Y")
    try 
      test.assert_eq(((1,2),(3,4)), m2.from_array(arr)?, "Row X == Col X")
      test.assert_eq(((3,4),(5,6)), m2.from_array(arr, 2)?, "Row X == Col X")
    else
      h.fail("array lookup")
    end

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


