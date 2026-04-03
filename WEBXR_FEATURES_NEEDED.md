# WebXR Missing Features

## Current Status

The Quest 3 WebXR version (`Etude1-Quest3-WebXR.html`) currently has:

- ✅ 3D particle system with instanced meshes
- ✅ Hand tracking support
- ✅ Teleportation system
- ✅ 3D UI control panel for volume
- ✅ VR optimizations (foveated rendering, 90-120Hz)

## Missing Features

### 1. Audio System (Critical)

**Problem:** No Csound audio engine integrated
**Solution Needed:**

- Load Csound WASM library (`@csound/browser`)
- Compile the full orchestra (2800+ lines)
- Implement 14 generative composer functions
- Start/Stop audio controls
- Audio level reading for particle reactivity

### 2. Background Images

**Problem:** Only procedural gradient skybox
**Solution Needed:**

- Background image selector in VR UI
- Load external JPG images for skybox
- Multiple categories (nebulae, planets, landscapes, etc.)
- Rotation control

## Quick Fix Recommendations

### For Testing on Quest 3:

1. **Start with desktop version** to verify audio works
2. **Use simplified VR version** without full Csound (simulated audio for now)
3. **Add audio incrementally** once VR interaction is confirmed working

### Simplest Path Forward:

Create a hybrid version:

- Keep current VR UI and controls
- Add "Start Audio" button that loads Csound
- Use simpler skybox with fewer options
- Connect volume sliders to actual Csound channels

## File Size Concern

Adding full Csound integration would make the HTML file **~4000+ lines**.
Consider splitting into:

- `etude1-vr-core.html` (minimal VR)
- `etude1-vr-full.html` (with Csound)
