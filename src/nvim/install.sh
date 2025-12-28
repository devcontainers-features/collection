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

# Build download URL based on version
if [ "$VERSION" = "latest" ]; then
  DOWNLOAD_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
else
  DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/${VERSION}/nvim-linux-x86_64.tar.gz"
fi

# Download and install Neovim
echo "Downloading Neovim from ${DOWNLOAD_URL}..."
curl -fsSL "${DOWNLOAD_URL}" -o /tmp/nvim-linux-x86_64.tar.gz
rm -rf /opt/nvim-linux-x86_64
tar -C /opt -xzf /tmp/nvim-linux-x86_64.tar.gz
rm /tmp/nvim-linux-x86_64.tar.gz

# Make nvim available for everybody
ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
