#!/bin/sh
set -e

apt_get_update() {
  if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
    echo "Running apt-get update..."
    apt-get update -y
  fi
}

# Checks if packages are installed and installs them if not
apt_get() {
  if ! dpkg -s "$@" >/dev/null 2>&1; then
    apt-get -y install --no-install-recommends "$@"
  fi
}

apt_get_update
apt_get ca-certificates
apt_get curl

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
  x86_64)
    ARCH_SUFFIX="x86_64"
    ;;
  aarch64|arm64)
    ARCH_SUFFIX="arm64"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# Build download URL based on version and architecture
if [ "$VERSION" = "latest" ]; then
  DOWNLOAD_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH_SUFFIX}.tar.gz"
else
  DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/${VERSION}/nvim-linux-${ARCH_SUFFIX}.tar.gz"
fi

# Download and install Neovim
echo "Downloading Neovim from ${DOWNLOAD_URL}..."
curl -fsSL "${DOWNLOAD_URL}" -o /tmp/nvim-linux.tar.gz
rm -rf /opt/nvim
tar -C /opt -xzf /tmp/nvim-linux.tar.gz
mv /opt/nvim-linux-${ARCH_SUFFIX} /opt/nvim
rm /tmp/nvim-linux.tar.gz

# Make nvim available for everybody
ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim

# Install fd and ripgrep
echo "Installing fd and ripgrep..."
apt_get fd-find ripgrep
ln -sf "$(which fdfind)" /usr/local/bin/fd

# Install neovim node package if npm is available
if command -v npm > /dev/null 2>&1; then
  echo "Installing neovim npm package..."
  npm install -g neovim || true
fi

# Install pynvim if python/pip is available
if command -v pip3 > /dev/null 2>&1; then
  echo "Installing pynvim..."
  pip3 install pynvim 2>/dev/null || pip3 install --break-system-packages pynvim || true
elif command -v pip > /dev/null 2>&1; then
  echo "Installing pynvim..."
  pip install pynvim 2>/dev/null || pip install --break-system-packages pynvim || true
fi
