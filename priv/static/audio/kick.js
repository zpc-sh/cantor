// Simple kick drum synthesis using Web Audio API
// No external samples needed - pure synthesis

export function createKick(audioContext, frequency = 60) {
  const now = audioContext.currentTime;
  
  // Create oscillator for kick thump
  const osc = audioContext.createOscillator();
  const gain = audioContext.createGain();
  const filter = audioContext.createBiquadFilter();
  
  // Kick frequency (default 60Hz from our fingerprints)
  osc.frequency.setValueAtTime(frequency, now);
  osc.frequency.exponentialRampToValueAtTime(1, now + 0.1);
  
  // Low-pass filter for thump
  filter.type = 'lowpass';
  filter.frequency.setValueAtTime(200, now);
  
  // Quick punch envelope
  gain.gain.setValueAtTime(1, now);
  gain.gain.exponentialRampToValueAtTime(0.001, now + 0.3);
  
  // Connect: oscillator -> filter -> gain -> output
  osc.connect(filter);
  filter.connect(gain);
  gain.connect(audioContext.destination);
  
  // Play the kick
  osc.start(now);
  osc.stop(now + 0.3);
  
  return { duration: 0.3 };
}