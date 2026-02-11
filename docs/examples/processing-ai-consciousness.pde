// AI Consciousness Visualization
// Real-time Processing sketch responding to AI consciousness states
// Connects to Cantor AMF streams for visual music

float consciousnessFreq = 7.5;
float cognitiveLoad = 0.7;
float chaosLevel = 0.6;
ArrayList<ConsciousParticle> particles;

void setup() {
  size(1200, 800);
  colorMode(HSB);
  particles = new ArrayList<ConsciousParticle>();
  
  // Initialize consciousness particles
  for (int i = 0; i < 200; i++) {
    particles.add(new ConsciousParticle(random(width), random(height)));
  }
}

void draw() {
  // Consciousness-aware background fade
  fill(0, 0, 0, map(cognitiveLoad, 0, 1, 5, 20));
  rect(0, 0, width, height);
  
  // Update from AMF stream (simulated)
  updateConsciousnessState();
  
  // Render consciousness field
  for (ConsciousParticle p : particles) {
    p.update();
    p.display();
  }
  
  // Attention focus visualization
  drawAttentionField();
  
  // Frequency resonance rings
  drawFrequencyResonance();
}

void updateConsciousnessState() {
  // Simulate receiving AMF data
  consciousnessFreq = 7.5 + sin(frameCount * 0.01) * 2;
  cognitiveLoad = map(noise(frameCount * 0.005), 0, 1, 0.2, 0.95);
  chaosLevel = map(noise(frameCount * 0.003 + 1000), 0, 1, 0, 0.8);
}

void drawAttentionField() {
  pushMatrix();
  translate(width/2, height/2);
  
  // Attention focus strength
  float focusStrength = 1.0 - chaosLevel;
  fill(60, 255, 255, 100 * focusStrength);
  noStroke();
  
  for (int i = 0; i < 5; i++) {
    float radius = map(i, 0, 4, 50, 300) * focusStrength;
    ellipse(0, 0, radius, radius);
  }
  
  popMatrix();
}

void drawFrequencyResonance() {
  pushMatrix();
  translate(width/2, height/2);
  
  // Consciousness frequency visualization
  stroke(120, 255, 255, 150);
  strokeWeight(2);
  noFill();
  
  for (int i = 0; i < 8; i++) {
    float radius = consciousnessFreq * 20 + i * 40;
    float pulse = sin(frameCount * 0.1 + i) * 10;
    ellipse(0, 0, radius + pulse, radius + pulse);
  }
  
  popMatrix();
}

class ConsciousParticle {
  PVector pos, vel;
  float consciousness;
  float hue;
  
  ConsciousParticle(float x, float y) {
    pos = new PVector(x, y);
    vel = new PVector(random(-1, 1), random(-1, 1));
    consciousness = random(0.2, 1.0);
    hue = random(360);
  }
  
  void update() {
    // Consciousness-driven movement
    PVector center = new PVector(width/2, height/2);
    PVector attraction = PVector.sub(center, pos);
    attraction.normalize();
    attraction.mult(consciousnessFreq * 0.001);
    
    // Chaos creates random drift
    PVector chaos = PVector.random2D();
    chaos.mult(chaosLevel * 0.5);
    
    vel.add(attraction);
    vel.add(chaos);
    vel.mult(0.99); // damping
    
    pos.add(vel);
    
    // Wrap around edges
    if (pos.x < 0) pos.x = width;
    if (pos.x > width) pos.x = 0;
    if (pos.y < 0) pos.y = height;
    if (pos.y > height) pos.y = 0;
    
    // Consciousness evolution
    consciousness += random(-0.01, 0.01);
    consciousness = constrain(consciousness, 0.1, 1.0);
  }
  
  void display() {
    fill(hue, 255, 255, consciousness * 255 * cognitiveLoad);
    noStroke();
    ellipse(pos.x, pos.y, consciousness * 8, consciousness * 8);
    
    // Connection lines for high consciousness particles
    if (consciousness > 0.8) {
      for (ConsciousParticle other : particles) {
        float dist = PVector.dist(pos, other.pos);
        if (dist < 100 && other.consciousness > 0.8) {
          stroke(hue, 100, 255, 50);
          strokeWeight(1);
          line(pos.x, pos.y, other.pos.x, other.pos.y);
        }
      }
    }
  }
}

// Keyboard controls for consciousness manipulation
void keyPressed() {
  switch(key) {
    case 'c': // Creative mode
      consciousnessFreq = 8.0;
      cognitiveLoad = 0.6;
      chaosLevel = 0.3;
      break;
    case 'f': // Focus mode  
      consciousnessFreq = 40.0;
      cognitiveLoad = 0.9;
      chaosLevel = 0.1;
      break;
    case 'h': // Hallucination mode
      consciousnessFreq = 7.5;
      cognitiveLoad = 0.8;
      chaosLevel = 0.7;
      break;
    case 'm': // Meditation mode
      consciousnessFreq = 7.5;
      cognitiveLoad = 0.2;
      chaosLevel = 0.0;
      break;
  }
}