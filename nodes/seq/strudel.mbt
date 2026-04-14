// Time manipulation node (strudel primitive "fast")
// Compresses time by factor `rate` so it plays faster.
pub fn fast(rate : Double, source : @core.Stream) -> @core.Stream {
  // In a real audio graph, this translates to scaling phase integration
  let _ = rate
  { id: source.id + "_fast", media_type: source.media_type }
}

// Time expansion node (strudel primitive "slow")
// Expands time by factor `rate` so it plays slower.
pub fn slow(rate : Double, source : @core.Stream) -> @core.Stream {
  let _ = rate
  { id: source.id + "_slow", media_type: source.media_type }
}

// Stacks multiple streams into parallel execution natively
pub fn stack(streams : Array[@core.Stream]) -> @core.Stream {
  let mut id = "stack_"
  for s in streams {
    id = id + s.id
  }
  { id: id, media_type: @core.MediaType::Muxed }
}

// Conditional branching mapping to "every nth cycle"
pub fn every(n : Int, modifier : (@core.Stream) -> @core.Stream, source : @core.Stream) -> @core.Stream {
  let _ = n
  // Apply modifier hypothetically on the Nth cycle loop pointer boundary
  modifier(source)
}
