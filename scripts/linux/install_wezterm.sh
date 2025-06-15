#!/bin/bash

## https://wezterm.org/install/linux.html

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
PARENT_DIR="$(dirname "$SCRIPT_PATH")"

. "${PARENT_DIR}/check_installed.sh"
. "${PARENT_DIR}/add_repository.sh"

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

  if command -v wezterm >/dev/null 2>&1; then
    echo "Wezterm is already installed"
    exit 0
  fi

  add_wezterm_apt_repository
  
  echo "Installing wezterm"
  sudo apt install -y wezterm
  if [[ $? -ne 0 ]]; then
    echo "[ERROR] Failed to install wezterm"
    exit 1
  fi

  echo "Wezterm installed successfully"
  exit 0
fi
