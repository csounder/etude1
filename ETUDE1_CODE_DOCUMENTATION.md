# Etude#1 by Dr.C - Complete Code Documentation

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [HTML Structure](#html-structure)
4. [CSS Styling](#css-styling)
5. [JavaScript Components](#javascript-components)
6. [Csound Orchestra](#csound-orchestra)
7. [Audio Synthesis Techniques](#audio-synthesis-techniques)
8. [Visual System (Three.js)](#visual-system)
9. [User Interface Controls](#user-interface-controls)
10. [CSD Recording & Export](#csd-recording--export)
11. [Key Algorithms](#key-algorithms)

---

## Overview

**Etude#1** is a generative audio-visual composition that combines:

- **Csound WASM** for real-time audio synthesis
- **Three.js** for 3D particle visualization
- **Pure JavaScript** for generative composition logic
- **B Phrygian mode** as the tonal center

The piece features **14 layered instruments** that play autonomously, creating an ever-evolving soundscape with synchronized 3D visuals.

---

## Architecture

### High-Level Design

```
┌─────────────────────────────────────────────┐
│           HTML Single Page App              │
├─────────────────────────────────────────────┤
│  ┌────────────┐  ┌──────────┐  ┌─────────┐ │
│  │   Csound   │  │ Three.js │  │   UI    │ │
│  │   WASM     │  │ Renderer │  │Controls │ │
│  └─────┬──────┘  └────┬─────┘  └────┬────┘ │
│        │              │              │      │
│   ┌────▼──────────────▼──────────────▼───┐  │
│   │   JavaScript Composition Engine      │  │
│   │  • 14 Autonomous Composers           │  │
│   │  • RMS Audio Level Reader            │  │
│   │  • Particle System Controller        │  │
│   └──────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

### Key Technologies

- **Csound WASM 6.18+**: Real-time audio synthesis in the browser
- **Three.js r128**: WebGL-based 3D graphics
- **Unsplash API**: High-quality background images
- **Web Audio API**: Audio analysis for visual reactivity

---

## HTML Structure

### Document Layout

```html
<!doctype html>
<html lang="en">
  <head>
    <!-- Meta tags -->
    <title>Etude#1 by Dr.C</title>
    <!-- Three.js CDN -->
    <script src="three.js"></script>
    <style>
      /* Embedded CSS */
    </style>
  </head>
  <body>
    <div id="three-container">
      <!-- Three.js canvas inserted here -->
    </div>

    <div id="controls">
      <!-- UI controls -->
    </div>

    <div id="status">
      <!-- Status display -->
    </div>

    <script>
      /* JavaScript + Csound code */
    </script>
  </body>
</html>
```

### Key Sections

1. **#three-container**: Full-screen background for Three.js + background images
2. **#controls**: Floating control panel with sliders and buttons
3. **#status**: Bottom-left status display showing time and state

---

## CSS Styling

### Design Philosophy

- **Dark Theme**: Black background, purple accent colors
- **Glassmorphism**: Semi-transparent panels with backdrop blur
- **Smooth Animations**: All interactions have 0.3s transitions
- **Monospace Font**: "Courier New" for technical aesthetic

### Key CSS Patterns

#### Layered Z-Index System

```css
#three-container {
  z-index: 1;
} /* Background */
#controls {
  z-index: 10;
} /* UI on top */
#status {
  z-index: 10;
} /* Status on top */
```

#### Glassmorphism Effect

```css
background: rgba(10, 10, 30, 0.85);
backdrop-filter: blur(10px);
border: 1px solid rgba(255, 255, 255, 0.1);
```

#### Gradient Buttons

```css
background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
```

---

## JavaScript Components

### 1. Core Variables

```javascript
let csound = null; // Csound WASM instance
let isPlaying = false; // Playback state
let startTime = 0; // Time tracking
let composerTimers = []; // setTimeout IDs for cleanup
let randomBgEnabled = false; // Random background state
let randomBgInterval = 30; // Background change interval (seconds)
```

### 2. Musical Scale Definition

```javascript
// B Phrygian mode (MIDI note numbers)
const bPhrygian = [
  47,
  48,
  50,
  52,
  54,
  55,
  57,
  59, // Lower octave
  60,
  62,
  64,
  66,
  67,
  69,
  71, // Middle octave
  72,
  74,
  76,
  78,
  79,
  81,
  83, // Upper octave
];

// Chord tones for harmony
const chordTones = [35, 38, 40, 43, 47, 50, 52, 55, 59];
```

**Why B Phrygian?**

- Dark, exotic modal color
- Minor second interval (B-C) creates tension
- Perfect for ambient/generative music

### 3. Layer Management

```javascript
const layers = [
  "fm",
  "drone",
  "noise",
  "rumble",
  "bellchord",
  "pwm",
  "thunder",
  "flute",
  "cello",
  "cricket",
  "bird",
  "water",
  "fire",
  "marimba",
];

// Each layer has:
// - Volume control (0-1)
// - Mute state (boolean)
// - Solo capability (exclusive)
// - RMS audio level (for visual reactivity)
```

### 4. Composer Functions Pattern

All 14 composers follow this structure:

```javascript
function composeFM() {
  // 1. Check if still playing
  if (!isPlaying) return;

  // 2. Generate musical parameters
  const note = choose(bPhrygian) + 24; // Transpose up 2 octaves
  const dur = rand(0.2, 1.2); // Random duration
  const amp = rand(0.04, 0.1); // Random amplitude

  // 3. Send to Csound
  csound.inputMessage(`i "FM" 0 ${dur} ${note} ${amp}`);

  // 4. Schedule next call
  const timer = setTimeout(composeFM, rand(400, 3000));
  composerTimers.push(timer); // Store for cleanup
}
```

**Key Features:**

- **Autonomous**: Each composer calls itself recursively
- **Randomized**: Timing and parameters vary each iteration
- **Stoppable**: All timers stored in `composerTimers[]` array
- **Musical**: Uses scale degrees, not arbitrary frequencies

### 5. Audio Level Reading (for Visuals)

```javascript
function startAudioLevelReader() {
  setInterval(async () => {
    if (!csound || !isPlaying) return;

    for (const layer of layers) {
      try {
        const channelName = `rms_${layer}`;
        const rmsRaw = await csound.getControlChannel(channelName);
        const rmsValue =
          typeof rmsRaw === "number" ? rmsRaw : Number(rmsRaw) || 0.0;
        layerAudioLevels[layer] = rmsValue;
      } catch (e) {
        // Silently fail
      }
    }
  }, 50); // Update 20 times per second
}
```

**Why Separate Interval Loop?**

- `getControlChannel()` returns a **Promise** (async)
- Animation loop must be synchronous for 60fps
- Solution: Async loop updates `layerAudioLevels` object
- Animation loop reads object synchronously

### 6. Stop Button Logic

```javascript
document.getElementById("stopBtn").addEventListener("click", async function () {
  isPlaying = false;

  // 1. Clear all JavaScript timers
  composerTimers.forEach((timer) => clearTimeout(timer));
  composerTimers = [];

  // 2. Stop random backgrounds
  stopRandomBackgroundTimer();

  // 3. KILL SWITCH - Stop all Csound instruments immediately
  if (csound) {
    csound.setControlChannel("kill_switch", 0);
  }

  // 4. Smooth fade out
  // Dry signal: 2.5 seconds (exponential)
  // Effects: 5 seconds (elegant reverb tail)

  // 5. Restore settings when complete
  csound.setControlChannel("vol_dry", 1.0);
  csound.setControlChannel("vol_effect", 1.0);
  csound.setControlChannel("kill_switch", 1);
});
```

**Critical Design Decision:**
The kill switch uses Csound's `turnoff2` opcode to **immediately stop all active and scheduled instrument instances**, preventing delayed "explosions" after stop is pressed.

---

## Csound Orchestra

### Header & Global Variables

```csound
sr = 44100      ; Sample rate
ksmps = 32      ; Control rate: 44100/32 = 1378 Hz
nchnls = 2      ; Stereo output
0dbfs = 1       ; Full scale = 1.0 (floating point)
seed 0          ; Random seed

; Global fade envelopes
gkMasterFade init 0   ; 8-second fade-in
gkReverbFade init 0   ; 6-second reverb fade-in (starts at 1s)
gkKillSwitch init 1   ; Emergency stop (1=play, 0=stop)

; Global audio buses (for effects routing)
gaRvbL init 0         ; Reverb send L
gaRvbR init 0         ; Reverb send R
gaEchoL init 0        ; Echo send L
gaEchoR init 0        ; Echo send R
; ... (many more buses for different effects)
```

### Instrument Design Pattern

Every instrument follows this structure:

```csound
instr FM
; 1. PARAMETER PARSING
iFreq = cpsmidinn(p4)    ; p4 = MIDI note number
iAmpBase = p5             ; p5 = base amplitude
iDur = p3                 ; p3 = duration

; 2. VOLUME CONTROL
kVol chnget "vol_fm"      ; UI slider value
kAmp = iAmpBase * kVol    ; Final amplitude

; 3. SYNTHESIS ALGORITHM
; (varies by instrument - see below)

; 4. STEREO WIDENING
aLDelay vdelay aL, 0.5, 5
aRDelay vdelay aR, 0.7, 5
aLWide = aL + aRDelay * 0.2
aRWide = aR + aLDelay * 0.2
aLWide limit aLWide, -0.98, 0.98
aRWide limit aRWide, -0.98, 0.98

; 5. EFFECTS ROUTING
gaRvbL = gaRvbL + aLWide * 0.3  ; 30% to reverb
gaRvbR = gaRvbR + aRWide * 0.3

; 6. RMS TRACKING (for visuals)
kRms rms aFilt
chnset kRms * 10, "rms_fm"

; 7. OUTPUT
outs aLWide * 0.4 * gkMasterFade * gkDryLevel,
     aRWide * 0.4 * gkMasterFade * gkDryLevel
endin
```

### Kill Switch Instrument

```csound
instr KillSwitch
gkKillSwitch chnget "kill_switch"
if gkKillSwitch < 0.01 then
  ; turnoff2 "InstrName", mode, release_time
  ; mode 2 = all instances, release_time 0 = immediate
  turnoff2 "FM", 2, 0
  turnoff2 "Drone", 2, 0
  turnoff2 "Flute", 2, 0
  ; ... all 14 instruments
endif
endin
```

**Why This Works:**

- JavaScript sets `kill_switch` to 0 on stop button
- `turnoff2` with mode 2 kills **ALL instances** of each instrument
- Release time 0 = **immediate stop** (no release envelope)
- Scheduled future events are also cancelled

### Global Fade-In System

```csound
instr GlobalFadeIn
gkMasterFade init 0
gkReverbFade init 0

; Dry signal fade: 0 to 1 over 8 seconds
if gkMasterFade < 1 then
  gkMasterFade = gkMasterFade + (1.0 / (8.0 * kr))
  gkMasterFade limit gkMasterFade, 0, 1
endif

; Reverb fade: starts at 1 second, fades over 6 seconds
if timeinsts() > 1 && gkReverbFade < 1 then
  gkReverbFade = gkReverbFade + (1.0 / (6.0 * kr))
  gkReverbFade limit gkReverbFade, 0, 1
endif

gkMasterVol chnget "vol_effect"
gkDryLevel chnget "vol_dry"
endin
```

**Design Notes:**

- Incremental fade prevents "click" at start
- Reverb delayed by 1 second prevents initial "pop"
- Both use k-rate increment for smoothness
- All instruments multiply output by `gkMasterFade`

---

## Audio Synthesis Techniques

### 1. FM Synthesis (Bell-Like)

```csound
instr FM
iModRatio random 2, 5           ; Modulator frequency ratio
iModIndex random 3.5, 8.0       ; Modulation depth (brightness)

; Carrier envelope (percussive)
kEnv expsegr 0.001, 0.01, 1, iDur*0.15, 0.3,
             iDur*0.25, 0.08, 0.05, 0.001

; Modulator envelope (fast decay for bell character)
aModEnv expsegr 0.001, 0.005, 1, iDur*0.1, 0.2,
                iDur*0.15, 0.05, 0.03, 0.001

; FM algorithm
aMod poscil iModIndex * aModEnv * iFreq, iFreq * iModRatio
aCar poscil kAmp * kEnv, iFreq + aMod
endin
```

**Theory:**

- High modulation ratios (2-5) create inharmonic partials
- High modulation index (3.5-8) adds brightness/metallicness
- Fast envelope decay mimics struck bell

### 2. Drone (3-Voice FM)

```csound
instr Drone
; Three simultaneous FM voices with different ratios
iModRatio random 1, 2
iModIndex random 0.3, 1.2

; Voice 1: fundamental
aMod1 poscil (iModIndex + kLfo) * aModEnv1 * iFreq1,
             iFreq1 * iModRatio
aCar1 poscil kAmp * kEnv * 0.35, iFreq1 + aMod1

; Voice 2: slightly detuned
aMod2 poscil (iModIndex + kLfo*0.8) * aModEnv2 * iFreq2,
             iFreq2 * (iModRatio * 1.1)
aCar2 poscil kAmp * kEnv * 0.3, iFreq2 + aMod2

; Voice 3: different ratio
aMod3 poscil (iModIndex + kLfo*1.2) * aModEnv3 * iFreq3,
             iFreq3 * (iModRatio * 0.9)
aCar3 poscil kAmp * kEnv * 0.28, iFreq3 + aMod3

aMix = aCar1 + aCar2 + aCar3
endin
```

**Design:**

- Three voices create rich texture
- LFO modulation adds slow movement
- Different amplitude weights balance blend

### 3. Marimba (Low FM)

```csound
instr Marimba
iModRatio random 1.5, 2.8       ; Lower ratios = woodier tone
iModIndex random 1.2, 2.8       ; Moderate index = warmth

; Very fast attack/decay
kEnv expsegr 0.001, 0.003, 1, iDur*0.08, 0.25,
             iDur*0.12, 0.08, 0.04, 0.001

; Lowpass filter for woody character
aFilt tone aCar, 3500
aFilt butterlp aFilt, 2800
endin
```

### 4. PWM Chord (Pulse Width Modulation)

```csound
instr PwmChord
; 4-voice chord
iFreq1 = cpsmidinn(p4)
iFreq2 = cpsmidinn(p5)
iFreq3 = cpsmidinn(p6)
iFreq4 = cpsmidinn(p7)

; PWM for each voice
kPwm1 lfo 0.45, random:i(0.08, 0.15), 0
kPwm1 = kPwm1 + 0.5  ; 0.05 to 0.95 duty cycle

aPwm1 vco2 kAmp * kEnv * 0.25, iFreq1, 2, kPwm1
; ... repeat for 4 voices

aMix = aPwm1 + aPwm2 + aPwm3 + aPwm4
endin
```

**PWM Theory:**

- Variable pulse width creates timbral richness
- Slow LFO modulation prevents static sound
- 4 voices = lush pad texture

### 5. Cricket (High Frequency Modulation)

```csound
instr Cricket
iFreq random 4500, 8500         ; Very high pitch

; Frequency modulation (chirp effect)
iFreqMod random 200, 600
kChirp lfo 1, random:i(30, 60), 0
kChirp = abs(kChirp) * iFreqMod
kFreq = iFreq + kChirp

; Generate tone
aTone poscil kAmp * kEnv, kFreq

; Extensive panning (3-point + 2 LFOs)
iPanStart random 0.1, 0.9
iPanMid random 0.1, 0.9
iPanEnd random 0.1, 0.9
kPan1 linseg iPanStart, iDur*0.3, iPanMid, iDur*0.7, iPanEnd
kPanLfo1 lfo 0.25, random:i(0.5, 1.8)
kPanLfo2 lfo 0.15, random:i(1.2, 3.5), 0.5
kPan = kPan1 + kPanLfo1 + kPanLfo2 * 0.8
endin
```

**Spatial Design:**

- 3-point linear panning path
- 2 LFOs add complexity
- Creates immersive outdoor ambience

### 6. Water Drip (Sparse, High-Pitched)

```csound
instr WaterDrip
iFreq random 1200, 2800         ; High metallic pitch

; Very short envelope (0.08-0.18 seconds)
kEnv expseg 0.001, 0.001, 1, iDur*0.2, 0.3,
            iDur*0.6, 0.1, 0.001

; FM for metallic quality
iModRatio random 3, 8
iModIndex random 2, 5
aMod poscil iModIndex * kEnv * iFreq, iFreq * iModRatio
aDrip poscil kAmp * kEnv, iFreq + aMod
endin
```

**Composition Pattern:**

```javascript
function composeWater() {
  // 1-3 drips
  const dur = rand(0.08, 0.18);
  csound.inputMessage(`i "WaterDrip" 0 ${dur} ${amp}`);

  // Sparse: 4-12 seconds between drip sequences
  setTimeout(composeWater, rand(4000, 12000));
}
```

### 7. Crackling Fire (Multi-Layer)

```csound
instr CracklingFire
; Layer 1: High crackling (dust2 = random impulses)
kCrackleRate1 lfo 12, random:i(0.8, 3.2), 2
kCrackleRate1 = abs(kCrackleRate1) + 5
aCrackle1 dust kAmp * 0.8, kCrackleRate1 * 95
aCrackle1 butterbp aCrackle1, random:i(400, 1800),
                             random:i(600, 1200)

; Layer 2: Mid crackling
aCrackle2 dust kAmp * 0.6, kCrackleRate2 * 120
aCrackle2 butterbp aCrackle2, random:i(800, 2500),
                             random:i(400, 900)

; Layer 3: Low rumble
aCrackle3 dust kAmp * 0.4, random:i(60, 150)
aCrackle3 butterbp aCrackle3, random:i(200, 600),
                             random:i(300, 700)

; Wind layer (pink noise)
aWind pinker
aWind = aWind * kAmp * kWindRate * 0.4
aWind butterbp aWind, random:i(200, 800),
                      random:i(300, 600)

; Air layer (white noise)
aAir noise kAmp * 0.25, 0.5
aAir butterbp aAir, random:i(500, 2000),
                    random:i(800, 1500)

; Mix all layers
aFire = aCrackle1 + aCrackle2 + aCrackle3 + aWind + aAir
endin
```

**Why This Works:**

- `dust` opcode = random impulses (crackling)
- Bandpass filters isolate frequency ranges
- Pink noise = wind
- White noise = air movement
- Multiple layers = realistic fire texture

---

## Visual System (Three.js)

### Scene Setup

```javascript
function initThreeJS() {
  scene = new THREE.Scene();
  scene.background = null; // Transparent (CSS background shows through)
  scene.fog = new THREE.Fog(0x050510, 400, 2000); // Depth cue

  camera = new THREE.PerspectiveCamera(
    75,
    window.innerWidth / window.innerHeight,
    0.1,
    2500,
  );
  camera.position.z = 300;

  renderer = new THREE.WebGLRenderer({
    antialias: true,
    alpha: true, // Transparent background
  });
  renderer.setSize(window.innerWidth, window.innerHeight);

  // Three colored point lights
  const light1 = new THREE.PointLight(0x6699ff, 1.5, 800);
  light1.position.set(200, 200, 200);
  scene.add(light1);
  // ... add light2 and light3
}
```

### Particle System

```javascript
function createParticles() {
  particleCount = 333 + Math.floor(Math.random() * 3000); // 333-3333

  for (let i = 0; i < particleCount; i++) {
    // Choose layer based on audio level (weighted random)
    const layer = chooseLayerByAudioLevel();
    const color = layerColors[layer];

    // Create geometry (6 shape options)
    let geometry;
    switch (currentShape) {
      case "sphere":
        geometry = new THREE.SphereGeometry(1, 8, 8);
        break;
      case "cube":
        geometry = new THREE.BoxGeometry(1, 1, 1);
        break;
      case "tetra":
        geometry = new THREE.TetrahedronGeometry(1);
        break;
      case "octa":
        geometry = new THREE.OctahedronGeometry(1);
        break;
      case "torus":
        geometry = new THREE.TorusGeometry(0.5, 0.2, 8, 12);
        break;
      case "cone":
        geometry = new THREE.ConeGeometry(0.5, 1, 8);
        break;
    }

    // Create material with HSL color
    const material = new THREE.MeshPhongMaterial({
      color: new THREE.Color().setHSL(color.h, color.s, color.l),
      emissive: new THREE.Color().setHSL(color.h, color.s, color.l * 0.3),
      shininess: 30,
    });

    const mesh = new THREE.Mesh(geometry, material);

    // Random position in sphere
    const theta = Math.random() * Math.PI * 2;
    const phi = Math.acos(2 * Math.random() - 1);
    const radius = Math.random() * 200;
    mesh.position.x = radius * Math.sin(phi) * Math.cos(theta);
    mesh.position.y = radius * Math.sin(phi) * Math.sin(theta);
    mesh.position.z = radius * Math.cos(phi);

    // Store metadata
    mesh.userData = {
      layer: layer,
      velocity: new THREE.Vector3(
        rand(-0.3, 0.3),
        rand(-0.3, 0.3),
        rand(-0.3, 0.3),
      ),
      rotationSpeed: new THREE.Vector3(
        rand(-0.02, 0.02),
        rand(-0.02, 0.02),
        rand(-0.02, 0.02),
      ),
      originalOpacity: 0, // Fade in from invisible
    };

    material.transparent = true;
    material.opacity = 0;

    particles.push(mesh);
    scene.add(mesh);
  }
}
```

### Flocking Algorithm

```javascript
function animateThreeJS() {
  const time = Date.now() * 0.001;

  for (const mesh of particles) {
    const layer = mesh.userData.layer;
    const audioLevel = layerAudioLevels[layer] || 0;

    // 1. FADE IN (2-6 seconds after start)
    if (fadeStartTime && time - fadeStartTime > 2) {
      const fadeProgress = Math.min(1, (time - fadeStartTime - 2) / 4);
      mesh.material.opacity = fadeProgress;
    }

    // 2. AUDIO REACTIVITY
    // Scale: 1.0 + audioLevel * 8 (up to 9x size at loud peaks)
    const scale = 1 + audioLevel * 8;
    mesh.scale.set(scale, scale, scale);

    // Speed boost: 10x normal speed when loud
    const speedMultiplier = 1 + audioLevel * 10;

    // 3. FLOCKING BEHAVIOR
    // Cohesion: move toward layer centroid
    const layerCentroid = calculateLayerCentroid(layer);
    const toCentroid = layerCentroid.clone().sub(mesh.position);
    const cohesionForce = toCentroid.multiplyScalar(0.0005);

    // Separation: avoid nearby particles
    let separationForce = new THREE.Vector3(0, 0, 0);
    for (const other of particles) {
      if (other === mesh) continue;
      const distance = mesh.position.distanceTo(other.position);
      if (distance < 15) {
        const away = mesh.position.clone().sub(other.position);
        away.normalize().multiplyScalar(1 / distance);
        separationForce.add(away);
      }
    }
    separationForce.multiplyScalar(0.02);

    // Alignment: match velocity of nearby particles
    const nearbyVelocities = getNearbyVelocities(mesh, particles);
    const alignmentForce = nearbyVelocities.multiplyScalar(0.001);

    // Apply forces
    mesh.userData.velocity.add(cohesionForce);
    mesh.userData.velocity.add(separationForce);
    mesh.userData.velocity.add(alignmentForce);

    // Limit velocity
    const maxSpeed = 2.0;
    if (mesh.userData.velocity.length() > maxSpeed) {
      mesh.userData.velocity.normalize().multiplyScalar(maxSpeed);
    }

    // 4. UPDATE POSITION
    mesh.position.add(
      mesh.userData.velocity.clone().multiplyScalar(speedMultiplier),
    );

    // 5. BOUNDARY CONSTRAINT (soft sphere)
    const distFromCenter = mesh.position.length();
    const boundaryRadius = 350;
    if (distFromCenter > boundaryRadius) {
      const pushBack =
        ((distFromCenter - boundaryRadius) / distFromCenter) * 0.05;
      mesh.position.multiplyScalar(1 - pushBack);
    }

    // 6. ROTATION
    mesh.rotation.x += mesh.userData.rotationSpeed.x * speedMultiplier;
    mesh.rotation.y += mesh.userData.rotationSpeed.y * speedMultiplier;
    mesh.rotation.z += mesh.userData.rotationSpeed.z * speedMultiplier;
  }

  renderer.render(scene, camera);
  requestAnimationFrame(animateThreeJS);
}
```

**Flocking Theory (Craig Reynolds):**

- **Cohesion**: Particles attracted to group center
- **Separation**: Particles avoid crowding
- **Alignment**: Particles match neighbors' velocity
- **Audio Reactivity**: Speed and size respond to RMS levels

### Particle Fade-In System

```javascript
// Particles start invisible (opacity = 0)
// After 2 seconds of audio playing:
const fadeProgress = Math.min(1, (time - fadeStartTime - 2) / 4);
mesh.material.opacity = fadeProgress;
// Linear fade from 0 to 1 over 4 seconds (2-6 seconds after start)
```

**Why 2-Second Delay?**

- Audio needs time to build up
- Prevents visual distraction during audio fade-in
- Creates smooth, dramatic entrance

---

## User Interface Controls

### 1. Layer Volume Sliders

```javascript
function setupSliders() {
  layers.forEach((layer) => {
    const slider = document.getElementById(`slider-${layer}`);
    const volLabel = document.getElementById(`vol-${layer}`);

    // Load saved volume from localStorage
    slider.value = Math.round(volumes[layer] * 100);
    volLabel.textContent = slider.value + "%";

    slider.addEventListener("input", function () {
      const val = this.value / 100;
      volumes[layer] = val;
      volLabel.textContent = this.value + "%";
      updateEffectiveVolume(layer);
      saveSettings(); // Persist to localStorage
    });
  });
}
```

### 2. Mute/Solo Buttons

```javascript
function updateEffectiveVolume(layer) {
  let effectiveVol = volumes[layer];

  // Muted? Set to 0
  if (muteStates[layer]) {
    effectiveVol = 0;
  }
  // Solo active on another layer? Set to 0
  else if (soloLayer !== null && soloLayer !== layer) {
    effectiveVol = 0;
  }

  // Send to Csound
  if (csound) {
    csound.setControlChannel(`vol_${layer}`, effectiveVol);
  }
}

// Solo button click
if (action === "solo") {
  if (soloLayer === layer) {
    soloLayer = null; // Unsolo
  } else {
    soloLayer = layer; // Solo this layer
    triggerInstrument(layer); // Preview immediately
  }
  // Update all layers
  layers.forEach((l) => updateEffectiveVolume(l));
}
```

**Solo Logic:**

- Only ONE layer can be soloed at a time
- Soloing a layer mutes all others
- Clicking solo again turns it off

### 3. Global Dry/Effect Levels

```javascript
// Dry Level (direct instrument output)
document.getElementById("slider-dry").addEventListener("input", function () {
  const dryLevel = this.value / 100;
  csound.setControlChannel("vol_dry", dryLevel);
});

// Effect Level (reverb, delay, etc.)
document.getElementById("slider-effect").addEventListener("input", function () {
  const effectLevel = this.value / 100;
  csound.setControlChannel("vol_effect", effectLevel);
});
```

**In Csound:**

```csound
gkDryLevel chnget "vol_dry"
gkMasterVol chnget "vol_effect"

; Dry output
outs aL * 0.4 * gkMasterFade * gkDryLevel,
     aR * 0.4 * gkMasterFade * gkDryLevel

; Effect output
outs aRvbL * kMaster * gkReverbFade,
     aRvbR * kMaster * gkReverbFade
```

### 4. Random Background Switching

```javascript
function selectRandomBackground() {
  const selector = document.getElementById("background-select");

  // All backgrounds except "none"
  const allBgs = Object.keys(backgroundImages).filter((key) => key !== "none");
  const randomBg = allBgs[Math.floor(Math.random() * allBgs.length)];

  selector.value = randomBg;

  // Apply CSS background
  const container = document.getElementById("three-container");
  container.style.backgroundImage = `url('${backgroundImages[randomBg]}')`;
}

function startRandomBackgroundTimer() {
  if (randomBgEnabled) {
    selectRandomBackground(); // Change immediately
    randomBgTimer = setInterval(
      selectRandomBackground,
      randomBgInterval * 1000,
    );
  }
}
```

**Interval Control:**

- Slider: 5-120 seconds
- Only active while music is playing
- Stops automatically on stop button

### 5. TAB Key - Hide All UI

```javascript
document.addEventListener("keydown", function (e) {
  if (e.key === "Tab") {
    e.preventDefault(); // Don't focus next element
    toggleAllControls();
  }
});

function toggleAllControls() {
  const controls = document.getElementById("controls");
  const isHidden = controls.style.display === "none";
  controls.style.display = isHidden ? "block" : "none";
}
```

**Use Case:**

- Full-screen immersive experience
- Hide UI for presentations/performances
- Press TAB again to restore controls

---

## CSD Recording & Export

### Overview

The CSD recording system captures live generative performances and exports them as standalone Csound (.csd) files that can be:

- Replayed in any Csound application (Csound command line, CsoundQt, Cabbage)
- Shared with other Csound users
- Modified and studied for educational purposes
- Archived as unique compositions

### Recording Flow

```javascript
// 1. User clicks "Start CSD Recording"
function generateCsound() {
  if (!csdRecording) {
    csdRecording = true;
    csdRecordingStartTime = Date.now();

    // Build complete CSD header with orchestra code
    const csdHeader = `<CsoundSynthesizer>
      <CsOptions>
      -odac -d -m0
      </CsOptions>
      <CsInstruments>
      ${orc.trim()}
      
      ; Initialize control channels for standalone playback
      instr ChannelInit
        ${channelInits}chnset 1.0, "vol_dry"
        chnset 1.0, "vol_effect"
        turnoff
      endin
      </CsInstruments>
      <CsScore>
      ; === RECORDED PERFORMANCE ===
      ; Started: ${new Date().toISOString()}
      
      ; Initialize control channels first
      i "ChannelInit" 0 0.01
      
      ; Effect instruments (always on)
      i "GlobalFadeIn" 0 3600
      ...
      
      ; Performance notes
      `;

    output.value = csdHeader;
  }
}
```

### Note Capture System

Every time an instrument plays a note, it's automatically captured:

```javascript
// In composeFM(), composeDrone(), etc.
csound.inputMessage(`i "FM" 0 ${dur} ${note} ${amp}`);
addNoteToCSD("FM", dur, note, amp); // ← Capture to CSD

function addNoteToCSD(instrName, p3, ...pfields) {
  if (!csdRecording) return;

  // Calculate relative time since recording started
  const elapsed = (Date.now() - csdRecordingStartTime) / 1000;
  const p2 = elapsed.toFixed(3);

  // Build score statement
  const pfieldsStr = pfields.join(" ");
  const scoreStatement = `i "${instrName}" ${p2} ${p3} ${pfieldsStr}`;

  // Append to console output
  const output = document.getElementById("csdOutput");
  output.value += scoreStatement + "\n";
}
```

### Stop Recording

```javascript
function stopCSDRecording() {
  if (!csdRecording) return;
  csdRecording = false;

  // Add closing tags
  const footer = `\ne\n</CsScore>
    </CsoundSynthesizer>`;
  output.value += footer;

  // Enable download button
  document.getElementById("downloadCsdBtn").disabled = false;

  // Prompt user to download
  if (confirm("Recording stopped. Download the CSD file now?")) {
    downloadCsd();
  }
}
```

### Download System

```javascript
function downloadCsd() {
  const output = document.getElementById("csdOutput");
  if (!output.value.trim()) {
    alert("No CSD content to download");
    return;
  }

  // Generate timestamped filename
  const timestamp = new Date().toISOString().replace(/:/g, "-").split(".")[0];
  const filename = `etude1_${timestamp}.csd`;

  // Create blob and download
  const blob = new Blob([output.value], {
    type: "text/plain;charset=utf-8",
  });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = filename;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
}
```

### Example Generated CSD

```csound
<CsoundSynthesizer>
<CsOptions>
-odac -d -m0
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1
seed 0

; ... (full orchestra code) ...

instr ChannelInit
  chnset 0.50, "vol_fm"
  chnset 0.50, "vol_drone"
  ; ... all channel initializations ...
  turnoff
endin
</CsInstruments>
<CsScore>
; === RECORDED PERFORMANCE ===
; Started: 2026-03-14T12:45:30

; Initialize control channels first
i "ChannelInit" 0 0.01

; Effect instruments (always on)
i "GlobalFadeIn" 0 3600
i "MasterVolumeInit" 0 0.01
i "KillSwitch" 0 3600
i "Echo" 0 3600
i "Reverb" 0 3600
; ... more effects ...

; Performance notes
i "FM" 0.423 1.234 72 0.087
i "Drone" 1.856 7.890 47 52 59 0.120
i "Cello" 3.145 4.567 54 0.380
i "Cricket" 5.892 0.156 0.420
; ... thousands of unique notes ...

e
</CsScore>
</CsoundSynthesizer>
```

### Key Features

**1. Timing Precision:**

- Millisecond-accurate timestamps
- Preserves exact generative performance
- All notes relative to recording start

**2. Complete Portability:**

- Full orchestra code included
- All channel initializations captured
- Effect instruments always scheduled
- Standalone playback guaranteed

**3. Volume Preservation:**

- Current slider values captured at recording start
- Embedded in ChannelInit instrument
- Playback matches live performance

**4. Real-time Console:**

- Score statements visible as they're generated
- Toggle show/hide for unobstructed view
- Scrolls automatically to show latest notes

### Use Cases

**Educational:**

- Study generative composition techniques
- Analyze probabilistic note generation
- Learn Csound score syntax

**Creative:**

- Capture unique performances
- Share generative compositions
- Create variations by editing score

**Technical:**

- Debugging instrument behavior
- Performance analysis
- Archival documentation

### Technical Notes

**Why Timestamp Instead of Beat Time?**

- Generative timing is irregular
- No fixed tempo or meter
- Real-time capture more accurate

**Why Include Full Orchestra?**

- Ensures playback compatibility
- No external dependencies
- Self-documenting code

**Why Initialize Channels?**

- Browser Csound uses channels for volume
- Standalone Csound needs initialization
- ChannelInit instrument runs once at start

---

## Key Algorithms

### 1. Exponential Fade Curves

```javascript
// Linear fade: drops evenly
const linearFade = 1.0 - step / totalSteps;

// Exponential fade: drops quickly at first, then slows
const expFade = Math.pow(1.0 - step / totalSteps, 3);

// Extreme exponential: instant drop
const extremeFade = Math.pow(1.0 - step / totalSteps, 6);
```

**Used For:**

- Stop button fade-out
- Particle fade-in
- Creates more musical/natural transitions

### 2. Weighted Random Layer Selection

```javascript
function chooseLayerByAudioLevel() {
  // Build weighted array based on audio levels
  const weighted = [];
  layers.forEach((layer) => {
    const level = layerAudioLevels[layer] || 0.1;
    const weight = Math.floor(level * 100) + 1;
    for (let i = 0; i < weight; i++) {
      weighted.push(layer);
    }
  });
  return choose(weighted);
}
```

**Effect:**

- Louder layers get more particles
- Visual distribution matches audio balance
- Dynamic: changes as mix evolves

### 3. Smooth Incremental Fade (Csound)

```csound
; Problem: linseg creates audio "click" at start
; OLD:
kEnv linseg 0, 8, 1

; Solution: k-rate increment
; NEW:
gkMasterFade init 0
if gkMasterFade < 1 then
  gkMasterFade = gkMasterFade + (1.0 / (8.0 * kr))
  gkMasterFade limit gkMasterFade, 0, 1
endif
```

**Math:**

- `kr` = control rate (1378 Hz at ksmps=32)
- `1.0 / (8.0 * kr)` = increment per k-cycle
- 8 seconds × 1378 = 11,024 steps
- Each step: 0.0000907 increase
- Result: perfectly smooth fade with no click

### 4. Haas Effect (Stereo Widening)

```csound
aLDelay vdelay aL, 0.5, 5   ; Left delayed by 0.5ms
aRDelay vdelay aR, 0.7, 5   ; Right delayed by 0.7ms

aLWide = aL + aRDelay * 0.2  ; L + small amount of delayed R
aRWide = aR + aLDelay * 0.2  ; R + small amount of delayed L

aLWide limit aLWide, -0.98, 0.98  ; Prevent clipping
aRWide limit aRWide, -0.98, 0.98
```

**Psychoacoustics:**

- Delays < 5ms create stereo width, not echo
- Cross-channel bleeding adds spaciousness
- 20% mix prevents phasing issues
- Limit to ±0.98 prevents clipping

---

## Performance Optimization

### 1. Async/Sync Split

**Problem:**

- `csound.getControlChannel()` returns Promise
- `requestAnimationFrame()` must be synchronous for 60fps

**Solution:**

```javascript
// Async loop: Updates audio levels (50ms = 20 Hz)
setInterval(async () => {
  for (const layer of layers) {
    const rms = await csound.getControlChannel(`rms_${layer}`);
    layerAudioLevels[layer] = rms; // Store in object
  }
}, 50);

// Sync loop: Reads from object (16.67ms = 60 Hz)
function animateThreeJS() {
  for (const mesh of particles) {
    const level = layerAudioLevels[mesh.userData.layer]; // Sync read
    mesh.scale.set(level * 8, level * 8, level * 8);
  }
  requestAnimationFrame(animateThreeJS);
}
```

### 2. Timer Cleanup

```javascript
// Store all setTimeout IDs
composerTimers.push(timer);

// On stop: Clear ALL timers
composerTimers.forEach((timer) => clearTimeout(timer));
composerTimers = [];
```

**Why Critical:**

- Prevents memory leaks
- Stops scheduled notes from firing after stop
- Essential for clean stop behavior

### 3. Particle Count

- **Range:** 333-3333 particles
- **Step:** 33 (for slider granularity)
- **Trade-off:**
  - More particles = more visually interesting
  - Fewer particles = better performance on weak GPUs
- **Solution:** User-controllable slider

---

## Musical Design Decisions

### 1. Why B Phrygian?

```
B C D E F# G A B
  ½ 1 1 1  ½ 1
```

- **Half-step at root:** Creates tension, dark quality
- **Minor mode:** Somber, introspective
- **Exotic:** Less common than natural minor
- **Works well for ambient:** Avoids strong tonal pull

### 2. Why 14 Layers?

Each layer fills a specific sonic role:

| Layer     | Role                  | Frequency Range |
| --------- | --------------------- | --------------- |
| FM Synth  | High bells            | 1000-4000 Hz    |
| Marimba   | Low percussion        | 130-500 Hz      |
| Drone     | Harmonic foundation   | 80-300 Hz       |
| Rumble    | Sub-bass texture      | 20-100 Hz       |
| BellChord | Mid-high harmony      | 300-1500 Hz     |
| PWM       | Pad/atmosphere        | 150-800 Hz      |
| Thunder   | Low drama             | 20-150 Hz       |
| Flute     | Melodic phrases       | 500-2000 Hz     |
| Cello     | Low melody            | 100-600 Hz      |
| Cricket   | High ambience         | 4500-8500 Hz    |
| Bird      | Mid-high chirps       | 2000-5000 Hz    |
| Water     | High metallic         | 1200-2800 Hz    |
| Fire      | Full-spectrum texture | 60-2500 Hz      |
| Noise     | Atmospheric wash      | 100-400 Hz (LP) |

**Result:** Full-spectrum coverage, no frequency masking

### 3. Why Autonomous Composition?

**Traditional Approach:**

```javascript
// Fixed sequence - boring!
function playPiece() {
  csound.inputMessage('i "FM" 0 2 60 0.1');
  csound.inputMessage('i "FM" 2 1.5 64 0.08');
  csound.inputMessage('i "FM" 3.5 2 67 0.12');
}
```

**Generative Approach:**

```javascript
// Self-scheduling - never repeats!
function composeFM() {
  const note = choose(scale); // Random selection
  const dur = rand(0.2, 1.2); // Random duration
  const amp = rand(0.04, 0.1); // Random amplitude

  csound.inputMessage(`i "FM" 0 ${dur} ${note} ${amp}`);
  setTimeout(composeFM, rand(400, 3000)); // Random next time
}
```

**Benefits:**

- Never repeats exactly
- Always evolving
- Infinite duration
- Maintains coherence (uses same scale)

---

## Effects Routing Architecture

### Effect Bus System

```csound
; Global buses (initialized to 0)
gaRvbL init 0           ; Main reverb
gaEchoL init 0          ; Echo/delay
gaBellShimL init 0      ; Bell shimmer
gaPwmRvbL init 0        ; PWM reverb
gaFluteRvbL init 0      ; Flute reverb
gaCelloRvbL init 0      ; Cello reverb
gaAmbienceL init 0      ; Ambience reverb
gaCricketDelL init 0    ; Cricket delay
gaShimmerL init 0       ; Water shimmer
gaEchoL init 0          ; Fire echo

; Instruments send to buses:
gaRvbL = gaRvbL + aL * 0.3   ; 30% to reverb

; Effect instruments read from buses:
instr Reverb
aInL = gaRvbL
aInR = gaRvbR

; Process...
aRvbL, aRvbR reverbsc aInL, aInR, 0.85, 12000

; Output
outs aRvbL * kMaster * gkReverbFade,
     aRvbR * kMaster * gkReverbFade

; Clear buses for next cycle
gaRvbL = 0
gaRvbR = 0
endin
```

**Architecture:**

1. Instruments **write** to buses (+=)
2. Effect instruments **read** from buses (=)
3. Effect instruments **clear** buses (= 0)
4. Cycle repeats every k-cycle (1378 Hz)

### Effect Types

**Reverb:**

```csound
aRvbL, aRvbR reverbsc aInL, aInR, kFeedback, kCutoff
; reverbsc = Schroeder reverb, stereo
; kFeedback = 0.85 (85% reflections)
; kCutoff = 12000 Hz (darker, more natural)
```

**Shimmer:**

```csound
; Pitch shift up 1 octave
aPitchL poscil aInL * 0.35, iFreq * 2
; Mix with original + reverb
aMix = aInL + aPitchL + aRvb
```

**Ping-Pong Delay:**

```csound
aPingL delay aInR, 0.11   ; R → L (110ms)
aPongR delay aInL, 0.13   ; L → R (130ms)
aPingL2 delay aPongR, 0.19
aPongR2 delay aPingL, 0.21
; Creates bouncing stereo effect
```

---

## Troubleshooting Guide

### Common Issues

**1. No Sound**

- Check: Browser console for Csound load errors
- Check: Audio context started (requires user gesture)
- Check: Volume sliders not at 0
- Check: Not muted/soloed incorrectly

**2. Delayed "Explosion" After Stop**

- Cause: Scheduled Csound events not cancelled
- Fix: Kill switch instrument uses `turnoff2`
- Verify: `kill_switch` channel set to 0

**3. Particles Not Moving**

- Check: `isPlaying === true`
- Check: `fadeStartTime` is set
- Check: Audio levels being read (check `layerAudioLevels`)

**4. Background Image Not Loading**

- Check: Browser console for CORS errors
- Check: Unsplash URLs are accessible
- Try: Different image (some may be removed)

**5. UI Not Responding**

- Check: JavaScript errors in console
- Check: Element IDs match (case-sensitive)
- Try: Refresh page, clear cache

---

## Future Enhancement Ideas

### Audio Enhancements

1. **More Effects:** Chorus, phaser, granular synthesis
2. **MIDI Input:** Play scales with keyboard
3. **Recording:** Export to WAV file
4. **Presets:** Save/load complete mix states
5. **Automation:** LFO control of parameters

### Visual Enhancements

1. **Particle Trails:** Comet/energy effects
2. **Camera Movement:** Slow orbit around particles
3. **Color Schemes:** User-selectable palettes
4. **Post-Processing:** Bloom, motion blur
5. **VR Support:** Immersive 360° experience

### Interaction Enhancements

1. **Touch Gestures:** Swipe to change backgrounds
2. **Voice Control:** "Stop", "Change background"
3. **MIDI Mapping:** Hardware controllers
4. **Multi-User:** Collaborative composition over network
5. **AI Assistance:** Machine learning for composition

---

## Code Style & Conventions

### Naming Conventions

**JavaScript:**

- `camelCase` for variables/functions
- `UPPER_SNAKE_CASE` for constants
- Descriptive names (no single letters except loops)

**Csound:**

- `i` prefix = i-rate (initialization)
- `k` prefix = k-rate (control)
- `a` prefix = a-rate (audio)
- `g` prefix = global
- `ga` prefix = global audio bus
- `gk` prefix = global k-rate

### Code Organization

1. **HTML Structure** (top)
2. **CSS Styling** (middle)
3. **JavaScript:**
   - Variables & constants
   - Csound orchestra code (string)
   - Utility functions
   - Composer functions
   - UI event handlers
   - Initialization
4. **Execution** (bottom)

### Comments

- Use `//` for single-line JavaScript
- Use `;` for single-line Csound
- Document WHY, not WHAT
- Explain complex algorithms
- Mark sections with headers

---

## Performance Metrics

**Typical Resource Usage:**

- **CPU:** 15-30% (varies with particle count)
- **RAM:** 150-250 MB
- **GPU:** Low (simple geometries, basic lighting)
- **Network:** ~2-5 MB initial load (Csound WASM)

**Optimization Tips:**

1. Reduce particle count (333 instead of 3333)
2. Simplify particle geometry (spheres fastest)
3. Lower sample rate (22050 instead of 44100)
4. Increase ksmps (64 instead of 32)
5. Disable reverb on some layers

---

## Credits & Technologies

**Built With:**

- **Csound WASM** (6.18) - Audio synthesis
- **Three.js** (r128) - 3D graphics
- **Unsplash** - Background imagery
- **Web Audio API** - Audio analysis
- **HTML5 Canvas** - Rendering

**Inspired By:**

- Brian Eno - Generative music
- Craig Reynolds - Flocking algorithms
- Pauline Oliveros - Deep listening
- Karlheinz Stockhausen - Spatial music

**Synthesis Techniques From:**

- John Chowning - FM synthesis
- Barry Truax - Granular synthesis
- Curtis Roads - Microsound
- Richard Boulanger - Csound mastery

---

## Conclusion

**Etude#1** demonstrates how modern web technologies can create sophisticated generative music systems without plugins or external software. The combination of:

- **Csound's powerful synthesis** (60+ years of development)
- **Three.js's visual capabilities** (WebGL made easy)
- **JavaScript's flexibility** (async, events, DOM manipulation)

...creates a rich, immersive experience that runs entirely in the browser.

The key innovations:

1. **Async/Sync Split** for smooth audio-reactive visuals
2. **Kill Switch** for instant, clean stopping
3. **Autonomous Composers** for infinite variation
4. **Flocking Particles** for organic movement
5. **Effect Bus Architecture** for professional mixing

This codebase can serve as a foundation for:

- Educational exploration of synthesis
- Live performance systems
- Interactive installations
- Meditation/ambient experiences
- Creative coding experiments

**The code is the composition.** 🎵✨

---

_Document created: February 2026_  
_Etude#1 Version: 5.1_  
_Total Lines of Code: ~3,700_  
_Instruments: 14_  
_Effects: 10_  
_Particles: 333-3333_  
_Background Images: 45_

---

## Appendix A: Complete Instrument List

| #   | Name        | Type              | Frequency    | Character         |
| --- | ----------- | ----------------- | ------------ | ----------------- |
| 1   | FM          | FM Synthesis      | 1000-4000 Hz | Bright bells      |
| 2   | Marimba     | FM Synthesis      | 130-500 Hz   | Woody percussion  |
| 3   | Drone       | 3-Voice FM        | 80-300 Hz    | Thick pad         |
| 4   | Noise Swell | Filtered Noise    | 100-400 Hz   | Atmospheric       |
| 5   | Rumble      | Sub Bass          | 20-100 Hz    | Deep foundation   |
| 6   | BellChord   | 3-Voice FM        | 300-1500 Hz  | Harmonic bells    |
| 7   | PWM Chord   | PWM Synthesis     | 150-800 Hz   | Lush pad          |
| 8   | Low Thunder | Filtered Noise    | 20-150 Hz    | Dramatic low end  |
| 9   | Flute       | FOF Synthesis     | 500-2000 Hz  | Breathy melody    |
| 10  | Cello       | Sawtooth + Filter | 100-600 Hz   | Rich strings      |
| 11  | Cricket     | FM + Modulation   | 4500-8500 Hz | Night ambience    |
| 12  | Bird        | Chirp Algorithm   | 2000-5000 Hz | Nature sounds     |
| 13  | Water Drip  | High FM           | 1200-2800 Hz | Metallic drops    |
| 14  | Fire        | Multi-Layer Noise | 60-2500 Hz   | Crackling texture |

## Appendix B: Effect Chain Routing

```
FM       ──30%──┐
Drone    ──60%──┤
Noise    ──50%──┤
Rumble   ──60%──┼──► Main Reverb (reverbsc, 85%, 12kHz)
Thunder  ──40%──┤
Marimba  ──25%──┘

BellChord ─────► Bell Shimmer (shimmer + delay + reverb 92%)
PWM Chord ─────► PWM Freeverb (freeverb 88%)
Flute     ─────► Flute Network (chorus + delay + reverb 88%)
Cello     ─────► Cello Network (3x chorus + delay + reverb 90%)
Cricket   ─────► Multitap Delay + Ambience Reverb (94%)
Bird      ─────► Ambience Reverb (93%)
Water     ─────► Water Shimmer (shimmer + delay + reverb 92%)
Fire      ─────► Fire Echo (stereo cross-delay 180/240ms)
```

## Appendix C: Keyboard Shortcuts

| Key                        | Action           |
| -------------------------- | ---------------- |
| TAB                        | Hide/Show All UI |
| (Space planned for future) | Play/Pause       |
| (Esc planned for future)   | Stop             |

## Appendix D: localStorage Keys

```javascript
// Volume settings (0-1 float)
localStorage.setItem("vol_fm", "0.5");
localStorage.setItem("vol_drone", "0.5");
// ... all 14 layers

// Particle settings
localStorage.setItem("particleCount", "1100");
localStorage.setItem("currentShape", "sphere");

// Background settings
localStorage.setItem("selectedBackground", "nebula2");
localStorage.setItem("randomBgEnabled", "false");
localStorage.setItem("randomBgInterval", "30");
```

---

**End of Documentation**
