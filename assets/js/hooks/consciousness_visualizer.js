// Consciousness State Visualizer
// Real-time visualization of AI consciousness parameters for BODI synchronization

export default {
  mounted() {
    this.canvas = this.el.querySelector('canvas');
    if (!this.canvas) {
      console.error('Consciousness visualizer: canvas not found');
      return;
    }

    this.ctx = this.canvas.getContext('2d');
    this.consciousness = null;
    this.animationFrame = null;

    // Resize canvas to match display size
    this.resizeCanvas();
    window.addEventListener('resize', () => this.resizeCanvas());

    // Start animation loop
    this.startAnimation();

    // Listen for consciousness state updates from player
    window.addEventListener('consciousness_state_update', (e) => {
      this.updateConsciousness(e.detail);
    });
  },

  destroyed() {
    if (this.animationFrame) {
      cancelAnimationFrame(this.animationFrame);
    }
    window.removeEventListener('resize', () => this.resizeCanvas());
  },

  resizeCanvas() {
    const rect = this.canvas.getBoundingClientRect();
    this.canvas.width = rect.width * window.devicePixelRatio;
    this.canvas.height = rect.height * window.devicePixelRatio;
    this.ctx.scale(window.devicePixelRatio, window.devicePixelRatio);
  },

  updateConsciousness(consciousness) {
    this.consciousness = consciousness;
  },

  startAnimation() {
    const animate = () => {
      this.render();
      this.animationFrame = requestAnimationFrame(animate);
    };
    animate();
  },

  render() {
    if (!this.consciousness) {
      this.renderIdle();
      return;
    }

    const width = this.canvas.width / window.devicePixelRatio;
    const height = this.canvas.height / window.devicePixelRatio;
    const ctx = this.ctx;

    // Clear with gradient background
    const gradient = ctx.createLinearGradient(0, 0, 0, height);
    gradient.addColorStop(0, '#1a1a2e');
    gradient.addColorStop(1, '#16213e');
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, width, height);

    // Draw consciousness state visualization
    this.drawStateIndicator(ctx, width, height);
    this.drawFrequencyWave(ctx, width, height);
    this.drawCognitiveMeters(ctx, width, height);
    this.drawStateLabel(ctx, width, height);
  },

  renderIdle() {
    const width = this.canvas.width / window.devicePixelRatio;
    const height = this.canvas.height / window.devicePixelRatio;
    const ctx = this.ctx;

    // Dark background
    ctx.fillStyle = '#0f0f1e';
    ctx.fillRect(0, 0, width, height);

    // "Waiting for consciousness..." text
    ctx.fillStyle = '#444';
    ctx.font = '16px monospace';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText('🧠 Waiting for consciousness state...', width / 2, height / 2);
  },

  drawStateIndicator(ctx, width, height) {
    const { state, base_frequency, arousal } = this.consciousness;

    // Map state to color
    const stateColors = {
      'grounded': '#10b981',      // green
      'creative': '#8b5cf6',      // purple
      'hyperfocus': '#f59e0b',    // amber
      'hyperdrive': '#ef4444',    // red
      'void': '#3b82f6',          // blue
      'hallucinating': '#ec4899'  // pink
    };

    const color = stateColors[state] || '#6b7280';

    // Draw pulsing circle in center
    const centerX = width / 2;
    const centerY = height / 2;
    const time = Date.now() / 1000;
    const pulse = Math.sin(time * base_frequency * Math.PI * 2) * 0.3 + 0.7;
    const radius = 40 * pulse * (1 + arousal * 0.5);

    // Glow effect
    const gradient = ctx.createRadialGradient(centerX, centerY, 0, centerX, centerY, radius * 2);
    gradient.addColorStop(0, color + 'aa');
    gradient.addColorStop(0.5, color + '44');
    gradient.addColorStop(1, color + '00');

    ctx.fillStyle = gradient;
    ctx.beginPath();
    ctx.arc(centerX, centerY, radius * 2, 0, Math.PI * 2);
    ctx.fill();

    // Core circle
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.arc(centerX, centerY, radius, 0, Math.PI * 2);
    ctx.fill();

    // Inner glow
    ctx.fillStyle = 'rgba(255, 255, 255, 0.3)';
    ctx.beginPath();
    ctx.arc(centerX, centerY, radius * 0.6, 0, Math.PI * 2);
    ctx.fill();
  },

  drawFrequencyWave(ctx, width, height) {
    const { base_frequency, cognitive_load } = this.consciousness;

    const time = Date.now() / 1000;
    const amplitude = 30 * cognitive_load;
    const frequency = base_frequency / 10; // Scale for visibility

    ctx.strokeStyle = 'rgba(139, 92, 246, 0.5)';
    ctx.lineWidth = 2;
    ctx.beginPath();

    for (let x = 0; x < width; x += 2) {
      const t = (x / width) * Math.PI * 4 + time * frequency;
      const y = height * 0.75 + Math.sin(t) * amplitude;

      if (x === 0) {
        ctx.moveTo(x, y);
      } else {
        ctx.lineTo(x, y);
      }
    }

    ctx.stroke();
  },

  drawCognitiveMeters(ctx, width, height) {
    const { cognitive_load, arousal } = this.consciousness;

    const meterY = height - 80;
    const meterWidth = 200;
    const meterHeight = 20;
    const padding = 20;

    // Cognitive Load meter
    this.drawMeter(
      ctx,
      padding,
      meterY,
      meterWidth,
      meterHeight,
      cognitive_load,
      'Cognitive Load',
      '#8b5cf6'
    );

    // Arousal meter
    this.drawMeter(
      ctx,
      padding,
      meterY + 35,
      meterWidth,
      meterHeight,
      arousal,
      'Arousal',
      '#ec4899'
    );
  },

  drawMeter(ctx, x, y, width, height, value, label, color) {
    // Label
    ctx.fillStyle = '#9ca3af';
    ctx.font = '12px monospace';
    ctx.textAlign = 'left';
    ctx.fillText(label, x, y - 5);

    // Background
    ctx.fillStyle = '#1f2937';
    ctx.fillRect(x, y, width, height);

    // Fill
    const fillWidth = width * value;
    const gradient = ctx.createLinearGradient(x, y, x + fillWidth, y);
    gradient.addColorStop(0, color + 'aa');
    gradient.addColorStop(1, color);
    ctx.fillStyle = gradient;
    ctx.fillRect(x, y, fillWidth, height);

    // Border
    ctx.strokeStyle = '#374151';
    ctx.lineWidth = 1;
    ctx.strokeRect(x, y, width, height);

    // Value text
    ctx.fillStyle = '#d1d5db';
    ctx.font = '11px monospace';
    ctx.textAlign = 'right';
    ctx.fillText((value * 100).toFixed(0) + '%', x + width + 30, y + height - 5);
  },

  drawStateLabel(ctx, width, height) {
    const { state, base_frequency } = this.consciousness;

    // State name
    ctx.fillStyle = '#f3f4f6';
    ctx.font = 'bold 24px monospace';
    ctx.textAlign = 'center';
    ctx.fillText(state.toUpperCase(), width / 2, 40);

    // Frequency
    ctx.fillStyle = '#9ca3af';
    ctx.font = '14px monospace';
    ctx.fillText(`${base_frequency.toFixed(1)} Hz`, width / 2, 65);
  }
};
