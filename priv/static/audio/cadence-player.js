// Cadence Audio Player - Converts JSON-LD fingerprints to audio
import { createKick } from './kick.js';
import { createSnare } from './snare.js';
import { createHihat } from './hihat.js';

export class CadencePlayer {
  constructor() {
    this.audioContext = null;
    this.isPlaying = false;
  }

  async init() {
    if (!this.audioContext) {
      this.audioContext = new (window.AudioContext || window.webkitAudioContext)();
    }
    
    // Resume context if suspended (browser autoplay policy)
    if (this.audioContext.state === 'suspended') {
      await this.audioContext.resume();
    }
  }

  // Main method: play audio from Cadence JSON-LD fingerprint
  async playFingerprint(fingerprint) {
    await this.init();
    
    if (this.isPlaying) {
      console.log('Already playing, ignoring...');
      return;
    }

    this.isPlaying = true;
    
    try {
      // Handle different fingerprint types
      const graph = fingerprint["@graph"] || [fingerprint];
      
      for (const node of graph) {
        await this.playNode(node);
      }
    } catch (error) {
      console.error('Error playing fingerprint:', error);
    } finally {
      // Reset after a reasonable time
      setTimeout(() => { this.isPlaying = false; }, 2000);
    }
  }

  async playNode(node) {
    const nodeType = node["@type"];
    
    switch (nodeType) {
      case "cadence:DrumHit":
        this.playDrumHit(node);
        break;
        
      case "cadence:Pipeline":
        // Play the input, then apply processing
        await this.playNode(node.input);
        this.applyProcessing(node.processing);
        break;
        
      case "cadence:Combination":
        // Play left and right simultaneously (if plus) or sequentially
        if (node.operator === "plus") {
          // Simultaneous
          this.playNode(node.left);
          this.playNode(node.right);
        } else {
          // Sequential for other operators
          await this.playNode(node.left);
          await this.playNode(node.right);
        }
        break;
        
      case "cadence:Composition":
        // Play all nodes in the composition
        const graph = node["@graph"] || [];
        for (const subNode of graph) {
          await this.playNode(subNode);
        }
        break;
        
      default:
        console.log(`Unhandled node type: ${nodeType}`);
    }
  }

  playDrumHit(drumHit) {
    const instrument = drumHit.instrument;
    const frequency = drumHit.frequency?.fundamental;
    const pattern = drumHit.temporal?.pattern || 4;
    const offset = drumHit.temporal?.offset || 0;
    
    console.log(`Playing ${instrument} every ${pattern} beats, offset ${offset}`);

    // For now, just play once - later we'll handle patterns
    switch (instrument) {
      case "kick":
        createKick(this.audioContext, frequency);
        break;
        
      case "snare":
        createSnare(this.audioContext, frequency);
        break;
        
      case "hihat":
        createHihat(this.audioContext, frequency);
        break;
        
      default:
        console.warn(`Unknown instrument: ${instrument}`);
    }
  }

  applyProcessing(processing) {
    const processingType = processing["@type"];
    
    switch (processingType) {
      case "cadence:Visualizer":
        const vizType = processing.vizType?.value;
        console.log(`Visualization: ${vizType}`);
        // Visualizers don't affect audio, just log for now
        break;
        
      case "cadence:ReverbEffect":
        const room = processing.room || 0.3;
        console.log(`Applying reverb, room: ${room}`);
        // TODO: Add actual reverb processing
        break;
        
      default:
        console.log(`Unhandled processing: ${processingType}`);
    }
  }

  // Utility method for simple one-shot playback
  async playPattern(pattern, bpm = 120) {
    await this.init();
    
    const beatDuration = 60 / bpm; // seconds per beat
    let currentTime = this.audioContext.currentTime;
    
    // Simple pattern playback - just demonstration
    pattern.forEach((hit, index) => {
      if (hit) {
        // Schedule the hit
        setTimeout(() => {
          switch (index % 3) {
            case 0: createKick(this.audioContext); break;
            case 1: createSnare(this.audioContext); break;
            case 2: createHihat(this.audioContext); break;
          }
        }, index * beatDuration * 1000);
      }
    });
  }
}

// Global player instance
window.cadencePlayer = new CadencePlayer();