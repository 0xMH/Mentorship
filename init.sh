#!/bin/bash

# Obsidian Vault Initialization Script
# Copies .obsidian-config/ to .obsidian/ for first-time setup

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_SOURCE="$SCRIPT_DIR/.obsidian-config"
CONFIG_DEST="$SCRIPT_DIR/.obsidian"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "🧙‍♂️ Wizards DevOps Mentorship - Vault Setup"
echo "============================================"
echo ""

# Check if .obsidian-config exists
if [ ! -d "$CONFIG_SOURCE" ]; then
    echo -e "${RED}Error: .obsidian-config/ folder not found!${NC}"
    echo "Make sure you're running this from the vault root directory."
    exit 1
fi

# Check if .obsidian already exists
if [ -d "$CONFIG_DEST" ]; then
    echo -e "${YELLOW}Warning: .obsidian/ folder already exists.${NC}"
    echo ""
    read -p "Do you want to overwrite it? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Aborted. Your existing config was not changed."
        exit 0
    fi
    echo ""
    echo "Backing up existing config to .obsidian.backup/"
    rm -rf "$CONFIG_DEST.backup"
    mv "$CONFIG_DEST" "$CONFIG_DEST.backup"
fi

# Copy config
echo "Copying .obsidian-config/ to .obsidian/..."
cp -r "$CONFIG_SOURCE" "$CONFIG_DEST"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ Setup complete!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Open Obsidian"
    echo "  2. Select 'Open folder as vault' → choose this folder"
    echo "  3. Click 'Trust author and enable plugins'"
    echo "  4. You're ready! 🎉"
    echo ""
else
    echo -e "${RED}Error: Failed to copy config files.${NC}"
    exit 1
fi
