"""
these examples are not particularly good
 at showing how to use the library

 @TODO make simpler examples to show typical linal usage
 rather than attempting to print 3d graphs in console ascii
"""

use "../linal"

actor Main
  let usage: String =
"""
Usage: examples <command> [options]

 where commands are
 - rect x y width height [points...]
   * points are 1.2,3.4 5.6,7.8
 - rotate degs [point]
   * degs (+/-) 5 to 180 
"""
  let _plot: Plot

  new create(env: Env) =>
    _plot = Plot(env)

    try
      match  env.args(1)?
      | "rect"=> _rect(env.args)?
      | "rotate"=>_rotate(env.args)?
      else error
      end
    else
      _usage(env)
    end

  fun _usage(env: Env) =>
      env.out.print(usage)
      env.exitcode(1)

  fun _rotate(args: Array[String val] val) ? =>
    let deg: F32 = args(2)?.i32()?.f32()
    let deg_pos = deg.abs()
    if (deg_pos < 5) or (deg_pos > 180) then
      error
    end

    var v2: V2 = if args.size() > 3 then
      _v2(args(3)?)? 
    else
      (1, 0)
    end
    v2 = V2fun.unit(v2)
    v2 = V2fun.mul(v2, 8)
    let rot = Q4fun.axis_angle((0,0,1), deg * Linear.deg_to_rad())
    var d: F32 = 0
    while d <= 360 do
      _plot.graph_pt(v2)
      let v3 = Q4fun.v3_rot(rot, V2fun.v3(v2))
      v2 = V3fun.v2(v3)
      d = d + deg_pos
    end

  fun _rect(args: Array[String val] val) ? =>
    let x: F32 = args(2)?.f32()
    let y: F32 = args(3)?.f32()
    let w: F32 = args(4)?.f32()
    let h: F32 = args(5)?.f32()
    let pts: Array[V2] val = recover
      var i: USize = 6
      let a: Array[V2] ref = Array[V2](args.size() - i)
      while i < args.size() do
        let pt = _v2(args(i)?)?
        a.push(pt)
        i = i + 1
      end
      a
    end
    let r = R4fun(x, y, w, h)
    _plot.graph_rect(r, pts)

  fun _v2(s: String): V2 ? =>
    let arr = s.split_by(",")
    if arr.size() != 2 then
      error
    end
    (arr(0)?.f32(), arr(1)?.f32())