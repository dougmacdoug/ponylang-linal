use "ponytest"

class iso _TestMatrixFun is UnitTest
    fun name():String => "MatrixFun/Basic"

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

      h.assert_eq[Vector3](Vector3(fxg), Vector3(fxg'))
      h.assert_eq[Vector3](Vector3(gxf), Vector3(gxf'))

