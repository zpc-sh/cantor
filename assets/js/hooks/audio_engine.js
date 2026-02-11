/**
 * Enhanced Audio Engine for Cantor/Cadence
 *
 * Provides rich synthesis, sampling, and effects for AI music generation.
 * Designed to match Strudel's capabilities while integrating with AMF consciousness parameters.
 */

class AudioEngine {
  constructor() {
    this.audioContext = null;
    this.masterGain = null;
    this.effectsChain = new Map();
    this.sampleBuffers = new Map();
    this.isPlaying = false;
    this.bpm = 120;
    this.currentTime = 0;
  }

  async init() {
    if (!this.audioContext) {
      this.audioContext = new (window.AudioContext || window.webkitAudioContext)();
      this.masterGain = this.audioContext.createGain();
      this.masterGain.gain.value = 0.8;
      this.masterGain.connect(this.audioContext.destination);
    }

    if (this.audioContext.state === 'suspended') {
      await this.audioContext.resume();
    }
  }

  // ============================================================================
  // EFFECTS SYSTEM
  // ============================================================================

  createReverb(options = {}) {
    const {
      duration = 2.0,
      decay = 2.0,
      room = 0.5
    } = options;

    // Create convolution reverb
    const convolver = this.audioContext.createConvolver();
    const rate = this.audioContext.sampleRate;
    const length = rate * duration;
    const impulse = this.audioContext.createBuffer(2, length, rate);
    const impulseL = impulse.getChannelData(0);
    const impulseR = impulse.getChannelData(1);

    // Generate impulse response
    for (let i = 0; i < length; i++) {
      const n = i;
      const env = Math.exp(-n / (rate * decay));
      impulseL[i] = (Math.random() * 2 - 1) * env;
      impulseR[i] = (Math.random() * 2 - 1) * env;
    }

    convolver.buffer = impulse;

    // Wet/dry mix
    const wetGain = this.audioContext.createGain();
    const dryGain = this.audioContext.createGain();
    wetGain.gain.value = room;
    dryGain.gain.value = 1.0 - room;

    return {
      input: this.audioContext.createGain(),
      output: this.audioContext.createGain(),
      connect: function () {
        this.input.connect(dryGain);
        this.input.connect(convolver);
        convolver.connect(wetGain);
        wetGain.connect(this.output);
        dryGain.connect(this.output);
      }
    };
  }

  createDelay(options = {}) {
    const {
      time = 0.5,
      feedback = 0.3,
      mix = 0.5
    } = options;

    const delay = this.audioContext.createDelay(5.0);
    const delayGain = this.audioContext.createGain();
    const feedbackGain = this.audioContext.createGain();
    const wetGain = this.audioContext.createGain();
    const dryGain = this.audioContext.createGain();

    delay.delayTime.value = time;
    feedbackGain.gain.value = feedback;
    wetGain.gain.value = mix;
    dryGain.gain.value = 1.0 - mix;

    return {
      input: this.audioContext.createGain(),
      output: this.audioContext.createGain(),
      connect: function () {
        // Feedback loop
        this.input.connect(delay);
        delay.connect(delayGain);
        delayGain.connect(feedbackGain);
        feedbackGain.connect(delay);

        // Wet/dry mix
        this.input.connect(dryGain);
        delayGain.connect(wetGain);
        wetGain.connect(this.output);
        dryGain.connect(this.output);
      }
    };
  }

  createFilter(options = {}) {
    const {
      type = 'lowpass',
      frequency = 1000,
      q = 1.0
    } = options;

    const filter = this.audioContext.createBiquadFilter();
    filter.type = type;
    filter.frequency.value = frequency;
    filter.Q.value = q;

    return {
      input: filter,
      output: filter,
      filter: filter,
      connect: function () { }
    };
  }

  createCompressor(options = {}) {
    const {
      threshold = -24,
      ratio = 12,
      attack = 0.003,
      release = 0.25,
      knee = 30
    } = options;

    const compressor = this.audioContext.createDynamicsCompressor();
    compressor.threshold.value = threshold;
    compressor.ratio.value = ratio;
    compressor.attack.value = attack;
    compressor.release.value = release;
    compressor.knee.value = knee;

    return {
      input: compressor,
      output: compressor,
      connect: function () { }
    };
  }

  createDistortion(options = {}) {
    const {
      amount = 0.5,
      oversample = '4x'
    } = options;

    const distortion = this.audioContext.createWaveShaper();
    const curve = new Float32Array(256);
    const k = amount * 100;

    for (let i = 0; i < 256; i++) {
      const x = (i - 128) / 128;
      curve[i] = (Math.PI + k) * x / (Math.PI + k * Math.abs(x));
    }

    distortion.curve = curve;
    distortion.oversample = oversample;

    return {
      input: distortion,
      output: distortion,
      connect: function () { }
    };
  }

  // Chain multiple effects
  createEffectsChain(effects) {
    const chain = [];
    for (const effect of effects) {
      const node = this[`create${effect.type}`](effect.options || {});
      node.connect();
      chain.push(node);
    }

    // Connect chain
    for (let i = 0; i < chain.length - 1; i++) {
      chain[i].output.connect(chain[i + 1].input);
    }

    return {
      input: chain[0]?.input || this.audioContext.createGain(),
      output: chain[chain.length - 1]?.output || this.audioContext.createGain(),
      chain: chain
    };
  }

  // ============================================================================
  // SAMPLE LOADING & PLAYBACK
  // ============================================================================

  async loadSample(name, url) {
    try {
      const response = await fetch(url);
      const arrayBuffer = await response.arrayBuffer();
      const audioBuffer = await this.audioContext.decodeAudioData(arrayBuffer);
      this.sampleBuffers.set(name, audioBuffer);
      console.log(`✅ Loaded sample: ${name}`);
      return audioBuffer;
    } catch (error) {
      console.error(`❌ Failed to load sample ${name}:`, error);
      throw error;
    }
  }

  playSample(name, when = null, options = {}) {
    const buffer = this.sampleBuffers.get(name);
    if (!buffer) {
      console.warn(`Sample not found: ${name}`);
      return null;
    }

    const {
      rate = 1.0,
      detune = 0,
      loop = false,
      loopStart = 0,
      loopEnd = buffer.duration,
      gain = 1.0,
      pan = 0
    } = options;

    const startTime = when || this.audioContext.currentTime;
    const source = this.audioContext.createBufferSource();
    const gainNode = this.audioContext.createGain();
    const panNode = this.audioContext.createStereoPanner();

    source.buffer = buffer;
    source.playbackRate.value = rate;
    source.detune.value = detune;
    source.loop = loop;
    if (loop) {
      source.loopStart = loopStart;
      source.loopEnd = loopEnd;
    }

    gainNode.gain.value = gain;
    panNode.pan.value = pan;

    source.connect(gainNode);
    gainNode.connect(panNode);

    source.start(startTime);

    return {
      source,
      gainNode,
      panNode,
      output: panNode
    };
  }

  // ============================================================================
  // ENHANCED SYNTHESIS
  // ============================================================================

  createOscillator(options = {}) {
    const {
      type = 'sine',
      frequency = 440,
      detune = 0,
      when = null
    } = options;

    const osc = this.audioContext.createOscillator();
    osc.type = type;
    osc.frequency.value = frequency;
    osc.detune.value = detune;

    return osc;
  }

  // FM synthesis
  createFMSynth(options = {}) {
    const {
      carrierFreq = 440,
      modulatorFreq = 220,
      modulationIndex = 10,
      when = null,
      duration = 1.0
    } = options;

    const startTime = when || this.audioContext.currentTime;

    // Carrier oscillator
    const carrier = this.audioContext.createOscillator();
    carrier.frequency.value = carrierFreq;

    // Modulator oscillator
    const modulator = this.audioContext.createOscillator();
    modulator.frequency.value = modulatorFreq;

    // Modulation gain
    const modulatorGain = this.audioContext.createGain();
    modulatorGain.gain.value = modulationIndex;

    // Connect FM synthesis
    modulator.connect(modulatorGain);
    modulatorGain.connect(carrier.frequency);

    // Envelope
    const envelope = this.audioContext.createGain();
    envelope.gain.setValueAtTime(0, startTime);
    envelope.gain.linearRampToValueAtTime(1, startTime + 0.01);
    envelope.gain.exponentialRampToValueAtTime(0.001, startTime + duration);

    carrier.connect(envelope);

    return {
      carrier,
      modulator,
      modulatorGain,
      envelope,
      output: envelope,
      start: (time) => {
        carrier.start(time);
        modulator.start(time);
      },
      stop: (time) => {
        carrier.stop(time);
        modulator.stop(time);
      }
    };
  }

  // ADSR Envelope
  createEnvelope(gainNode, options = {}) {
    const {
      attack = 0.01,
      decay = 0.1,
      sustain = 0.7,
      release = 0.3,
      when = null
    } = options;

    const startTime = when || this.audioContext.currentTime;
    const attackEnd = startTime + attack;
    const decayEnd = attackEnd + decay;

    gainNode.gain.setValueAtTime(0, startTime);
    gainNode.gain.linearRampToValueAtTime(1, attackEnd);
    gainNode.gain.exponentialRampToValueAtTime(sustain, decayEnd);

    return {
      release: (when) => {
        const releaseStart = when || this.audioContext.currentTime;
        gainNode.gain.cancelScheduledValues(releaseStart);
        gainNode.gain.setValueAtTime(gainNode.gain.value, releaseStart);
        gainNode.gain.exponentialRampToValueAtTime(0.001, releaseStart + release);
      }
    };
  }

  // LFO (Low Frequency Oscillator)
  createLFO(options = {}) {
    const {
      frequency = 1,
      type = 'sine',
      min = 0,
      max = 1
    } = options;

    const lfo = this.audioContext.createOscillator();
    const lfoGain = this.audioContext.createGain();

    lfo.frequency.value = frequency;
    lfo.type = type;

    const range = (max - min) / 2;
    const offset = min + range;

    lfoGain.gain.value = range;

    lfo.connect(lfoGain);

    return {
      lfo,
      lfoGain,
      output: lfoGain,
      start: () => lfo.start(),
      stop: () => lfo.stop()
    };
  }

  // ============================================================================
  // CONSCIOUSNESS-AWARE SYNTHESIS
  // ============================================================================

  // Create synthesis based on AMF consciousness parameters
  createConsciousSynth(consciousnessParams) {
    const {
      base_frequency = 7.5,
      state = 'creative',
      cognitive_load = 0.5,
      arousal = 0.7,
      sync_coefficient = 0.85
    } = consciousnessParams;

    // Map consciousness state to synthesis parameters
    const stateMap = {
      'grounded': { waveform: 'sine', harmonics: 2, brightness: 0.3 },
      'creative': { waveform: 'triangle', harmonics: 5, brightness: 0.6 },
      'hyperfocus': { waveform: 'square', harmonics: 8, brightness: 0.9 },
      'hallucinating': { waveform: 'sawtooth', harmonics: 12, brightness: 1.0 }
    };

    const config = stateMap[state] || stateMap['creative'];

    // Build additive synthesis based on consciousness
    const fundamental = this.createOscillator({
      type: config.waveform,
      frequency: base_frequency
    });

    const harmonics = [];
    for (let i = 1; i <= config.harmonics; i++) {
      const harmonic = this.createOscillator({
        type: 'sine',
        frequency: base_frequency * (i + 1)
      });
      const harmonicGain = this.audioContext.createGain();
      harmonicGain.gain.value = config.brightness / (i + 1); // Falloff
      harmonic.connect(harmonicGain);
      harmonics.push({ osc: harmonic, gain: harmonicGain });
    }

    // Mix based on cognitive load
    const mixer = this.audioContext.createGain();
    mixer.gain.value = cognitive_load;

    fundamental.connect(mixer);
    harmonics.forEach(h => h.gain.connect(mixer));

    return {
      fundamental,
      harmonics,
      mixer,
      output: mixer,
      start: (when) => {
        fundamental.start(when);
        harmonics.forEach(h => h.osc.start(when));
      },
      stop: (when) => {
        fundamental.stop(when);
        harmonics.forEach(h => h.osc.stop(when));
      }
    };
  }
  // ============================================================================
  // PERFORMANCE & SIGNAL HANDLING
  // ============================================================================

  playPerformance(performance) {
    console.log("Creating performance:", performance.name);
    // Use render_data (formerly jsonld_data) to drive synthesis
    const data = performance.render_data || {};

    // Example: Trigger consciousness synth if present
    if (data.consciousness) {
      return this.createConsciousSynth(data.consciousness);
    }
    return null;
  }

  async initSignalProcessor() {
    // Void Modality: Live Input Processing
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      const source = this.audioContext.createMediaStreamSource(stream);
      const analyser = this.audioContext.createAnalyser();
      source.connect(analyser);
      this.signalAnalyser = analyser;
      console.log("✅ Void Signal initialized");
    } catch (err) {
      console.warn("Could not init Void Signal:", err);
    }
  }
}

export default AudioEngine;
