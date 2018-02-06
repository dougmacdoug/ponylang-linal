# Linear Algebra library for Pony Language

This library is intended for use in common 2D and 3D applications
not as a scientific or math library. Various scientific libraries
such as [LAPACK], [GSL] or even [NumPy] can be bound with the [Pony C ABI].

### pre-alpha software (0.1.0 version coming mid Feb'18)

### Tuple-based Linear Algebra for typical 2D, 3D operations  
  * operate on the stack
  * 100% immutable
  * float32 internals (F32)
  * 🐎 pure pony


Each TYPE consists of a type alias and a primitive behaving similar to a "class"
 - A type alias to a tuple (similar to class state data)
 - A primitive function collection (similar to methods)
 - the first argument is similar to "this" except it is immutable
 - rather than modify state, result is returned as immutable stack tuple

Example:

```
  let a = (F32(1),F32(1)) // simple tuple compatible with V2
  let b : V2 = (3,3) // declared type alias forces 3's to F32
  let c = V2fun(3,3) // apply sugar => V2
  let d = V2fun.add(a, b) // a + b
  let f = V2fun.mul(V2fun.unit(d), 5) // scale to 5 units
```


@TODO:
  * another sweep of m4, q4, r4
  * unit tests q4, r4, and wrapper classes
  * Rect does not follow wrapper pattern.. (align or write doc)
  * follow lib pattern for pony, add to pony stable
  * release 0.1.0
@FUTURE
  * create good example folder
  * plan for more classes like Plane /or/ move Rect to new lib
  * consider writing longhand (dist2 = distance_squared)
  * add fast sqrt for unit vector
  * slerp nlerp
  * faster Q4
  * try to use compile time expressions once adopted by pony
     fun inv(q: Q4) : Q4 => #( div(conj(q), dot(q,q)) )

