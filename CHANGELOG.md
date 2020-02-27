Change Log
==========

### [0.2.1] - 2020-02-27
 * fixed error in M4fun.mul_m4 
   - added unit test for mul_m4

### [0.2.0] - 2018-03-03
 * fixed failing Vector trait on ponyc-latest
 * added P4, P4fun, Plane 
 * added R2, R2fun, Ray
 * added Intersect primitive
 * added starter examples project.. needs work
 * added reader friendly alias methods to Linear ex: Linear.vector2()

 * improved documentation
 * change all methods named tuple_action to action_tuple. ex: v2_mul, q4_mul => mul_v2, mul_q4
 * change Matrix2-4 members to embedded Vector2-4
 * changed matrix inverse/solve to return None instead of raise error

### [0.1.0] - 2018-02-18

 * Initial release
