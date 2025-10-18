#!/usr/bin/env bash

set -euo pipefail

if [[ ${EUID} -eq 0 ]]; then
  SUDO=""
else
  SUDO="sudo"
fi

if [[ -r /etc/os-release ]]; then
  . /etc/os-release
  if [[ "${ID}" != "ubuntu" ]]; then
    echo "[install_nvim] This script is intended for Ubuntu systems." >&2
    echo "Detected ID=${ID:-unknown}." >&2
    exit 1
  fi
else
  echo "[install_nvim] Unable to determine operating system." >&2
  exit 1
fi

${SUDO} apt-get update
${SUDO} apt-get install -y \
  software-properties-common \
  build-essential \
  unzip \
  ripgrep \
  python3 \
  python3-pip \
  python3-venv \
  nodejs \
  npm

# Enable the official Neovim PPA to get the latest stable release.
if ! apt-cache policy | grep -q "neovim-ppa/stable"; then
  ${SUDO} add-apt-repository -y ppa:neovim-ppa/stable
fi

${SUDO} apt-get update
${SUDO} apt-get install -y neovim

# Ensure Python and Node.js integrations are available for plugins.
pip3 install --user --upgrade pynvim
npm install --global neovim >/dev/null 2>&1 || true

echo "[install_nvim] Neovim installation complete. Version:"
neovim_version=$(nvim --version | head -n 1)
echo "  ${neovim_version}"
