#!/bin/bash

set -euo pipefail

CONFIG_NAME="default"
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
PARENT_DIR="$(dirname "$SCRIPT_PATH")"

function symlink_config {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
    case "$1" in
        --config-name)
        CONFIG_NAME="$2"
        shift 2
        ;;
        -h|--help)
        echo "Usage: $0 [--config-name <name>]"
        exit 0
        ;;
        *)
        echo "[ERROR] Unknown argument: $1"
        exit 1
        ;;
    esac
    done

    # Repository root (assume script is run from root)
    CWD="$(pwd)"

    # Source config directory
    WEZTERM_CONFIG_SRC="${CWD}/configs/${CONFIG_NAME}"

    # Destination .config dir
    HOST_DOTCONFIG_DIR="${HOME}/.config"

    # Destination symlink
    WEZTERM_DEST="${HOME}/.config/wezterm"

    # Check source config exists
    if [[ ! -d "${WEZTERM_CONFIG_SRC}" ]]; then
    echo "[ERROR] Wezterm source config directory not found: ${WEZTERM_CONFIG_SRC}"
    exit 1
    fi

    # Ensure ~/.config exists
    if [[ ! -d "${HOST_DOTCONFIG_DIR}" ]]; then
    echo "[INFO] ~/.config directory not found. Creating."
    mkdir -p "${HOST_DOTCONFIG_DIR}" || { echo "[ERROR] Could not create ~/.config"; exit 1; }
    fi

    # Backup existing ~/.wezterm if it exists and is not a symlink
    if [[ -e "${WEZTERM_DEST}" && ! -L "${WEZTERM_DEST}" ]]; then
    echo "[WARNING] ${WEZTERM_DEST} already exists. Backing up to ${WEZTERM_DEST}.bak"
    if [[ -e "${WEZTERM_DEST}.bak" ]]; then
        echo "[WARNING] ${WEZTERM_DEST}.bak already exists. Overwriting."
        rm -rf "${WEZTERM_DEST}.bak"
    fi
    mv "${WEZTERM_DEST}" "${WEZTERM_DEST}.bak"
    elif [[ -L "${WEZTERM_DEST}" ]]; then
    echo "[INFO] ${WEZTERM_DEST} is already a symlink. Removing."
    rm "${WEZTERM_DEST}"
    fi

    # Create symlink
    ln -s "${WEZTERM_CONFIG_SRC}" "${WEZTERM_DEST}" || { echo "[ERROR] Failed to create symlink"; exit 1; }

    echo "[SUCCESS] Wezterm config installed: ${WEZTERM_DEST} -> ${WEZTERM_CONFIG_SRC}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    symlink_config "$@"
    if [[ $? -ne 0 ]]; then
    echo "Failed to install wezterm"
    exit 1
    fi
fi
