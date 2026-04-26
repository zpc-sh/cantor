test "stack empty array" {
  let streams : Array[@core.Stream] = []
  let result = stack(streams)
  if result.id != "stack_" {
    fail("Expected id 'stack_', got '\{result.id}'")
  }
  if result.media_type != @core.MediaType::Muxed {
    fail("Expected media_type Muxed")
  }
}

test "stack multiple streams" {
  let s1 : @core.Stream = { id: "s1", media_type: @core.MediaType::Audio }
  let s2 : @core.Stream = { id: "s2", media_type: @core.MediaType::Video }
  let streams = [s1, s2]
  let result = stack(streams)
  if result.id != "stack_s1s2" {
    fail("Expected id 'stack_s1s2', got '\{result.id}'")
  }
  if result.media_type != @core.MediaType::Muxed {
    fail("Expected media_type Muxed")
  }
}
