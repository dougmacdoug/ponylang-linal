use "ponytest"
class iso _TestIntersect is UnitTest
  fun name():String => "Intersect"

  fun apply(h: TestHelper) =>
    let test = _TestHelperHelper(h)
    h.log("====== TEST INTERSECT RECT =======")
    _testRect(test)
   _testRay(test)


  fun _testRect(test: _TestHelperHelper) =>
    let pt1 = V2fun(1,2)
    let rect1 = R4fun(-1,-2, 5, 6)
    let rect2 = R4fun(0,-3, 3, 10)
    test.assert_eq(None, Intersect.v2_rect((10,10), rect1),
     "point out of rect")
    test.assert_eq(V2fun(2,4), Intersect.v2_rect(pt1, rect1),
     "point in rect")

    test.assert_eq(None, Intersect.rect_rect(rect1,
      R4fun.move(rect1, (10,0))), "rect out of rect 1")
    test.assert_eq(None, Intersect.rect_rect(rect1,
      R4fun.move(rect1, (0,10))), "rect out of rect 1")
    test.assert_eq(None, Intersect.rect_rect(rect1,
      R4fun.move(rect1, (-10,0))), "rect out of rect 1")
    test.assert_eq(None, Intersect.rect_rect(rect1,
      R4fun.move(rect1, (0,-10))), "rect out of rect 1")
    test.assert_ne(None, Intersect.rect_rect(rect1,
      R4fun.move(rect1, (2, 2))), "move inside")

    test.assert_eq(rect1,
      Intersect.rect_rect(rect1, rect1), "same rect")
    test.assert_eq(R4fun(0, -2, 3, 6),
      Intersect.rect_rect(rect1, rect2), "inner rect")

  fun _testRay(test: _TestHelperHelper) =>
    let ray = Linear.ray()
    let v3 = Linear.vector3()

    let pt1 = v3(1, 2, 3)
    let r1 = ray(pt1, (1,2,3))

    
