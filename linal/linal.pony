"""
# Linear Algebra library for Pony Language

### Tuple-based Linear Algebra for typical 2D, 3D operations  
  * operate on the stack
  * 100% immutable
  * side-effect free functions
  * float32 internals (F32)
  * 🐎 pure pony
  * efficient wrapper classes available for convenience

Each TYPE consists of a type alias, a primitive, and a wrapper class
 * A type alias to a tuple (similar to class state data)
 * A primitive function collection (similar to methods)
 * the first argument is similar to "this" except it is immutable
 * rather than modify state, result is returned as immutable stack tuple
 * optional wrapper class
 * wrapper class methods only produce tuples to prevent unwanted instantiation
 * wrapper classes accept both tuples and instances for convenience

Example for Vector 2
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

## Types

### Vectors

 * V2 - (x: F32, y: F32)
 * V2fun - functions for V2
 * Vector2 - wrapper class for V2
 * V3 - (x: F32, y: F32, z: F32)
 * V3fun - functions for V3
 * Vector3 - wrapper class for V3
 * V4 - (x: F32, y: F32, z: F32, w: F32)
 * V4fun - functions for V4
 * Vector4 - wrapper class for V4

### Matrices

 * M2 - (x: V2, y: V2)
 * M2fun - functions for M2
 * Matrix2 - wrapper class for M2
 * M3 - (x: V3, y: V3, z: V3)
 * M3fun - functions for M3
 * Matrix3 - wrapper class for M3
 * M4 - (x: V4, y: V4, z: V4, w: V4)
 * M4fun - functions for M4
 * Matrix4 - wrapper class for M4

### Quaternion

 * Q4 - (x: F32, y: F32, z: F32, w: F32)
 * Q4fun - functions for Q4
 * Quaternion - wrapper class for Q4

### Utility

 * Linear - various linal utility functions
 * Intersect - hit test functions

### Others

 * R4 - (position: V2, width: F32, height: F32)
 * R4fun - functions for R4
 * Rect - wrapper class for R4
 * R2 - (position: V3, direction: V3)
 * R2fun - functions for R2
 * Ray - wrapper class for R2
 * P4 - (normal: V3, distance: F32)
 * P4fun - functions for P4
 * Plane - wrapper class for P4


"""