import AudioEngine from './audio_engine.js';

class CadencePlayer {
  constructor() {
    this.engine = new AudioEngine();
    this.audioContext = null;
    this.isPlaying = false;
    this.isLooping = false;
    this.bpm = 120;
    this.loopLength = 4; // bars
    this.scheduledEvents = [];
    this.nextLoop = 0;
    this.lookahead = 25.0; // ms
    this.scheduleAheadTime = 0.1; // seconds
    this.effectsChain = null;
  }

  async init() {
    await this.engine.init();
    this.audioContext = this.engine.audioContext;

    if (this.audioContext.state === 'suspended') {
      await this.audioContext.resume();
    }
  }

  createKick(frequency = 60, when = null) {
    const startTime = when || this.audioContext.currentTime;
    const osc = this.audioContext.createOscillator();
    const gain = this.audioContext.createGain();
    
    osc.frequency.setValueAtTime(frequency, startTime);
    osc.frequency.exponentialRampToValueAtTime(1, startTime + 0.1);
    
    gain.gain.setValueAtTime(0.8, startTime);
    gain.gain.exponentialRampToValueAtTime(0.001, startTime + 0.3);
    
    osc.connect(gain);
    gain.connect(this.audioContext.destination);
    
    osc.start(startTime);
    osc.stop(startTime + 0.3);
  }

  scheduleKick(frequency, when) {
    this.createKick(frequency, when);
  }

  createSnare(frequency = 200, when = null) {
    const startTime = when || this.audioContext.currentTime;
    
    const bufferSize = this.audioContext.sampleRate * 0.1;
    const buffer = this.audioContext.createBuffer(1, bufferSize, this.audioContext.sampleRate);
    const output = buffer.getChannelData(0);
    
    for (let i = 0; i < bufferSize; i++) {
      output[i] = Math.random() * 2 - 1;
    }
    
    const noise = this.audioContext.createBufferSource();
    noise.buffer = buffer;
    
    const gain = this.audioContext.createGain();
    gain.gain.setValueAtTime(0.5, startTime);
    gain.gain.exponentialRampToValueAtTime(0.001, startTime + 0.1);
    
    noise.connect(gain);
    gain.connect(this.audioContext.destination);
    
    noise.start(startTime);
    noise.stop(startTime + 0.1);
  }

  scheduleSnare(frequency, when) {
    this.createSnare(frequency, when);
  }

  createHihat(frequency = 8000, when = null) {
    const startTime = when || this.audioContext.currentTime;
    const osc = this.audioContext.createOscillator();
    const gain = this.audioContext.createGain();
    const filter = this.audioContext.createBiquadFilter();
    
    osc.type = 'square';
    osc.frequency.setValueAtTime(frequency, startTime);
    
    filter.type = 'highpass';
    filter.frequency.setValueAtTime(6000, startTime);
    
    gain.gain.setValueAtTime(0.3, startTime);
    gain.gain.exponentialRampToValueAtTime(0.001, startTime + 0.05);
    
    osc.connect(filter);
    filter.connect(gain);  
    gain.connect(this.audioContext.destination);
    
    osc.start(startTime);
    osc.stop(startTime + 0.05);
  }

  scheduleHihat(frequency, when) {
    this.createHihat(frequency, when);
  }

  getBeatDuration() {
    return 60.0 / this.bpm; // seconds per beat
  }

  getBarDuration() {
    return this.getBeatDuration() * 4; // assuming 4/4 time
  }

  stop() {
    this.isPlaying = false;
    this.isLooping = false;
    this.scheduledEvents.forEach(event => {
      if (event.timeoutId) {
        clearTimeout(event.timeoutId);
      }
    });
    this.scheduledEvents = [];
    console.log('🛑 Stopped playback');
  }

  async playFingerprint(fingerprint, loop = false) {
    await this.init();
    
    if (this.isPlaying) {
      this.stop();
      if (!loop) return;
    }

    this.isPlaying = true;
    this.isLooping = loop;
    this.nextLoop = this.audioContext.currentTime;
    
    console.log(`🎶 Starting playback (BPM: ${this.bpm}, Loop: ${loop})`);
    
    try {
      const graph = fingerprint["@graph"] || [fingerprint];
      this.schedulePattern(graph);
      
      if (loop) {
        this.scheduleNextLoop(fingerprint);
      }
    } catch (error) {
      console.error('Error playing fingerprint:', error);
      this.stop();
    }
  }

  schedulePattern(graph) {
    const startTime = this.nextLoop;
    
    for (const node of graph) {
      this.scheduleNode(node, startTime);
    }
    
    this.nextLoop += this.getBarDuration() * this.loopLength;
  }

  scheduleNextLoop(fingerprint) {
    if (!this.isLooping) return;
    
    const timeUntilNextLoop = (this.nextLoop - this.audioContext.currentTime) * 1000 - this.lookahead;
    
    if (timeUntilNextLoop > 0) {
      const timeoutId = setTimeout(() => {
        if (this.isLooping) {
          const graph = fingerprint["@graph"] || [fingerprint];
          this.schedulePattern(graph);
          this.scheduleNextLoop(fingerprint);
        }
      }, timeUntilNextLoop);
      
      this.scheduledEvents.push({ timeoutId });
    }
  }

  scheduleNode(node, startTime) {
    const nodeType = node["@type"];

    switch (nodeType) {
      case "cadence:DrumHit":
        this.scheduleDrumHit(node, startTime);
        break;

      case "cadence:Pipeline":
        // Handle pipeline: input |> processing
        const inputNode = node.input;
        const processingNode = node.processing;

        // If processing is an effect, set up effects chain
        if (this.isEffectNode(processingNode)) {
          this.effectsChain = this.createEffectFromNode(processingNode);
        }

        // Schedule the input with effects
        this.scheduleNode(inputNode, startTime);

        // Reset effects chain
        this.effectsChain = null;
        break;

      case "cadence:Combination":
        if (node.operator === "plus") {
          this.scheduleNode(node.left, startTime);
          this.scheduleNode(node.right, startTime);
        }
        break;

      case "cadence:Composition":
        const graph = node["@graph"] || [];
        for (const subNode of graph) {
          this.scheduleNode(subNode, startTime);
        }
        break;

      case "cadence:ReverbEffect":
      case "cadence:DelayEffect":
      case "cadence:FilterEffect":
        // Effects are handled in Pipeline, log them for now
        console.log(`Effect node: ${nodeType}`, node);
        break;

      case "cadence:SafetyGrounding":
      case "cadence:ConsciousnessOptimization":
      case "cadence:ConsciousnessHallucination":
      case "cadence:GroundingOperation":
        // Consciousness operations - apply to global state
        this.applyConsciousnessOperation(node);
        break;

      default:
        console.log(`Scheduling node type: ${nodeType}`);
    }
  }

  applyConsciousnessOperation(node) {
    const consciousness = node.consciousness;
    if (!consciousness) return;

    console.log(`🧠 Consciousness operation: ${node['@type']}`);
    console.log(`   State: ${consciousness.state}`);
    console.log(`   Frequency: ${consciousness.base_frequency} Hz`);
    console.log(`   Load: ${consciousness.cognitive_load}, Arousal: ${consciousness.arousal}`);
    console.log(`   ${consciousness.description}`);

    // Create consciousness tone that runs throughout
    const synth = this.engine.createConsciousSynth(consciousness);
    synth.output.connect(this.engine.masterGain);

    const startTime = this.audioContext.currentTime;
    const duration = this.getBarDuration() * this.loopLength;

    synth.start(startTime);
    synth.stop(startTime + duration);

    // Store for visualization/monitoring
    this.currentConsciousnessState = {
      ...consciousness,
      nodeType: node['@type'],
      startTime: startTime,
      endTime: startTime + duration
    };

    // Broadcast consciousness state to visualizer
    window.dispatchEvent(new CustomEvent('consciousness_state_update', {
      detail: consciousness
    }));
  }

  isEffectNode(node) {
    const effectTypes = [
      'cadence:ReverbEffect',
      'cadence:DelayEffect',
      'cadence:FilterEffect',
      'cadence:CompressorEffect',
      'cadence:DistortionEffect'
    ];
    return node && effectTypes.includes(node['@type']);
  }

  createEffectFromNode(node) {
    const nodeType = node['@type'];

    switch (nodeType) {
      case 'cadence:ReverbEffect':
        return this.engine.createReverb({
          room: node.room || 0.3,
          duration: node.duration || 2.0,
          decay: node.decay || 2.0
        });

      case 'cadence:DelayEffect':
        return this.engine.createDelay({
          time: node.time || 0.5,
          feedback: node.feedback || 0.3,
          mix: node.mix || 0.5
        });

      case 'cadence:FilterEffect':
        return this.engine.createFilter({
          type: node.filterType || 'lowpass',
          frequency: node.frequency || 1000,
          q: node.q || 1.0
        });

      default:
        console.warn(`Unknown effect type: ${nodeType}`);
        return null;
    }
  }

  async playNode(node) {
    // Immediate playback (for non-looping mode)
    this.scheduleNode(node, this.audioContext.currentTime);
  }

  scheduleDrumHit(drumHit, startTime) {
    const instrument = drumHit.instrument;
    const frequency = drumHit.frequency?.fundamental;
    const every = drumHit.every;
    const times = drumHit.times;
    const offset = drumHit.offset || 0;
    
    const beatDuration = this.getBeatDuration();
    const patternLength = this.getBarDuration() * this.loopLength;
    
    // Schedule hits within the pattern
    if (every !== undefined) {
      // Pattern like kick(every: 4) - hit every N beats
      const interval = beatDuration * every;
      const startOffset = beatDuration * offset;
      
      for (let time = startTime + startOffset; time < startTime + patternLength; time += interval) {
        this.scheduleDrumSound(instrument, frequency, time);
      }
    } else if (times !== undefined) {
      // Pattern like hihat(times: 16) - hit N times evenly spaced
      const interval = patternLength / times;
      
      for (let i = 0; i < times; i++) {
        const time = startTime + (i * interval);
        this.scheduleDrumSound(instrument, frequency, time);
      }
    } else {
      // Default: single hit
      this.scheduleDrumSound(instrument, frequency, startTime);
    }
  }

  scheduleDrumSound(instrument, frequency, when) {
    console.log(`🥁 Scheduling ${instrument} at ${when.toFixed(3)}s`);
    
    switch (instrument) {
      case "kick":
        this.scheduleKick(frequency, when);
        break;
      case "snare":
        this.scheduleSnare(frequency, when);
        break;
      case "hihat":
        this.scheduleHihat(frequency, when);
        break;
    }
  }

  playDrumHit(drumHit) {
    const instrument = drumHit.instrument;
    const frequency = drumHit.frequency?.fundamental;
    
    console.log(`🥁 Playing ${instrument} at ${frequency}Hz`);

    switch (instrument) {
      case "kick":
        this.createKick(frequency);
        break;
      case "snare":
        this.createSnare(frequency);
        break;
      case "hihat":
        this.createHihat(frequency);
        break;
      default:
        console.warn(`Unknown instrument: ${instrument}`);
    }
  }
}

export const CadenceAudio = {
  mounted() {
    console.log('🎵 Cadence Audio Hook mounted');
    this.player = new CadencePlayer();
    
    this.handleEvent("play_audio", ({fingerprint, loop}) => {
      console.log("🎶 Received play request:", fingerprint, "Loop:", loop);
      this.player.playFingerprint(fingerprint, loop).catch(console.error);
    });

    this.handleEvent("stop_audio", () => {
      console.log("🛑 Received stop request");
      this.player.stop();
    });
  },
  
  destroyed() {
    if (this.player && this.player.audioContext) {
      this.player.audioContext.close();
    }
  }
}