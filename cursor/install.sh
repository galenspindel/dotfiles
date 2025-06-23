#!/bin/sh
#
# Cursor IDE Configuration
#
# Sets up Cursor IDE with custom settings and keybindings for Claude Code integration.

set -e

echo "  Setting up Cursor IDE configuration..."

# Create Cursor config directory if it doesn't exist
CURSOR_CONFIG_DIR="$HOME/Library/Application Support/Cursor/User"
mkdir -p "$CURSOR_CONFIG_DIR"

# Link settings and keybindings
if [ -f "$HOME/.dotfiles/cursor/settings.json" ]; then
    echo "  Linking Cursor settings.json..."
    ln -sf "$HOME/.dotfiles/cursor/settings.json" "$CURSOR_CONFIG_DIR/settings.json"
fi

if [ -f "$HOME/.dotfiles/cursor/keybindings.json" ]; then
    echo "  Linking Cursor keybindings.json..."
    ln -sf "$HOME/.dotfiles/cursor/keybindings.json" "$CURSOR_CONFIG_DIR/keybindings.json"
fi

echo "  Cursor IDE configuration complete!"
echo "  Use Cmd+Shift+C in Cursor terminal to launch Claude Code CLI"