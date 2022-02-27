use "pony_test"

type _Testable is (LinalType | None)

class _TWrap is (Stringable & Equatable[_TWrap])
  var _o: _Testable = None
  var _eps: F32 = F32.epsilon()
  fun ref apply(o: _Testable, eps: F32 = F32.epsilon()): _TWrap =>
    _o = o
    _eps = eps
    this

  fun eq(that: box->_TWrap): Bool =>
    match (_o, that._o)
    | (let a: V2,  let b: V2) =>   V2fun.eq(a, b, _eps)
    | (let a: V3,  let b: V3) =>   V3fun.eq(a, b, _eps)
    | (let a: V4,  let b: V4) =>   V4fun.eq(a, b, _eps)
    | (let a: M2,  let b: M2) =>   M2fun.eq(a, b, _eps)
    | (let a: M3,  let b: M3) =>   M3fun.eq(a, b, _eps)
    | (let a: M4,  let b: M4) =>   M4fun.eq(a, b, _eps)
    | (let a: R4,  let b: R4) =>   R4fun.eq(a, b, _eps)
    | (let a: R2,  let b: R2) =>   R2fun.eq(a, b, _eps)
    | (let a: P4,  let b: P4) =>   P4fun.eq(a, b, _eps)
    | (let a: F32, let b: F32) => Linear.eq(a, b, _eps)
    | (None, None) => true
    else false
    end

  fun ne(that: box->_TWrap): Bool => not eq(that)
  
  fun string(): String iso^ =>
    match _o 
    | let n: F32 => n.string()
   else 
    Linear.to_string(_o)
    end

class _TestHelperHelper
  let h: TestHelper
  let _this: _TWrap = _TWrap
  let _that: _TWrap = _TWrap

  new create(h': TestHelper)=> h=h'


  fun ref assert_eq_t[V: Any val](a: V, b: V,
                    msg: String = "", loc: SourceLoc = __loc) 
  =>
    match (a, b)
    |  (let a': _Testable, let b': _Testable) => 
      assert_eq(a', b', msg, loc)
    else 
      h.log("unknown type")
      h.fail()
    end

  fun ref assert_ne_t[V: Any val](a: V, b: V,
                    msg: String = "", loc: SourceLoc = __loc) 
  =>
    match (a, b)
    |  (let a': _Testable, let b': _Testable) => 
      assert_ne(a', b', msg, loc)
    else 
      h.log("unknown type")
      h.fail()
    end

  fun ref assert_eq(a: _Testable, b: _Testable,
                    msg: String = "", loc: SourceLoc = __loc,
                    eps: F32 = F32.epsilon())
  =>
    _this
    h.assert_eq[_TWrap](_this(a, eps), _that(b), msg, loc)
  
  fun ref assert_ne(a: _Testable, b: _Testable,
                    msg: String = "", loc: SourceLoc= __loc)
  =>
    h.assert_ne[_TWrap](_this(a), _that(b), msg, loc)

primitive _TestData
  fun arr(): Array[F32] val =>
    [1; 2; 3; 4; 5; 6; 7; 8; 9;10;11;12;13;14;15;16
     17;18;19;20;21;22;23;24;25;26;27;28;29;30;31;32]

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)
  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestVectorFun)
    test(_TestQuaternion)
    test(_TestVectorFunCross)
    test(_TestM2fun)
    test(_TestM3fun)
    test(_TestM4fun)
    test(_TestLinearString)
    test(_TestStringable)    
    test(_TestLinearEq)
    test(_TestLinearClamp)
    test(_TestLinearFun)
    test(_TestIntersect)

class iso _TestLinearString is UnitTest
  fun name():String => "Linear/String"

  fun apply(h: TestHelper) =>
    let v2 = V2fun(1, 2)
    let v3 = V3fun(1, 2, 3)
    let v4 = V4fun(1, 2, 3, 4)
    let q4 = Q4fun(1, 2, 3, 4)

    h.assert_eq[String]("None", Linear.to_string(None))
    h.assert_eq[String]("(1,2)", Linear.to_string(v2))
    h.assert_eq[String]("(1,2,3)", Linear.to_string(v3))
    h.assert_eq[String]("(1,2,3,4)", Linear.to_string(v4))
    h.assert_eq[String]("(1,2,3,4)", Linear.to_string(q4))

    h.assert_eq[String]("((1,2),(3,4))",
     Linear.to_string(M2fun((1, 2),(3,4))))
    h.assert_eq[String]("((1,2,3),(4,5,6),(7,8,9))",
     Linear.to_string(M3fun((1,2,3),(4,5,6),(7,8,9))))

    h.assert_eq[String]("((1,2,3,4),(5,6,7,8),(9,10,11,12),(13,14,15,16))",
     Linear.to_string(M4fun((1,2,3,4),(5,6,7,8),(9,10,11,12),(13,14,15,16))))

class iso _TestStringable is UnitTest

  fun name():String => "Linear/Stringable"

  fun apply(h: TestHelper) =>
    let v2 = V2fun(1, 2)
    let v3 = V3fun(1, 2, 3)
    let v4 = V4fun(1, 2, 3, 4)
    let q4 = Q4fun(1, 2, 3, 4)
    let m4 = M4fun((1,2,3,4),(5,6,7,8),(9,10,11,12),(13,14,15,16))
    _testStringable(h, "(1,2)", Vector2(v2), "Vector2.string()")
    _testStringable(h, "(1,2,3)", Vector3(v3), "Vector3.string()")
    _testStringable(h, "(1,2,3,4)", Vector4(v4), "Vector4.string()")
    _testStringable(h, "(1,2,3,4)", Quaternion(q4), "Quaternion.string()")
    _testStringable(h, "((1,2,3,4),(5,6,7,8),(9,10,11,12),(13,14,15,16))",
      Matrix4(m4), "Matrix4.string()")


  fun _testStringable(h: TestHelper, expected: String, s: Stringable,
    msg: String = "", loc: SourceLoc = __loc) =>
    h.assert_eq[String](expected, s.string(), msg, loc)

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
