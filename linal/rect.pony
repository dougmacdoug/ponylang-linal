type R4 is (V2, V2)

// Rectangle is TopLeft to BottomRight
primitive R4fun
  fun apply(top_left': V2, bottom_right': V2) : R4 =>(top_left', bottom_right')
  fun contains(r: R4, pt: V2) : Bool =>
    (r._1._1 <= pt._1) and (r._2._1 >= pt._1) and
    (r._1._2 <= pt._2) and (r._2._2 >= pt._2)

  fun top_left(r: R4) : V2 => r._1
  fun top_right(r: R4) : V2 => (r._2._1, r._1._2)
  fun bottom_left(r: R4) : V2 => (r._1._1, r._2._2)
  fun bottom_right(r: R4) : V2 => r._2

  fun left(r: R4) : F32 => r._1._1
  fun top(r: R4) : F32 => r._1._2
  fun right(r: R4) : F32 => r._2._1
  fun bottom(r: R4) : F32 => r._2._2
