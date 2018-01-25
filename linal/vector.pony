type V2 is (F32, F32)
""" tuple based Vector 2 alias - see VectorFun for functions"""
type V3 is (F32, F32, F32)
""" tuple based Vector 3 alias - see VectorFun for functions"""
type V4 is (F32, F32, F32, F32)
""" tuple based Vector 4 alias - see VectorFun for functions"""
type FixVector  is (V2 | V3 | V4)
""" tuple based Vector alias - see VectorFun for functions"""
// @TODO: consider removing.. not particularly useful
type OptVector is (FixVector | None)
""" tuple based Vector or None alias"""

// @Hack VectorX is Vector[VX] but compiler requires both in the alias
type AnyVector2 is (Vector2 | Vector[V2, V2fun] | V2) 
"""instance | tuple vector 2 alias - see Vector and VectorFun"""
type AnyVector3 is (Vector3 | Vector[V3, V3fun] | V3)
"""instance | tuple vector 3 alias - see Vector and VectorFun"""
type AnyVector4 is (Vector4 | Vector[V4, V4fun] | V4)
"""instance | tuple vector 4 alias - see Vector and VectorFun"""

// cannot use tuple as constraint
// trait primarily used for code validation
trait VectorFun[V /*: Vector */]
  new val create() 
"""Trait defining tuple based vector functions"""
  fun zero() : V
    """all zeroes vector"""
  fun id() : V
    """all ones vector"""
  fun add(a: V, b: V) : V
    """add a and b"""
  fun sub(a: V, b: V) : V
    """subtract b from a"""
  fun neg(v: V) : V
    """negate vector"""
  fun mul(v: V, s: F32) : V
    """scalar multiply (scale) vector"""
  fun div(v: V, s: F32)  : V
    """scalar divide (1/scale) vector"""
  fun dot(a: V, b: V) : F32
    """dot product of a and b"""    
  fun len2(v: V) : F32
    """length of vector squared"""
  fun len(v: V) : F32
    """length of vector"""
  fun dist2(a : V, b : V) : F32
    """distance between a and b squared"""
  fun dist(a : V, b : V) : F32
    """distance between a and b"""
  fun unit(v : V) : V
    """normalized unit vector"""
  fun eq(a: V, b: V, eps: F32) : Bool
    """test equality between a and b  +/-(~epsilon)"""
  fun lerp(a: V, b: V, t: F32) : V
    """lerp t% (0-1) from a to b"""

  fun v2(v: V) : V2
    """return a vector 2 from v"""
  fun v3(v: V) : V3
    """return a vector 3 from v - fill with zeroes if necessary"""
  fun v4(v: V) : V4
    """return a vector 4 from v - fill with zeroes if necessary"""

primitive V2fun is VectorFun[V2 val]
  """tuple based Vector 2 functions - see VectorFun for details"""
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
  """tuple based Vector 3 functions - see VectorFun for details"""
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
  """tuple based Vector 4 functions - see VectorFun for details"""
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

trait Vector[V : Any #read, Vfun: VectorFun[V] val] is (Stringable & Equatable[Vector[V, Vfun]])
"""
trait for class wrappers for tuple types

 * mainly used for sugar
 * minimize GC'd classes by returning Tuple-based objects for all operations
 * update() allows reuse of instance

** Note: V is actually one of the tuple types from FixVector 
 but pony doesn't support tuples as subtypes so we use
 Any here **


### Example:

```
  let p2 = Vector2((5, 3))     // construct from tuple
  let p2' = Vector2(p2)        // construct from instance
  let p3 = Vector3((5, 3, 1))  // construct from tuple
  let p3' = Vector3(p2.v3())   // upsize (z=0)
  let p2x = Vector2(p3.v2())   // downsize (z chomped)

// for sugar, left must be instance but right can be tuple or instance
  var pt = Vector2((1, 1))
  let tuple_v2 : V2 = pt + pt // return type is tuple
  pt() = pt + ((2, 3))        // update() accepts tuples     
  let pt' : V2 = (1, 2)   
  pt() = pt - pt'             
```

"""
  new zero()
  new id()
  fun v2() : V2
    """return V2 tuple"""
  fun v3() : V3
    """return V3 tuple - fill with zeroes if necessary"""
  fun v4() : V4
    """return V4 tuple - fill with zeroes if necessary"""
  fun x()  : F32 ?
    """return x coord"""
  fun y() : F32 ?
    """return y coord"""
  fun z() : F32 ?
    """return z coord if available"""
  fun w() : F32 ?
    """return w coord if available"""

  // fun Vfun : VectorFun[V val] val =>  Vfun
  //   """handle to the appropriate Primitive VectorFun for this vector"""

  fun as_tuple() : V
    """return this vector as a tuple"""
  fun as_array() : Array[F32] val
    """return this vector as an Array"""

  fun add(that: (Vector[V, Vfun] box | V)) : V => 
    """add this vector with another instance|tuple => tuple"""
    let mine : V = as_tuple()
    let that' : V = _tuplize(that)
    Vfun.add(mine, that')

  fun sub(that: (Vector[V, Vfun] box | V)) : V => 
    """subtract another instance|tuple from this vector => tuple"""
    let mine : V = as_tuple()
    let that' : V = _tuplize(that)
    Vfun.sub(mine, that')

  fun mul(scale': F32) : V => 
    """subtract another instance|tuple from this vector => tuple"""
    let mine : V = as_tuple()
    Vfun.mul(mine, scale')

  fun div(scale': F32) : V => 
    """scalar div (1/scale) this vector => tuple"""
    let mine : V = as_tuple()
    Vfun.div(mine, scale')

  fun neg() : V => 
    """negate this vector => tuple"""
    let mine : V = as_tuple()
    Vfun.neg(mine)

  fun dot(that: (Vector[V, Vfun] box | V)) : F32 => 
    """dot product of this and that"""    
    let mine  : V = as_tuple()
    let that' : V = _tuplize(that)
    Vfun.dot(mine, that')

  fun len2() : F32 =>
    """length of vector squared"""
    let mine  : V = as_tuple()
    Vfun.len2(mine)

  fun len() : F32 =>
    """length of vector"""
    let mine  : V = as_tuple()
    Vfun.len(mine)

  fun dist2(that: (Vector[V, Vfun] box | V)) : F32 =>
    """distance between this and that squared"""
    let mine  : V = as_tuple()
    let that' : V = _tuplize(that)
    Vfun.dist2(mine, that')

  fun dist(that: (Vector[V, Vfun] box | V)) : F32 =>
    """distance between this and that"""
    let mine  : V = as_tuple()
    let that' : V = _tuplize(that)
    Vfun.dist(mine, that')

  fun unit() : V =>
    """normalized unit vector"""
    let mine  : V = as_tuple()
    Vfun.unit(mine)

  fun lerp(that: (Vector[V, Vfun] box | V), t: F32) : V =>
    """lerp t% (0-1) from this to that"""
    let mine  : V = as_tuple()
    let that' : V = _tuplize(that)
    Vfun.lerp(mine, that', t)

  fun ref update(value: (box->Vector[V, Vfun]| V)) =>
    """set this vector value to instance|tuple"""

  fun eq(that: (Vector[V, Vfun] box|V)) : Bool  => 
    """test equality with this vector and another instance|tuple"""
    let mine : V = as_tuple()
    match that
    | let v : Vector[V, Vfun] box  => Vfun.eq(mine, v.as_tuple(), F32.epsilon())
    | let v : V =>
      Vfun.eq(mine, v, F32.epsilon())
    end

  fun ne(that: (Vector[V, Vfun] box|V)) : Bool => not eq(that)

  fun _tuplize(that: (Vector[V, Vfun] box | V)) : V =>
    match that
    | let v: V => v
    | let v: Vector[V, Vfun] box => v.as_tuple()
    end


class Vector2 is Vector[V2, V2fun]
  """class wrapper for V2 - see Vector for details"""
  var _x : F32 
  var _y : F32

  new create(v' : box->AnyVector2) => 
    (_x, _y) = match v'
    | let v : Vector[V2, V2fun] box => v.as_tuple()
    | let v : V2 => (v._1, v._2)
    end

  new zero() => (_x, _y) = (0,0)
  new id() => (_x, _y) = (1,1)
  fun x() : F32 => _x
  fun y() : F32 => _y
  fun z() : F32 ? => error
  fun w() : F32 ? => error
  fun as_array() : Array[F32] val => [_x; _y]
  fun as_tuple() : V2 => (_x, _y)

  fun v2() : V2 => (_x, _y)
  fun v3() : V3 => (_x, _y, 0)
  fun v4() : V4 => (_x, _y, 0, 0)

  fun ref update(value: box->AnyVector2)  => 
    (_x, _y) = match value
    | let v : Vector[V2, V2fun] box => v.as_tuple()
    | let v : V2 => v
    end

  fun box string() : String iso^ => Linear.to_string(as_tuple())


class Vector3 is Vector[V3, V3fun]
  """class wrapper for V3 - see Vector for details"""
  var _x : F32
  var _y : F32
  var _z : F32

  new create(v' : box->AnyVector3) => 
    (_x, _y, _z) = match v'
    | let v : Vector[V3, V3fun] box => v.as_tuple()
    | let v : V3 => v
    end
  new zero() => (_x, _y, _z) = (0,0,0)
  new id() => (_x, _y, _z) = (1,1,1)

  fun x() : F32 => _x
  fun y() : F32 => _y
  fun z() : F32 => _z
  fun w() : F32 ? => error
  fun as_array() : Array[F32] val => [_x; _y; _z]

  fun as_tuple() : V3 => (_x, _y, _z)

  fun v2() : V2 => (_x, _y)
  fun v3() : V3 => (_x, _y, _z)
  fun v4() : V4 => (_x, _y, _z, 0)

  fun ref update(value: box->AnyVector3)  => 
    (_x, _y, _z) = match value
    | let v : Vector[V3, V3fun] box => v.as_tuple()
    | let v : V3 => v
    end

  fun box string() : String iso^ => Linear.to_string(as_tuple())

class Vector4 is Vector[V4, V4fun]
  """class wrapper for V4 - see Vector for details"""
  var _x : F32
  var _y : F32
  var _z : F32
  var _w : F32

  new create(v' : box->AnyVector4) => 
    (_x, _y, _z, _w) = match v'
    | let v : Vector[V4, V4fun] box => v.as_tuple()
    | let v : V4 => v
    end
  new zero() => (_x, _y, _z, _w) = (0,0,0,0)
  new id() => (_x, _y, _z, _w) = (1,1,1,1)

  fun x() : F32 => _x
  fun y() : F32 => _y
  fun z() : F32 => _z
  fun w() : F32 => _w
  fun as_array() : Array[F32] val => [_x; _y; _z; _w]

  // fun Vfun : VectorFun[V4 val] val => V4fun
  fun as_tuple() : V4 => (_x, _y, _z, _w)

  fun v2() : V2 => (_x, _y)
  fun v3() : V3 => (_x, _y, _z)
  fun v4() : V4 => (_x, _y, _z, _w)

  fun ref update(value: box->AnyVector4)  => 
    (_x, _y, _z, _w) = match value
    | let v : Vector[V4, V4fun] box => v.as_tuple()
    | let v : V4 => v
    end

  fun string() : String iso^ => Linear.to_string(as_tuple())
