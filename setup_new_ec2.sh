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
    echo "[setup_new_ec2] This script currently supports Ubuntu only." >&2
    echo "Detected ID=${ID:-unknown}." >&2
    exit 1
  fi
else
  echo "[setup_new_ec2] Unable to read /etc/os-release to determine operating system." >&2
  exit 1
fi

${SUDO} apt-get update
${SUDO} apt-get install -y \
  build-essential \
  ca-certificates \
  curl \
  fzf \
  git \
  gnupg \
  htop \
  stow \
  tmux \
  tree \
  unzip \
  wget

# Ensure the current user owns ~/.local after package installations.
mkdir -p "${HOME}/.local/bin"

# Install Neovim and its language bindings using the companion script.
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
if [[ -x "${SCRIPT_DIR}/install_nvim.sh" ]]; then
  "${SCRIPT_DIR}/install_nvim.sh"
else
  echo "[setup_new_ec2] Warning: install_nvim.sh not found or not executable." >&2
fi

# Symlink dotfiles from the repository into the user's home directory.
link_file() {
  local source_path=$1
  local target_path=$2

  if [[ -e "${target_path}" && ! -L "${target_path}" ]]; then
    local backup="${target_path}.bak$(date +%s)"
    echo "[setup_new_ec2] Backing up existing ${target_path} to ${backup}" >&2
    mv "${target_path}" "${backup}"
  fi

  ln -snf "${source_path}" "${target_path}"
}

link_file "${SCRIPT_DIR}/.tmux.conf" "${HOME}/.tmux.conf"
link_file "${SCRIPT_DIR}/.vimrc" "${HOME}/.vimrc"
mkdir -p "${HOME}/.config"
link_file "${SCRIPT_DIR}/nvim" "${HOME}/.config/nvim"

# Refresh tmux plugins (if TPM is installed) and report status.
if [[ -d "${HOME}/.tmux/plugins/tpm" ]]; then
  echo "[setup_new_ec2] Updating tmux plugins via TPM."
  "${HOME}/.tmux/plugins/tpm/bin/install_plugins" || true
fi

cat <<'MSG'
[setup_new_ec2] Base setup complete.
- Dotfiles linked into your home directory.
- Core development packages installed.
- Neovim installed with Python and Node.js bindings.

Remember to add ~/.local/bin to your PATH if it is not already present.
MSG
