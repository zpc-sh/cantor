// Simple hihat synthesis using Web Audio API

export function createHihat(audioContext, frequency = 8000) {
  const now = audioContext.currentTime;
  
  // Create multiple oscillators for metallic sound
  const oscs = [];
  const gains = [];
  const masterGain = audioContext.createGain();
  
  // Hihat frequencies (harmonically rich)
  const frequencies = [frequency, frequency * 1.4, frequency * 1.8, frequency * 2.3];
  
  frequencies.forEach((freq, i) => {
    const osc = audioContext.createOscillator();
    const gain = audioContext.createGain();
    
    osc.type = 'square'; // Harsh for metallic sound
    osc.frequency.setValueAtTime(freq, now);
    
    // Different levels for each oscillator
    gain.gain.setValueAtTime(0.2 / (i + 1), now);
    
    osc.connect(gain);
    gain.connect(masterGain);
    
    oscs.push(osc);
    gains.push(gain);
  });
  
  // High-pass filter for crisp sound
  const filter = audioContext.createBiquadFilter();
  filter.type = 'highpass';
  filter.frequency.setValueAtTime(6000, now);
  
  // Very quick envelope for hihat
  masterGain.gain.setValueAtTime(0.3, now);
  masterGain.gain.exponentialRampToValueAtTime(0.001, now + 0.05);
  
  // Connect to output
  masterGain.connect(filter);
  filter.connect(audioContext.destination);
  
  // Start all oscillators
  oscs.forEach(osc => {
    osc.start(now);
    osc.stop(now + 0.05);
  });
  
  return { duration: 0.05 };
}