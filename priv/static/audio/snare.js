// Simple snare drum synthesis using Web Audio API  

export function createSnare(audioContext, frequency = 200) {
  const now = audioContext.currentTime;
  
  // Create noise source for snare
  const bufferSize = audioContext.sampleRate * 0.2;
  const buffer = audioContext.createBuffer(1, bufferSize, audioContext.sampleRate);
  const output = buffer.getChannelData(0);
  
  // Generate white noise
  for (let i = 0; i < bufferSize; i++) {
    output[i] = Math.random() * 2 - 1;
  }
  
  const noise = audioContext.createBufferSource();
  noise.buffer = buffer;
  
  // Add tonal component
  const osc = audioContext.createOscillator();
  osc.frequency.setValueAtTime(frequency, now);
  osc.frequency.exponentialRampToValueAtTime(100, now + 0.1);
  
  // Filters and gains
  const noiseFilter = audioContext.createBiquadFilter();
  noiseFilter.type = 'highpass';
  noiseFilter.frequency.setValueAtTime(1000, now);
  
  const oscGain = audioContext.createGain();
  const noiseGain = audioContext.createGain();
  const masterGain = audioContext.createGain();
  
  // Snappy envelope
  masterGain.gain.setValueAtTime(0.7, now);
  masterGain.gain.exponentialRampToValueAtTime(0.01, now + 0.15);
  
  oscGain.gain.setValueAtTime(0.3, now);
  noiseGain.gain.setValueAtTime(0.7, now);
  
  // Connect everything
  osc.connect(oscGain);
  noise.connect(noiseFilter);
  noiseFilter.connect(noiseGain);
  
  oscGain.connect(masterGain);
  noiseGain.connect(masterGain);
  masterGain.connect(audioContext.destination);
  
  // Play the snare
  osc.start(now);
  noise.start(now);
  osc.stop(now + 0.15);
  noise.stop(now + 0.15);
  
  return { duration: 0.15 };
}