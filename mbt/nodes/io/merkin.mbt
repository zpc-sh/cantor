pub fn merkin_source(uri : String) -> @core.Stream {
  { id: uri, media_type: @core.MediaType::Muxed }
}
