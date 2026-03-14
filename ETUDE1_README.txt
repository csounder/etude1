═══════════════════════════════════════════════════════════════
  ETUDE#1 by Dr.C - README
═══════════════════════════════════════════════════════════════

Thank you for downloading Etude#1! This is a generative audio-visual
composition that creates unique music every time you run it.

═══════════════════════════════════════════════════════════════
  QUICK START
═══════════════════════════════════════════════════════════════

1. Extract all files from the zip archive
2. Open ONE of these HTML files in your browser:
   
   FOR DESKTOP/LAPTOP:
   → ETUDE1_v5.1_PERFECT_LABELS.html (full experience)
   
   FOR MOBILE/TABLET:
   → ETUDE1_MOBILE_OPTIMIZED.html (optimized performance)
   
   LANDING PAGE:
   → ETUDE1_LANDING_PAGE.html (information & links)

3. Click "Start Experience" when ready
4. Put on headphones for best spatial audio effect
5. Listen for at least 5-10 minutes to experience the evolving composition

═══════════════════════════════════════════════════════════════
  WHAT'S INCLUDED
═══════════════════════════════════════════════════════════════

📄 ETUDE1_v5.1_PERFECT_LABELS.html
   Main experience file - optimized for desktop/laptop
   Full particle count (up to 3333 particles)
   Best performance on modern computers

📄 ETUDE1_MOBILE_OPTIMIZED.html
   Mobile/tablet version with reduced particle count
   Optimized for phones and tablets
   Max 1333 particles for smooth 30+ fps

📄 ETUDE1_LANDING_PAGE.html
   Informational landing page
   Links to both versions
   Technical specifications

📄 ETUDE1_README.txt
   This file - setup and usage instructions

📄 ETUDE1_CODE_DOCUMENTATION.md (if included)
   Complete technical documentation
   Synthesis techniques explained
   Algorithm details

═══════════════════════════════════════════════════════════════
  BROWSER REQUIREMENTS
═══════════════════════════════════════════════════════════════

✓ Modern browser (2020 or newer):
  - Google Chrome (recommended)
  - Mozilla Firefox
  - Microsoft Edge
  - Safari (macOS/iOS)

✓ JavaScript enabled
✓ Web Audio API support (standard in all modern browsers)
✓ WebGL support for 3D graphics

FIRST RUN: The browser will download Csound WebAssembly (~2MB)
This happens once, then it's cached for future use.

═══════════════════════════════════════════════════════════════
  CONTROLS & FEATURES
═══════════════════════════════════════════════════════════════

MAIN CONTROLS:
• Start / Stop buttons
• TAB key = Hide/show all UI
• Hide Sliders = Show/hide detailed controls

CSD RECORDING (NEW!):
• Start CSD Recording - Capture your performance to .csd file
• Stop Recording - Finalize the recording
• Download .CSD File - Save for use in any Csound application
• Show/Hide Console - View the generated score in real-time

AUDIO MIXING:
• 14 individual layer volume sliders
• Mute (M) and Solo (S) buttons for each layer
• Global Dry/Effect level controls

VISUAL CONTROLS:
• Particle count (3-3333 on desktop, 3-1333 on mobile)
• 6 particle shapes: Sphere, Cube, Tetra, Octa, Torus, Cone
• 45 background images across 6 categories
• Random background switching with interval control
• Rotation speed adjustment

LAYERS:
1. FM Synth - High bells (2 octaves up)
2. Marimba - Low woody percussion
3. Drone - 3-voice FM pad
4. Noise Swell - Atmospheric wash
5. Low Rumble - Sub-bass foundation
6. Shimmer Bell - 3-note FM chords
7. PWM Chord - 4-note pulse width modulation
8. Low Thunder - Filtered pink noise
9. Flute - FOF synthesis
10. Cello - Sawtooth + filter
11. Cricket - High frequency chirps
12. Bird - Chirping patterns
13. Water Drips - Sparse drip sounds
14. Crackling Fire - 5-layer fire soundscape

═══════════════════════════════════════════════════════════════
  PERFORMANCE TIPS
═══════════════════════════════════════════════════════════════

DESKTOP/LAPTOP:
✓ Use 1000-2000 particles for balanced performance/visuals
✓ Close other browser tabs for best performance
✓ Full screen the browser for immersive experience
✓ Connect good speakers or headphones

MOBILE/TABLET:
✓ Use the mobile-optimized version
✓ Start with 300-500 particles, adjust as needed
✓ Landscape orientation recommended
✓ Use headphones for spatial effects
✓ Close background apps
✓ Keep device plugged in (audio synthesis uses CPU)

IF PERFORMANCE IS SLOW:
1. Reduce particle count (drag slider left)
2. Switch to simpler particle shape (Sphere is fastest)
3. Close other browser tabs/apps
4. Use mobile-optimized version on tablets

═══════════════════════════════════════════════════════════════
  TECHNICAL DETAILS
═══════════════════════════════════════════════════════════════

AUDIO ENGINE:
• Csound 6.18 (compiled to WebAssembly)
• Real-time synthesis at 44.1kHz, 32-sample buffer
• 14 concurrent instruments with autonomous composers
• 10 effect processors (reverbs, delays, shimmer, chorus, etc.)
• Haas stereo widening on key layers

VISUAL ENGINE:
• Three.js r128 for 3D rendering
• Reynolds flocking algorithm for particle behavior
• Audio-reactive speed (10×) and size (8×) modulation
• 14 color-coded layer groups

COMPOSITION:
• Mode: B Phrygian (B C# D E F# G# A)
• Recursive autonomous composers with probabilistic note generation
• No two performances are exactly alike
• Emergent musical structures from independent layer interactions

ARCHITECTURE:
• Pure client-side (no server required)
• All dependencies loaded from CDN
• Settings persist via localStorage
• Works offline after first load (Csound WASM cached)

═══════════════════════════════════════════════════════════════
  TROUBLESHOOTING
═══════════════════════════════════════════════════════════════

PROBLEM: No audio playing
SOLUTION:
→ Make sure you clicked "Start Experience" button
→ Check device volume and browser audio permissions
→ On iOS: Check mute switch and rotation lock
→ Try reloading the page
→ Try a different browser (Chrome recommended)

PROBLEM: Page loads forever / stuck on "Initializing..."
SOLUTION:
→ Wait 10-30 seconds (Csound WASM is downloading)
→ Check internet connection
→ Clear browser cache and reload
→ Try incognito/private browsing mode
→ Disable browser extensions that block scripts

PROBLEM: Particles are laggy or choppy
SOLUTION:
→ Reduce particle count (drag slider to left)
→ Switch to Sphere shape (simplest geometry)
→ Close other browser tabs and apps
→ Use mobile-optimized version
→ Update your browser to latest version

PROBLEM: Audio is distorted or crackling
SOLUTION:
→ Reduce some layer volumes (especially Cricket, Fire, Thunder)
→ Lower Effect Level slider
→ Close other audio applications
→ Restart browser
→ Try increasing browser audio buffer (advanced)

PROBLEM: UI controls are tiny on mobile
SOLUTION:
→ Use landscape orientation
→ Zoom in with pinch gesture if needed
→ Use "Hide Sliders" to simplify interface
→ Use TAB shortcut to hide all controls temporarily

═══════════════════════════════════════════════════════════════
  ABOUT THIS WORK
═══════════════════════════════════════════════════════════════

CONCEPT:
Etude#1 explores autonomous generative systems in music composition.
Fourteen instrumental "agents" inhabit a shared harmonic space, each
making independent decisions about timing, pitch selection, and
articulation. The result is music that evolves continuously, creating
unique performances that never repeat exactly.

The visual component creates a tight coupling between sound and image—
thousands of particles respond to audio energy levels in real-time,
using flocking behaviors to create organic, lifelike motion patterns.

COMPOSER:
Richard Boulanger

TECHNICAL COLLABORATOR:
Dr.C (AI Assistant specializing in Csound programming)

TECHNOLOGY:
• Csound (csound.com) - Real-time audio synthesis language
• Three.js (threejs.org) - 3D graphics library
• WebAssembly - High-performance web execution

YEAR:
2026

═══════════════════════════════════════════════════════════════
  SHARING & CREDITS
═══════════════════════════════════════════════════════════════

This work is provided for personal enjoyment and educational purposes.

If you share or present this work:
• Credit: "Etude#1 by Richard Boulanger & Dr.C"
• Mention the use of Csound and Three.js technologies
• Link back to original source if available

For academic use, performances, or adaptations, please contact
the composer.

═══════════════════════════════════════════════════════════════
  LISTENING SUGGESTIONS
═══════════════════════════════════════════════════════════════

FIRST LISTENING:
• Find a quiet space
• Use good headphones or speakers
• Start with all layers enabled (default settings)
• Listen for at least 10 minutes
• Let the piece evolve—it takes time to hear the patterns

EXPLORING LAYERS:
• Use Solo (S) buttons to isolate individual instruments
• Notice how each layer has its own timing and behavior
• Try muting certain layers to hear how they interact
• Experiment with different layer combinations

VISUAL EXPLORATION:
• Try different particle shapes—each has unique character
• Watch how particles respond to different instruments
• Switch backgrounds to change the mood
• Enable random background changes for evolving visuals
• Hide UI (TAB) for fully immersive experience

RECORDING YOUR PERFORMANCE:
• Click "Start CSD Recording" before or during playback
• All notes are captured with precise timing
• Click "Stop Recording" when finished
• Download the .csd file to replay in Csound, CsoundQt, or Cabbage
• Share your unique performance with other Csound users

EXTENDED LISTENING:
• The piece can run indefinitely
• Patterns emerge and evolve over 30-60 minute sessions
• Each listening session will be different
• Try different times of day for different moods

═══════════════════════════════════════════════════════════════
  FURTHER RESOURCES
═══════════════════════════════════════════════════════════════

LEARN MORE ABOUT THE TECHNOLOGIES:

Csound:
• Official site: csound.com
• Community: csound.com/community.html
• Book: "The Csound Book" (MIT Press)

Three.js:
• Official site: threejs.org
• Documentation: threejs.org/docs
• Examples: threejs.org/examples

Generative Music:
• Brian Eno: "Generative Music" essay
• Curtis Roads: "Microsound" (MIT Press)
• David Cope: "Computer Models of Musical Creativity"

Algorithmic Composition:
• "Algorithmic Composition" by Eduardo Reck Miranda
• "The Computer Music Tutorial" by Curtis Roads
• Xenakis: "Formalized Music"

═══════════════════════════════════════════════════════════════
  SUPPORT
═══════════════════════════════════════════════════════════════

For technical questions or issues:
• Check the HOSTING_GUIDE.txt for troubleshooting
• Read ETUDE1_CODE_DOCUMENTATION.md for implementation details
• Visit Csound community forums for Csound-specific questions
• Visit Three.js discourse for visualization questions

═══════════════════════════════════════════════════════════════

Enjoy your journey through generative soundscapes!

═══════════════════════════════════════════════════════════════
