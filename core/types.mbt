pub(all) enum MediaType {
  Audio
  Video
  Muxed
} derive(Eq, Debug)

pub(all) struct Stream {
  id : String
  media_type : MediaType
}

pub(all) struct AudioBuffer {
  channels : Int
  sample_rate : Int
  data : Array[Double]
}

pub(all) struct VideoFrame {
  width : Int
  height : Int
  // Flat RGBA payload
  data : Array[Byte]
}
