#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <package-name>"
  exit 1
fi

PKG="$1"

# 1. Remove the package
echo "Removing package: $PKG"
sudo pacman -Rns --noconfirm "$PKG"

# 2. Find leftover directories
echo "Searching for leftover '$PKG' directories..."
RESULTS=$(sudo find / -type d -name "$PKG" 2>/dev/null | grep -vE '/run/user/[0-9]+/(doc|gvfs)')

if [ -z "$RESULTS" ]; then
  echo "No leftover '$PKG' directories found."
  exit 0
fi

# 3. Print results
echo "Found the following directories:"
echo "$RESULTS"

# 4. Ask user
read -p "Do you want to remove these directories? [Y/N]: " confirm

case "$confirm" in
[Yy]*)
  echo "Removing directories..."
  echo "$RESULTS" | xargs sudo rm -rf
  echo "Cleanup done."
  ;;
[Nn]*)
  echo "Aborted. No directories were removed."
  ;;
*)
  echo "Invalid input. Exiting."
  ;;
esac
