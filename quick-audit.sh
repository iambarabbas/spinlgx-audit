#!/bin/bash

echo "SpinLGX Redesign Quick Audit"
echo "============================="
echo ""

URL="https://www.spinlgx.com"
HTML=$(curl -sL "$URL")

echo "📊 SEO & META"
echo "─────────────────────────"

# Title
TITLE=$(echo "$HTML" | grep -o '<title[^>]*>[^<]*</title>' | sed 's/<[^>]*>//g')
echo "Title: $TITLE"
echo "Title Length: ${#TITLE} chars"

# Meta description
META_DESC=$(echo "$HTML" | grep -i 'meta name="description"' | grep -o 'content="[^"]*"' | cut -d'"' -f2)
if [ -z "$META_DESC" ]; then
    echo "Meta Description: ❌ MISSING"
else
    echo "Meta Description: $META_DESC"
    echo "Description Length: ${#META_DESC} chars"
fi

# H1 count
H1_COUNT=$(echo "$HTML" | grep -o '<h1[^>]*>' | wc -l | tr -d ' ')
echo "H1 Tags: $H1_COUNT"

# Images
IMG_COUNT=$(echo "$HTML" | grep -o '<img ' | wc -l | tr -d ' ')
echo "Images: $IMG_COUNT"

# Canonical
CANONICAL=$(echo "$HTML" | grep 'rel="canonical"' | grep -o 'href="[^"]*"' | cut -d'"' -f2)
if [ -z "$CANONICAL" ]; then
    echo "Canonical: ❌ MISSING"
else
    echo "Canonical: $CANONICAL"
fi

echo ""
echo "📝 CONTENT"
echo "─────────────────────────"

# Word count (rough)
WORD_COUNT=$(echo "$HTML" | sed 's/<[^>]*>//g' | wc -w | tr -d ' ')
echo "Approximate Word Count: $WORD_COUNT"

# Check for AI buzzwords
echo ""
echo "🤖 AI BUZZWORD CHECK"
echo "─────────────────────────"
BUZZWORDS=("leverage" "unlock" "seamless" "robust" "innovative" "cutting-edge" "streamline" "optimize" "revolutionize" "empower" "synergy" "ecosystem")

for word in "${BUZZWORDS[@]}"; do
    COUNT=$(echo "$HTML" | grep -io "$word" | wc -l | tr -d ' ')
    if [ "$COUNT" -gt 0 ]; then
        echo "  '$word': $COUNT times"
    fi
done

echo ""
echo "⚙️  TECHNICAL"
echo "─────────────────────────"

# Platform detection
if echo "$HTML" | grep -q "wp-content"; then
    echo "Platform: WordPress ✅"
    
    if echo "$HTML" | grep -q "elementor"; then
        echo "Page Builder: Elementor"
    elif echo "$HTML" | grep -q "divi"; then
        echo "Page Builder: Divi"
    elif echo "$HTML" | grep -q "wp-bakery"; then
        echo "Page Builder: WPBakery"
    else
        echo "Page Builder: WordPress Block Editor (Gutenberg)"
    fi
else
    echo "Platform: Unknown / Custom"
fi

# External scripts
SCRIPT_COUNT=$(echo "$HTML" | grep -o '<script' | wc -l | tr -d ' ')
echo "Scripts: $SCRIPT_COUNT"

STYLE_COUNT=$(echo "$HTML" | grep -o '<style' | wc -l | tr -d ' ')
echo "Inline Styles: $STYLE_COUNT"

# HTML size
HTML_SIZE=$(echo "$HTML" | wc -c | tr -d ' ')
HTML_SIZE_KB=$((HTML_SIZE / 1024))
echo "HTML Size: ${HTML_SIZE_KB} KB"

echo ""
echo "🎨 DESIGN ELEMENTS"
echo "─────────────────────────"

# Hero section
if echo "$HTML" | grep -iq 'hero'; then
    echo "Hero Section: ✅ Detected"
else
    echo "Hero Section: Not clearly marked"
fi

# CTAs
CTA_COUNT=$(echo "$HTML" | grep -io 'button\|btn\|cta' | wc -l | tr -d ' ')
echo "CTA/Button mentions: $CTA_COUNT"

# Forms
FORM_COUNT=$(echo "$HTML" | grep -o '<form' | wc -l | tr -d ' ')
echo "Forms: $FORM_COUNT"

echo ""
echo "✅ Quick audit complete!"
