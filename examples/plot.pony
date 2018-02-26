use "../linal"

class Plot
  let _out: OutStream
  let v2: V2fun = V2fun
  let v3: V3fun = V3fun
  let rect: R4fun = R4fun

  let x_axis: String = " 9|8|7|6|5|4|3|2|1|0|1|2|3|4|5|6|7|8|9 "
  new create(env: Env) =>
    _out = env.out

  fun graph_pt(p': (V2 | V3))=>
    match p'
    | let p: V2 => _graph2(p)
    | let p: V3 => _graph3(p)
    end

  fun _graph3(p': V3)=>
    let norm = v3.unit(p')
    let p = v3.mul(norm, 9) // scaled
    let xy: V2 = (v3.x(p), v3.y(p))
    let xz: V2 = (v3.x(p), v3.z(p))
    let factor = v3.len(p) / v3.len(p')
    _out.print("Original: " + v3.to_string(p'))
    _out.print("Scale Factor: " + factor.string())
    _out.print("Plotted XY|XZ: " +  v3.to_string(p))

    _out.print(x_axis + x_axis)
    let len1 = v2.len(xy)
    let len2 = v2.len(xz)
    var r: I32 = 9
    while r > -10 do
      let s1 = _make_row(xy, len1, r)
      let s2 = _make_row(xz, len2, r)
      _out.print(s1 + s2 + r.abs().string())
      r = r - 1
    end
     _out.print(x_axis + x_axis)

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

  fun _graph2(p: V2)=>
    _out.print(x_axis)
    let len = v2.len(p)
    var r: I32 = 9
    while r > -10 do
      let s = _make_row(p, len, r)
      _out.print(s + r.abs().string())
      r = r - 1
    end
     _out.print(x_axis)
    
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

  fun graph_rect(rc: R4, pts: Array[V2] val)=>
    _out.print(x_axis)
    var r: I32 = 9
    while r > -10 do
      let s = String(40)
      s.append(r.abs().string())
      var c: I32 = -9
      while c < 10 do
        var u: U8 = ' '
        for pt in pts.values() do
          u = _get_plot_pt(pt, v2.len(pt), c, r)
          if u == '*' then
            u = if rect.contains(rc, pt) then 'O' else 'X' end          
            break
          end
        end
        if (u != 'O') and (u != 'X') then
          let x1 = rect.x_min(rc).round().i32()
          let x2 = rect.x_max(rc).round().i32()
          let y1 = rect.y_min(rc).round().i32()
          let y2 = rect.y_max(rc).round().i32()
          if ((x1 == c) or (x2 == c)) and 
            (r >= y1) and (r <= y2) then
              u = '#'
          elseif ((y1 == r) or (y2 == r)) and 
            (c >= x1) and (c <= x2) then
              u = '#'
          else
            u = _get_plot_pt((0,0), 1, c, r)
          end
        end

        s.push(u)
        s.push('|')
        c = c + 1
      end      
      s.string()
      _out.print(s + r.abs().string())
      r = r - 1
    end
     _out.print(x_axis)