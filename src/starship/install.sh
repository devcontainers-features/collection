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

# Install Atlas CLI
curl -sSf https://starship.rs/install.sh | sh -s -- -y --version="${VERSION}"
