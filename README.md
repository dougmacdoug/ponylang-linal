# linal - Linear Algebra library for Pony Language

### Tuple-based Linear Algebra for typical 2D, 3D operations  

  * operate on the stack
  * 100% immutable
  * side-effect free functions
  * float32 internals (F32)
  * 🐎 pure pony
  * efficient wrapper classes available for convenience

## Status

[![CircleCI](https://circleci.com/gh/dougmacdoug/ponylang-linal.svg?style=svg)](https://circleci.com/gh/dougmacdoug/ponylang-linal)

* v0.2.1  - 2020-02-28
* v0.2.0  - 2018-03-03
* v0.1.0  - 2018-02-19

### Applicability

This library is intended for use in common 2D and 3D applications
not as a scientific or precise mathematics library. Various scientific libraries
such as [LAPACK](https://github.com/Reference-LAPACK/lapack), [GSL](https://www.gnu.org/software/gsl/) or others can be bound with the [Pony C ABI](https://tutorial.ponylang.org/c-ffi/).

## Installation

* Install [pony-stable](https://github.com/ponylang/pony-stable)
* Update your `bundle.json`

```json
{ 
  "type": "github",
  "repo": "dougmacdoug/ponylang-linal"
}
```

* `stable fetch` to fetch your dependencies
* `use "linal"` to include this package
* `stable env ponyc` to compile your application

### Type System

Each TYPE consists of a type alias, a primitive, and a wrapper class
 * A type alias to a tuple (similar to class state data)
 * A primitive function collection (similar to methods)
 * the first argument is similar to "this" except it is immutable
 * rather than modify state, result is returned as immutable stack tuple
 * optional wrapper class
 * wrapper class methods only produce tuples to prevent unwanted instantiation
 * wrapper classes accept both tuples and instances for convenience

#### Example for Vector 2

 * `V2` => Type Alias for tuple `(F32, F32)`
 * `V2fun` => primitive function collection that acts on and returns `V2` tuples
 * `Vector2` => wrapper class for convenience, embedding, and persistent handle

```
  let a = (F32(1), F32(1)) // simple tuple compatible with V2

  let b: V2 = (3, 3)       // declared type alias forces 3's to F32
  let c = V2fun(3, 3)      // apply sugar => V2
  let d = V2fun.add(a, b)  // a + b
  let f = V2fun.mul(V2fun.unit(d), 5) // normalize d and scale to 5 units

  let v2 = Linear.vector2()   // readable function alias to V2fun
  let p1 = v2(1, 2)           // alias + apply sugar
  let p2 = v2.add(p1, (1, 1)) // p2 = p1 + (1, 1)

  let vec = Vector2 // wrapper class
  vec() = vec + p1  // vec = vec + p1 via add sugar, update sugar
  vec() = vec * 5   // vec = vec * 5 via mul sugar, update sugar
  vec(p2)           // vec = p2 via apply sugar

  // wrapper classes accept other wrapper instances or tuples
  let other1 = Vector2(vec)
  let other2 = Vector2(p1)
  // functions with results do not generate GC'd classes, only tuples
  let result: V2 = other1 + other2
  // update sugar looks closer to traditional linear classes
  other1() = other1 + other2
```

### Types

| Type | Func    | Wrapper      | Tuple                                   |
| ---- | ------- | ------------ | --------------------------------------- |
| `V2` | `V2fun` | `Vector2`    | `(x: F32, y: F32)`                      |
| `V3` | `V3fun` | `Vector3`    | `(x: F32, y: F32, z: F32)`              |
| `V4` | `V4fun` | `Vector4`    | `(x: F32, y: F32, z: F32, w: F32)`      |
|      |         |              |                                         |
| `M2` | `M2fun` | `Matrix2`    | `(x: V2, y: V2)`                        |
| `M3` | `M3fun` | `Matrix3`    | `(x: V3, y: V3, z: V3)`                 |
| `M4` | `M4fun` | `Matrix4`    | `(x: V4, y: V4, z: V4, w: V4)`          |
|      |         |              |                                         |
| `Q4` | `Q4fun` | `Quaternion` | `(x: V4, y: V4, z: V4, w: V4)`          |
|      |         |              |                                         |
| `R4` | `R4fun` | `Rect`       | `(origin: V2, width: F32, height: F32)` |
| `R2` | `R2fun` | `Ray`        | `(position: V3, direction: V3)`         |
| `P4` | `P4fun` | `Plane`      | `(normal: V3, distance: F32)`           |

### Utility

 * `Linear` - various linal utility functions
 * `Intersect` - hit test functions

#### @TODO // MAYBEDO

  * docstring references
  * unit test coverage
  * examples
  * slerp nlerp
  * faster Q4
  * add fast sqrt for length operations
  * consider writing longhand (dist2 = distance_squared)
  * try to use compile time expressions once adopted by pony
     `fun inv(q: Q4): Q4 => #(div(conj(q), dot(q, q)))`

