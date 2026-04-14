pub fn crop(frame : @core.VideoFrame, x : Int, y : Int, w : Int, h : Int) -> @core.VideoFrame {
  let _ = x
  let _ = y
  { width: w, height: h, data: frame.data }
}
