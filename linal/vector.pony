type V2 is (F32, F32)
""" tuple based Vector2 alias"""
type V3 is (F32, F32, F32)
""" tuple based Vector3 alias"""
type V4 is (F32, F32, F32, F32)
""" tuple based Vector4 alias"""
type FixVector  is (V2 | V3 | V4)
""" tuple based Vector alias"""
// @TODO: consider removing.. not particularly useful
type OptVector is (FixVector | None)
""" tuple based Vector or None alias"""

// @Hack VectorX is Vector[VX] but compiler requires both in the alias
type AnyVector2 is (Vector2 | Vector[V2] | V2) 
"""instance | tuple vector 2 alias"""
type AnyVector3 is (Vector3 | Vector[V3] | V3)
"""instance | tuple vector 3 alias"""
type AnyVector4 is (Vector4 | Vector[V4] | V4)
"""instance | tuple vector 4 alias"""

// cannot use tuple as constraint
// trait primarily used for code validation
trait VectorFun[V /*: Vector */]
"""Trait defining tuple based vector functions"""
  fun zero() : V
  fun id() : V
  fun add(a: V, b: V) : V
  fun sub(a: V, b: V) : V
  fun neg(v: V) : V
  fun mul(v: V, s: F32) : V
  fun div(v: V, s: F32)  : V
  fun dot(a: V, b: V) : F32
  fun len2(v: V) : F32
  fun len(v: V) : F32
  fun dist2(a : V, b : V) : F32
  fun dist(a : V, b : V) : F32
  fun unit(v : V) : V
  fun eq(a: V, b: V, eps: F32) : Bool
  fun lerp(a: V, b: V, t: F32) : V

  fun v2(v: V) : V2
  fun v3(v: V) : V3
  fun v4(v: V) : V4

primitive V2fun is VectorFun[V2 val]
  fun apply(x' : F32, y': F32) : V2 => (x',y')
  fun zero() : V2 => (0,0)
  fun id() : V2 => (1,1)
  fun add(a: V2, b: V2) : V2 => (a._1 + b._1, a._2 + b._2)
  fun sub(a: V2, b: V2) : V2 => (a._1 - b._1, a._2 - b._2)
  fun neg(v: V2) : V2 => (-v._1 , -v._2)
  fun mul(v: V2, s: F32) : V2  => (v._1 * s, v._2 * s)
  fun div(v: V2, s: F32)  : V2  => (v._1 / s, v._2 / s)
  fun dot(a: V2, b: V2) : F32 => (a._1 * b._1) + (a._2 * b._2)

  fun len2(v: V2) : F32 => dot(v,v)
  fun len(v: V2) : F32 => dot(v,v).sqrt()
  fun dist2(a : V2, b : V2) : F32  => len2(sub(a,b))
  fun dist(a : V2, b : V2) : F32  => len(sub(a,b))
  fun unit(v : V2) : V2 => div(v, len(v))
  fun cross(a: V2, b: V2) : F32 => (a._1*b._2) - (b._1*a._2)
  fun eq(a: V2, b: V2, eps: F32 = F32.epsilon()) : Bool =>
    Linear.eq(a._1,b._1, eps)  and Linear.eq(a._2,b._2, eps)
  fun v2(v: V2) : V2 => v
  fun v3(v: V2) : V3 => (v._1, v._2, 0)
  fun v4(v: V2) : V4 => (v._1, v._2, 0, 0)

  fun lerp(a: V2, b: V2, t : F32) : V2 => 
    (Linear.lerp(a._1, b._1, t), Linear.lerp(a._2, b._2, t))

primitive V3fun is VectorFun[V3 val]
  fun apply(x' : F32, y': F32, z': F32) : V3 => (x',y',z')
  fun zero() : V3 => (0,0,0)
  fun id() : V3 => (1,1,1)
  fun add(a: V3, b: V3) : V3 => (a._1 + b._1, a._2 + b._2, a._3 + b._3)
  fun sub(a: V3, b: V3) : V3 => (a._1 - b._1, a._2 - b._2, a._3 - b._3)
  fun neg(v: V3) : V3 => (-v._1 , -v._2, -v._3)
  fun mul(v: V3, s: F32) : V3  => (v._1 * s, v._2 * s, v._3 * s)
  fun div(v: V3, s: F32)  : V3  => (v._1 / s, v._2 / s, v._3 / s)
  fun dot(a: V3, b: V3) : F32 => (a._1 * b._1) + (a._2 * b._2) + (a._3 * b._3)
  fun len2(v: V3) : F32 => dot(v,v)
  fun len(v: V3) : F32 => dot(v,v).sqrt()
  fun dist2(a : V3, b : V3) : F32  => len2(sub(a,b))
  fun dist(a : V3, b : V3) : F32  => len(sub(a,b))
  fun unit(v : V3) : V3 => div(v, len(v))
  fun cross(a: V3, b: V3) : V3 =>
    ((a._2*b._3) - (a._3*b._2), (a._3*b._1) - (a._1*b._3), (a._1*b._2) - (a._2*b._1))
  fun eq(a: V3, b: V3, eps: F32 = F32.epsilon()) : Bool =>
    Linear.eq(a._1,b._1, eps)  and Linear.eq(a._2,b._2, eps) and Linear.eq(a._3,b._3, eps)
  fun v2(v: V3) : V2 => (v._1, v._2)
  fun v3(v: V3) : V3 => v
  fun v4(v: V3) : V4 => (v._1, v._2, v._3, 0)
  fun lerp(a: V3, b: V3, t : F32) : V3 => 
    (Linear.lerp(a._1, b._1, t), Linear.lerp(a._2, b._2, t), Linear.lerp(a._3, b._3, t))

primitive V4fun is VectorFun[V4 val]
  fun apply(x' : F32, y': F32, z': F32, w': F32) : V4 => (x',y',z',w')
  fun zero() : V4 => (0,0,0,0)
  fun id() : V4 => (1,1,1,1)
  fun add(a: V4, b: V4) : V4 =>
    (a._1 + b._1, a._2 + b._2, a._3 + b._3, a._4 + b._4)
  fun sub(a: V4, b: V4) : V4 =>
    (a._1 - b._1, a._2 - b._2, a._3 - b._3, a._4 - b._4)
  fun neg(v: V4) : V4 => (-v._1 , -v._2, -v._3, -v._4)
  fun mul(v: V4, s: F32) : V4  => (v._1 * s, v._2 * s, v._3 * s, v._4 * s)
  fun div(v: V4, s: F32)  : V4  => (v._1 / s, v._2 / s, v._3 / s, v._4 / s)
  fun dot(a: V4, b: V4) : F32 =>
    (a._1 * b._1) + (a._2 * b._2) + (a._3 * b._3)+ (a._4 * b._4)
  fun len2(v: V4) : F32 => dot(v,v)
  fun len(v: V4) : F32 => dot(v,v).sqrt()
  fun dist2(a : V4, b : V4) : F32  => len2(sub(a,b))
  fun dist(a : V4, b : V4) : F32  => len(sub(a,b))
  fun unit(v : V4) : V4 => div(v, len(v))
  fun eq(a: V4, b: V4, eps: F32 = F32.epsilon()) : Bool =>
   Linear.eq(a._1,b._1, eps)  and Linear.eq(a._2,b._2, eps)
   and Linear.eq(a._3,b._3, eps) and Linear.eq(a._4,b._4, eps)
   fun v2(v: V4) : V2 => (v._1, v._2)
   fun v3(v: V4) : V3 => (v._1, v._2, v._3)
   fun v4(v: V4) : V4 => v
   fun lerp(a: V4, b: V4, t : F32) : V4 => 
    (Linear.lerp(a._1, b._1, t), Linear.lerp(a._2, b._2, t),
     Linear.lerp(a._3, b._3, t), Linear.lerp(a._4, b._4, t))




// @Hack tuples dont work for subtypes so using Any instead of FixVector
trait Vector[V : Any #read] is (Stringable & Equatable[Vector[V val]])
"""
@author macdougall.doug@gmail.com

Class Wrapper for Tuple-based Linear Algebra for typical 2d, 3d operations
  - mainly used for sugar
  - minimize GC'd classes by returning Tuple-based objects for all operations
  - update() allows reuse of instance

@TODO
  - math ops on different sizes grow vectors..
    ...  might be better to disallow this

Example:
  let a : V2 = (3,3) // Tuple-based Vector2
  let b = Vector2((1,3))
  let d = V2fun.add(a, b) // a + b
  let f = V2fun.mul(V2fun.unit(d), 5) // scale to 5 units

@Note: initially designed classes to be assignable from any vector but
this could lead to errors which are meant to be found by strongly typed 
languages. if you need to resize and copy a vector use a new constructor
on the appropriate vector

  let p2 = Vector2((5,3))    // construct from tuple
  let p2' = Vector2(p2)      // construct from instance
  let p3 = Vector3((5,3,1))  // construct from tuple
  let p3' = Vector3(p2.v3()) // upsize (z=0)
  let p2x = Vector2(p3.v2()) // downsize (z chomped)

"""
  fun v2() : V2
  fun v3() : V3
  fun v4() : V4
  fun x()  : F32 ?
  fun y() : F32 ?
  fun z() : F32 ?
  fun w() : F32 ?

  fun vecfun() : VectorFun[V val] val
  fun as_tuple() : V
  fun as_array() : Array[F32] val
  fun add(that: (Vector[V] box | V)) : V => 
    let mine : V = as_tuple()
    match that
    | let v: Vector[V] box => vecfun().add(mine, v.as_tuple())
    | let v: V =>      vecfun().add(mine, v)
    end
  fun sub(that: (Vector[V] box | V)) : V => 
    let mine : V = as_tuple()
    match that
    | let v: Vector[V] box => vecfun().sub(mine, v.as_tuple())
    | let v: V =>      vecfun().sub(mine, v)
    end

  fun ref update(value: (Vector[V] | V))

  fun eq(that: (box->Vector[V]|V)) : Bool  => 
    let mine : V = as_tuple()
    match that
    | let v : Vector[V] box  => vecfun().eq(mine, v.as_tuple(), F32.epsilon())
    | let v : V =>
      vecfun().eq(mine, v, F32.epsilon())
    end

  fun ne(that: (box->Vector[V]|V)) : Bool => not eq(that)

class Vector2 is Vector[V2]
  var _x : F32
  var _y : F32

  new create(v' : AnyVector2) => 
    (_x, _y) = match v'
    | let v : Vector[V2] box => v.as_tuple()
    | let v : V2 => v
    end

  fun x() : F32 => _x
  fun y() : F32 => _y
  fun z() : F32 ? => error
  fun w() : F32 ? => error
  fun as_array() : Array[F32] val => [_x; _y]
  fun vecfun() : VectorFun[V2 val] val => V2fun
  fun as_tuple() : V2 => (_x, _y)

  fun v2() : V2 => (_x, _y)
  fun v3() : V3 => (_x, _y, 0)
  fun v4() : V4 => (_x, _y, 0, 0)

  fun ref update(value: AnyVector2)  => 
    (_x, _y) = match value
    | let v : Vector[V2] box => v.as_tuple()
    | let v : V2 => v
    end

  fun box string() : String iso^ => Linear.to_string(as_tuple())


class Vector3 is Vector[V3]
  var _x : F32
  var _y : F32
  var _z : F32

  new create(v' : AnyVector3) => 
    (_x, _y, _z) = match v'
    | let v : Vector[V3] box => v.as_tuple()
    | let v : V3 => v
    end

  fun x() : F32 => _x
  fun y() : F32 => _y
  fun z() : F32 => _z
  fun w() : F32 ? => error
  fun as_array() : Array[F32] val => [_x; _y; _z]

  fun vecfun() : VectorFun[V3 val] val => V3fun
  fun as_tuple() : V3 => (_x, _y, _z)

  fun v2() : V2 => (_x, _y)
  fun v3() : V3 => (_x, _y, _z)
  fun v4() : V4 => (_x, _y, _z, 0)

  fun ref update(value: AnyVector3)  => 
    (_x, _y, _z) = match value
    | let v : Vector[V3] box => v.as_tuple()
    | let v : V3 => v
    end

  fun box string() : String iso^ => Linear.to_string(as_tuple())

class Vector4 is Vector[V4]
  var _x : F32
  var _y : F32
  var _z : F32
  var _w : F32

  new create(v' : AnyVector4) => 
    (_x, _y, _z, _w) = match v'
    | let v : Vector[V4] box => v.as_tuple()
    | let v : V4 => v
    end

  fun x() : F32 => _x
  fun y() : F32 => _y
  fun z() : F32 => _z
  fun w() : F32 => _w
  fun as_array() : Array[F32] val => [_x; _y; _z; _w]

  fun vecfun() : VectorFun[V4 val] val => V4fun
  fun as_tuple() : V4 => (_x, _y, _z, _w)

  fun v2() : V2 => (_x, _y)
  fun v3() : V3 => (_x, _y, _z)
  fun v4() : V4 => (_x, _y, _z, _w)

  fun ref update(value: AnyVector4)  => 
    (_x, _y, _z, _w) = match value
    | let v : Vector[V4] box => v.as_tuple()
    | let v : V4 => v
    end

  fun string() : String iso^ => Linear.to_string(as_tuple())
