#!/usr/bin/env bash
set -e

# ========================================================
# Turbo Pascal 7 Setup Script for DOSEMU2
# ========================================================
# Extracts TPC.ZIP, TURBO.ZIP, and UNITS.ZIP into
# ~/msdos/apps/tp7/bin and ~/msdos/apps/tp7/units
# Supports interactive pauses between steps.
# ========================================================

# --- Configuration ---
TP_URL="https://winworldpc.com/download/e530a58d-6134-11ea-8c4a-fa163e9022f0/from/c39ac2af-c381-c2bf-1b25-11c3a4e284a2"
MSDOS_DIR="$HOME/msdos"
TMP_DIR="$MSDOS_DIR/tmp"
APPS_DIR="$MSDOS_DIR/apps"
TP7_DIR="$APPS_DIR/tp7"
TP7_BIN="$TP7_DIR/bin"
TP7_UNITS="$TP7_DIR/units"
DOSEMU_C="$HOME/.dosemu/drive_c"
TP7_7Z="$TMP_DIR/Borland_Turbo_Pascal_7.0.7z"

# --- Functions ---
pause() {
  echo
  echo "Press ENTER to continue..."
  read -r _ </dev/tty
  echo
}

wait_for_apt_lock() {
  echo "Checking for apt lock..."
  while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
      echo "Waiting for apt lock to be released..."
      sleep 5
  done
}

# --- Step 1: Setup directories ---
echo "Setting up directories..."
mkdir -p "$TMP_DIR" "$TP7_BIN" "$TP7_UNITS"
pause

# --- Step 2: Install dependencies ---
echo "Installing required packages..."
wait_for_apt_lock
sudo add-apt-repository -y ppa:dosemu2/ppa
sudo apt update -y
sudo apt install -y p7zip-full dosbox-x dosemu2 dj64 wget
pause

# --- Step 3: Download Turbo Pascal archive ---
if [ ! -f "$TP7_7Z" ]; then
    echo "Downloading Turbo Pascal 7 archive..."
    wget -O "$TP7_7Z" "$TP_URL"
else
    echo "Turbo Pascal archive already exists, skipping download."
fi
pause

# --- Step 4: Extract main 7z flatly ---
echo "Extracting Turbo Pascal archive into $TMP_DIR..."
cd "$TMP_DIR"
7z e "$TP7_7Z" -aoa
pause

# --- Step 5: Extract .IMG floppy images ---
echo "Extracting all floppy images..."
mkdir -p "$TMP_DIR/extracted"
for img in "$TMP_DIR"/*.img; do
    if [ -f "$img" ]; then
        echo "Extracting from $(basename "$img")"
        7z x "$img" -aoa -o"$TMP_DIR/extracted"
    fi
done
pause

# --- Step 6: Extract TPC.ZIP to bin ---
TPC_ZIP=$(find "$TMP_DIR/extracted" -iname "TPC.ZIP" | head -n 1)
if [ -z "$TPC_ZIP" ]; then
    echo "ERROR: Could not find TPC.ZIP inside disk images!"
    exit 1
fi
echo "Extracting TPC.ZIP to $TP7_BIN..."
7z e "$TPC_ZIP" -aoa -o"$TP7_BIN"
pause

# --- Step 7: Extract TURBO.ZIP to bin ---
TURBO_ZIP=$(find "$TMP_DIR/extracted" -iname "TURBO.ZIP" | head -n 1)
if [ -z "$TURBO_ZIP" ]; then
    echo "ERROR: Could not find TURBO.ZIP inside disk images!"
    exit 1
fi
echo "Extracting TURBO.ZIP to $TP7_BIN..."
7z e "$TURBO_ZIP" -aoa -o"$TP7_BIN"
pause

# --- Step 8: Extract UNITS.ZIP to units ---
UNITS_ZIP=$(find "$TMP_DIR/extracted" -iname "UNITS.ZIP" | head -n 1)
if [ -z "$UNITS_ZIP" ]; then
    echo "ERROR: Could not find UNITS.ZIP inside disk images!"
    exit 1
fi
echo "Extracting UNITS.ZIP to $TP7_UNITS..."
7z e "$UNITS_ZIP" -aoa -o"$TP7_UNITS"
pause

# --- Step 9: Extract TPL.ZIP to bin ---
TPL_ZIP=$(find "$TMP_DIR/extracted" -iname "TPL.ZIP" | head -n 1)
if [ -z "$TPL_ZIP" ]; then
    echo "ERROR: Could not find TPL.ZIP inside disk images!"
    exit 1
fi
echo "Extracting TPL.ZIP to $TP7_BIN..."
7z e "$TPL_ZIP" -aoa -o"$TP7_BIN"
pause

# --- Step 10: Fix libdj64 symlinks ---
if [ ! -f /usr/lib/x86_64-linux-gnu/libdj64.so.0.2 ]; then
    ln -sf /usr/lib/x86_64-linux-gnu/i386-pc-dj64/lib64/libdj64.so.0.2 /usr/lib/x86_64-linux-gnu/libdj64.so.0.2
    ln -sf /usr/lib/x86_64-linux-gnu/i386-pc-dj64/lib64/libdj64.so.0 /usr/lib/x86_64-linux-gnu/libdj64.so.0
    ldconfig
fi
pause

# --- Step 11: Initialize DOSEMU drive_c if needed ---
if [ ! -d "$DOSEMU_C" ]; then
    echo "Initializing DOSEMU home directory..."
    dosemu -dumb -E exitemu || true
fi
mkdir -p "$DOSEMU_C"
pause

# --- Step 12: Create DOSEMU symlink ---
if [ ! -L "$DOSEMU_C/tp7" ]; then
    echo "Creating symlink for DOSEMU..."
    ln -sf "$TP7_DIR" "$DOSEMU_C/tp7"
fi
pause

# --- Step 13: Configure userhook.bat ---
USERHOOK="$DOSEMU_C/userhook.bat"
echo "Configuring DOSEMU PATH..."
# Create file if it doesn’t exist
touch "$USERHOOK"

# Only append if the line is not already present
if ! grep -Fxq "set PATH=%PATH%;C:\\tp7\\bin" "$USERHOOK"; then
    echo "set PATH=%PATH%;C:\\tp7\\bin" >> "$USERHOOK"
fi


# --- Step 14: Clean up temporary files ---
echo "Cleaning up temporary files..."
rm -rf "$TMP_DIR"

# --- Step 15: Verify installation ---
if [ -f "$TP7_BIN/TPC.EXE" ]; then
    echo "Turbo Pascal compiler (TPC.EXE) successfully extracted!"
else
    echo "WARNING: TPC.EXE not found in $TP7_BIN. Check archive contents."
fi
pause

# --- Done ---
echo
echo "Setup complete!"
echo "You can now test Turbo Pascal in DOSEMU with:"
echo "  dosemu -E \"tpc\" -K . -dumb"
echo

