#!/bin/bash
## See all fonts at:
#  https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts

function install_nerdfont {
    FONT=$1

    if [[ "${FONT}" == "" ]]; then
        FONT="Hack"
    fi

    ## Get latest release
    VERSION=$(curl -s 'https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest' | jq -r '.name')
    if [[ $? -ne 0 ]]; then
      echo "[ERROR] Failed to get latest release"
      return 1
    fi

    if [ -z "$VERSION" ] || [ "$VERSION" = "null" ]; then
      VERSION="v3.2.1"
    fi

    FONTS_DIR="${HOME}/.local/share/fonts"
    mkdir -p "$FONTS_DIR"
    if [[ $? -ne 0 ]]; then
      echo "[ERROR] Failed to create fonts directory"
      return 1
    fi

    ZIP_FILE="${FONT}.zip"
    DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${VERSION}/${ZIP_FILE}"

    wget "$DOWNLOAD_URL"
    if [[ $? -ne 0 ]]; then
      echo "[ERROR] Failed to download ${ZIP_FILE}"
      return 1
    fi

    unzip -o "$ZIP_FILE" -d "$FONTS_DIR"
    if [[ $? -ne 0 ]]; then
      echo "[ERROR] Failed to unzip ${ZIP_FILE}"
      return 1    
    fi

    rm "$ZIP_FILE"
    if [[ $? -ne 0 ]]; then
      echo "[ERROR] Failed to remove ${ZIP_FILE}"
      return 1
    fi

    echo "Refreshing font cache."

    fc-cache -fv
    if [[ $? -ne 0 ]]; then
      echo "[ERROR] Failed to refresh font cache"
      return 1
    fi

    echo "Installed font ${FONT}"
    return 0
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_nerdfont "$1"
  if [[ $? -ne 0 ]]; then
    echo "Failed to install font: ${1}"
  fi
fi
