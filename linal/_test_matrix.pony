use "ponytest"
interface Mfun[M, V]
  fun id(): M
  fun rowx(m:M): V
  fun rowy(m:M): V
  fun colx(m:M): V
  fun coly(m:M): V
  fun eq(a: M, b: M, e: F32 = F32.epsilon()): Bool

interface Vxfun[V]
  fun eq(a: V, b: V, e: F32 = F32.epsilon()): Bool

interface VWrap9[V] is (Stringable & Equatable[VWrap9[box->V]]) 


//   fun eq(that: VWrap9[V] box): Bool
//   fun ne(that: VWrap9[V] box): Bool => not eq(that)
  
class iso _TestMatrixFun is UnitTest
    fun name():String => "MatrixFun/Basic"

    fun apply(h: TestHelper) =>
      _testM4(h)
      let v2: Vector2 = Vector2.zero()
      h.log("Start M2Fun")      
      _testMfun[M2, V2](h, M2fun, V2fun)
      h.log("Start M3Fun")
      _testMfun[M3, V3](h, M3fun, V3fun)
      h.log("Start M4Fun")
      _testMfun[M4, V4](h, M4fun, V4fun)

    // fun _testM2(h: TestHelper) =>
    //   let identity: Matrix2 box = Matrix2.id()
    //   let zero: Matrix2 box = Matrix2(M2fun.zero())
    //   let all1: Matrix2 box = Matrix2(M2fun(V2fun.id(), V2fun.id()))
      
    //   let x = M2fun.rowx(M2fun.id())
    //   let y = M2fun.rowy(M2fun.id())
    //   let v2one = V2fun.add(x, y)

    //   let ma = Matrix2            // zero
    //   let mb = Matrix2(identity)        // copy constructor
    //   let mc = Matrix2(ma + mb)   // construct from tuples

    //   h.assert_eq[Matrix2](mb, mc)
    //   ma() = identity * 2
    //   mb() = identity + identity
    //   mc() = ma - mb
    //   h.assert_eq[Matrix2](ma, mb)
    //   h.assert_eq[Matrix2 box](zero, mc)

    //   mc() = M2fun(v2one, v2one)
    //   h.assert_eq[Matrix2 box](all1, mc)

    //   let rx = M2fun.rowx(M2fun.id())
    //   let cx = M2fun.colx(M2fun.id())
    //   let ry = M2fun.rowy(M2fun.id())
    //   let cy = M2fun.coly(M2fun.id())
    //   h.assert_eq[Vector2](Vector2(rx), Vector2(cx))
    //   h.assert_eq[Vector2](Vector2(ry), Vector2(cy))
    //   h.assert_ne[Vector2](Vector2(rx), Vector2(ry))

    fun _testMfun[M: Any val, V: Any val](h: TestHelper, mf: Mfun[M, V] val,
     vf: Vxfun[V] val) =>

        let rx = mf.rowx(mf.id())
        let cx = mf.colx(mf.id())
        let ry = mf.rowy(mf.id())
        let cy = mf.coly(mf.id())
                
        h.assert_true(vf.eq(rx, cx), "Row X == Col X")
        h.assert_true(vf.eq(ry, cy), "Row Y == Col Y")
        h.assert_false(vf.eq(rx, ry), "Row X =/= Row Y")


    fun _testM4(h: TestHelper) =>
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


