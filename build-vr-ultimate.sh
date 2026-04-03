#!/bin/bash
echo "🏗️ Building Etude#1 VR ULTIMATE..."

# Extract the full Csound orchestra from desktop version
echo "📦 Extracting Csound orchestra..."
sed -n '2126,2830p' Etude1-V5.html > /tmp/csound_orc.txt

# Extract composer functions
echo "🎼 Extracting composer functions..."
sed -n '3162,3402p' Etude1-V5.html > /tmp/composers.txt

echo "✅ Components extracted"
echo "   - Csound orchestra: $(wc -l < /tmp/csound_orc.txt) lines"
echo "   - Composers: $(wc -l < /tmp/composers.txt) lines"
echo ""
echo "⚠️  Complete file assembly requires manual integration due to complexity"
echo "    The desktop version (Etude1-V5.html) works on Quest 3 browser"
echo "    Recommendation: Use desktop version on Quest for now"

