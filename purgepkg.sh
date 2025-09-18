#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <package-name>"
  exit 1
fi

PKG="$1"

# 1. Remove the package
echo "Removing package: $PKG"
yay -Rnscu --noconfirm "$PKG"

# 2. Find leftover files and directories (exact and with suffix/prefix)
echo "Searching for leftover '$PKG' files and directories..."
RESULTS=$(sudo find / \
  \( -type d -o -type f \) \
  \( -name "$PKG" -o -name "${PKG}-*" -o -name "*-${PKG}" -o -name "*-${PKG}-*" \) \
  2>/dev/null | grep -vE '/run/user/[0-9]+/(doc|gvfs)')

if [ -z "$RESULTS" ]; then
  echo "No leftover '$PKG' files or directories found."
  exit 0
fi

# 3. Print results
echo "Found the following files/directories:"
echo "$RESULTS"

# 4. Ask user
read -p "Do you want to remove these? [Y/N]: " confirm

case "$confirm" in
[Yy]*)
  echo "Removing..."
  echo "$RESULTS" | xargs sudo rm -rf --
  echo "Cleanup done."
  ;;
[Nn]*)
  echo "Aborted. Nothing was removed."
  ;;
*)
  echo "Invalid input. Exiting."
  ;;
esac
