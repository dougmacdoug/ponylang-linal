use "../linal"
use "term"
class  KeyboardHandler is ANSINotify
 let _m: Main tag 
   new iso create(m : Main tag) => _m = m

   fun ref apply(term: ANSITerm ref, input: U8 val) =>
     if input == 113 then // q key
       _m.quit()
       term.dispose()
     end
   // fun ref left(ctrl: Bool, alt: Bool, shift: Bool)  => _game.move(LEFT)
   // fun ref down(ctrl: Bool, alt: Bool, shift: Bool)  => _game.move(DOWN)
   // fun ref up(ctrl: Bool, alt: Bool, shift: Bool)    => _game.move(UP)
   // fun ref right(ctrl: Bool, alt: Bool, shift: Bool) => _game.move(RIGHT)

actor Main
  let _env: Env
  let v2: V2fun = V2fun
  let v3: V3fun = V3fun
  let x_axis: String = " 9|8|7|6|5|4|3|2|1|0|1|2|3|4|5|6|7|8|9 "
  new create(env: Env) =>
    _env = env
    let p1 = v2(0.13, -0.7579)
    _print(v2.mul(v2.unit(p1),9))
    let p2 = v2(-0.99, 0.77)
    _print(v2.mul(v2.unit(p2),9))
    let p3 = v3(1.99, -1.17, 0.75)
    _print(p3)
    _print(v3(0,0,0))
    let input : Stdin tag = env.input
    let term = ANSITerm(KeyboardHandler(this), _env.input)
    let notify : StdinNotify iso = object iso
        fun ref apply(data: Array[U8] iso) => term(consume data)
        fun ref dispose() => env.input.dispose()
    end
    env.input(consume notify)

  be quit()=>
    _env.out.print("Exiting.. some terminals may require <ctrl-c>")
    _env.exitcode(0)
    _env.input.dispose()

  fun _print(p': (V2 | V3))=>
    match p'
    | let p: V2 => _print2(p)
    | let p: V3 => _print3(p)
    end
  fun _print3(p': V3)=>
    let norm = v3.unit(p')
    let p = v3.mul(norm, 9) // scaled
    let xy: V2 = (v3.x(p), v3.y(p))
    let xz: V2 = (v3.x(p), v3.z(p))
    let factor = v3.len(p) / v3.len(p')
    _env.out.print("Original: " + v3.to_string(p'))
    _env.out.print("Scale Factor: " + factor.string())
    _env.out.print("Plotted XY|XZ: " +  v3.to_string(p))

    _env.out.print(x_axis + x_axis)
    let len1 = v2.len(xy)
    let len2 = v2.len(xz)
    var r: I32 = 9
    while r > -10 do
      let s1 = _make_row(xy, len1, r)
      let s2 = _make_row(xz, len2, r)
      _env.out.print(s1 + s2 + r.abs().string())
      r = r - 1
    end
     _env.out.print(x_axis + x_axis)

  fun _make_row(p: V2, len: F32, r: I32): String=>
    let s = String(40)
    s.append(r.abs().string())
    var c: I32 = -9
    while c < 10 do
      let u = _get_plot_pt(p, len, c, r)
      s.push(u)
      s.push('|')
      c = c + 1
    end      
    s.string()

  fun _print2(p: V2)=>
    _env.out.print(x_axis)
    let len = v2.len(p)
    var r: I32 = 9
    while r > -10 do
      let s = _make_row(p, len, r)
      _env.out.print(s + r.abs().string())
      r = r - 1
    end
     _env.out.print(x_axis)
    
  fun _get_plot_pt(p: V2, len: F32, x: I32, y: I32): U8 =>
    let u: U8 = 
    if (p._1.round().i32() == x) and (p._2.round().i32() == y) then
      '*'
    elseif (x == 0) and (y==0) then
      'o'
    else
      let curr = v2(x.f32(), y.f32())
      let curr_len = v2.len(curr)
      if curr_len <= len then 
        let t = v2.mul(p, curr_len/len)
        let d = v2.dist(curr, t)
        if d <= 0.5 then '.'
        else ' ' end
      else ' ' end
    end

    match (u, x, y)
    | (' ', 0, _) => if (y < 0) then '-' else '+' end
    | (' ', _, 0) => if (x < 0) then '-' else '+' end
    else u end 
     
