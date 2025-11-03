#!/usr/bin/env bash
set -euo pipefail

# Default version. Override by setting VERSION env var, e.g. VERSION="v0.11.5" ./install-nvim.sh
VERSION="${VERSION:-v0.11.5}"
TMP_DIR="$(mktemp -d /tmp/nvim-install.XXXX)"
INSTALL_PREFIX="/usr/local"
BIN_DIR="$INSTALL_PREFIX/bin"
SHARE_DIR="$INSTALL_PREFIX/share"
DESKTOP_ENTRY="/usr/share/applications/nvim.desktop"
ICON_URL="https://raw.githubusercontent.com/neovim/neovim/master/runtime/nvim.png"
ICON_PATH="$SHARE_DIR/icons/hicolor/128x128/apps/nvim.png"

info(){ printf '\e[1;34m[INFO]\e[0m %s\n' "$*"; }
ok(){ printf '\e[1;32m[OK]\e[0m %s\n' "$*"; }
err(){ printf '\e[1;31m[ERROR]\e[0m %s\n' "$*"; exit 1; }

cleanup(){
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

arch="$(uname -m)"
info "Detected architecture: $arch"
case "$arch" in
  x86_64) artifact_name="nvim-linux-x86_64.tar.gz";;
  aarch64) artifact_name="nvim-linux-arm64.tar.gz"; appimage_name="nvim-linux-arm64.appimage";;
  armv7l) artifact_name="nvim-linux-armv7.tar.gz";;
  *) err "Unsupported architecture: $arch";;
esac

base="https://github.com/neovim/neovim/releases/download/${VERSION}"

cd "$TMP_DIR"

# try tarball first
tarball_url="${base}/${artifact_name}"
info "Trying tarball: $tarball_url"
if curl -fL -o nvim.tar.gz "$tarball_url"; then
  info "Downloaded tarball"
  tar -xzf nvim.tar.gz || err "Failed to extract tarball"
  # extracted folder usually named nvim-linux-*
  extracted_dir="$(find . -maxdepth 1 -type d -name 'nvim-linux*' -print -quit)"
  [ -n "$extracted_dir" ] || err "Extraction did not produce expected directory"
  info "Installing files to $INSTALL_PREFIX (requires sudo)"
  sudo cp -r "$extracted_dir/"* "$INSTALL_PREFIX/" || err "Failed to copy files"
else
  # fallback for aarch64: try AppImage
  if [ "${arch}" = "aarch64" ]; then
    appimage_url="${base}/${appimage_name}"
    info "Tarball not available. Trying AppImage: $appimage_url"
    if curl -fL -o nvim.appimage "$appimage_url"; then
      info "Downloaded AppImage"
      chmod +x nvim.appimage
      info "Installing AppImage to $BIN_DIR/nvim (requires sudo)"
      sudo mkdir -p "$BIN_DIR"
      sudo mv nvim.appimage "$BIN_DIR/nvim"
      sudo chmod +x "$BIN_DIR/nvim"
    else
      err "Neither tarball nor AppImage available for $arch at ${VERSION}"
    fi
  else
    err "Tarball download failed and no fallback available for $arch"
  fi
fi

# create desktop entry and icon if we installed binaries
info "Installing icon and desktop entry (best-effort)"
sudo mkdir -p "$(dirname "$ICON_PATH")"
if ! curl -fsSL "$ICON_URL" -o /tmp/nvim_icon.png ; then
  info "Icon download failed; skipping icon install"
else
  sudo mv /tmp/nvim_icon.png "$ICON_PATH" || info "Could not move icon to $ICON_PATH"
fi

sudo bash -c "cat > '$DESKTOP_ENTRY' <<'EOF'
[Desktop Entry]
Name=Neovim
GenericName=Text Editor
Comment=Neovim editor
Exec=nvim %F
Icon=nvim
Terminal=true
Type=Application
Categories=Utility;TextEditor;
StartupNotify=false
EOF" || info "Could not write desktop entry (desktop environments only)."

# ensure /usr/local/bin is in PATH for current shell session when invoked with sudo
info "Refreshing command hash and verifying installation"
hash -r || true

if command -v nvim >/dev/null 2>&1; then
  ok "Neovim appears on PATH: $(command -v nvim)"
  echo
  nvim --version | sed -n '1,12p'
  ok "Installation complete."
else
  err "nvim not found on PATH after install. Check /usr/local/bin and /usr/local/share/nvim."
fi
