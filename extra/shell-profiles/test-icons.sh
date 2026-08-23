#!/bin/bash
# Test script to verify that icons and fonts are working properly

echo "=== Git Workshop - Icon & Font Test ==="
echo

# Test basic Unicode symbols
echo "Basic Unicode symbols:"
echo "✓ Checkmark"
echo "✗ X mark"
echo "⚡ Lightning"
echo "🚀 Rocket"
echo "📁 Folder"
echo "📄 File"
echo

# Test Powerline symbols (commonly used in prompts)
echo "Powerline symbols:"
echo " Branch symbol"
echo " Arrow"
echo " Lock"
echo " Lightning"
echo " Gear"
echo

# Test Nerd Font symbols (if available)
echo "Nerd Font symbols (if installed):"
echo " Git branch"
echo " Folder"
echo " File"
echo " Home"
echo " Terminal"
echo

# Test font listing
if command -v fc-list >/dev/null 2>&1; then
    echo "Font management: ✓ fontconfig available"
    
    # Check for common icon fonts
    if fc-list | grep -i "powerline" >/dev/null 2>&1; then
        echo "Powerline fonts: ✓ detected"
    else
        echo "Powerline fonts: ✗ not detected"
    fi
    
    if fc-list | grep -i "awesome" >/dev/null 2>&1; then
        echo "Font Awesome: ✓ detected"
    else
        echo "Font Awesome: ✗ not detected"
    fi
    
    if fc-list | grep -i "nerd" >/dev/null 2>&1; then
        echo "Nerd Fonts: ✓ detected"
    else
        echo "Nerd Fonts: ✗ not detected"
    fi
else
    echo "Font management: ✗ fontconfig not available"
fi

echo
echo "=== Terminal Capabilities ==="
echo "TERM: $TERM"
echo "Colors: $(tput colors 2>/dev/null || echo "unknown")"

if command -v starship >/dev/null 2>&1; then
    echo "Starship: ✓ installed"
else
    echo "Starship: ✗ not installed"
fi

if command -v fzf >/dev/null 2>&1; then
    echo "fzf: ✓ installed"
else
    echo "fzf: ✗ not installed"
fi

if command -v bat >/dev/null 2>&1 || command -v batcat >/dev/null 2>&1; then
    echo "bat: ✓ installed"
else
    echo "bat: ✗ not installed"
fi

echo
echo "=== Usage Notes ==="
echo "If icons appear as boxes or question marks:"
echo "1. Install a Nerd Font (recommended: FiraCode Nerd Font)"
echo "2. Configure your terminal to use the Nerd Font"
echo "3. Restart your terminal application"
echo
echo "For VS Code integrated terminal:"
echo "1. Open VS Code settings (Ctrl+,)"
echo "2. Search for 'terminal font'"
echo "3. Set 'Terminal › Integrated: Font Family' to 'FiraCode Nerd Font'"
echo
