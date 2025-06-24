<!-- Repo image -->
<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./.static/img/wezterm-icon-square.png">
    <img src="./.static/img/wezterm-icon-square.png" height="200">
  </picture>
</p>

<p align="center">
  <img alt="GitHub Created At" src="https://img.shields.io/github/created-at/redjax/wezterm">
  <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/redjax/wezterm">
  <img alt="GitHub commit activity" src="https://img.shields.io/github/commit-activity/y/redjax/wezterm">
  <img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/redjax/wezterm">
  <img alt="GitHub code size in bytes" src="https://img.shields.io/github/languages/code-size/redjax/wezterm">
</p>

My configuration for [Wezterm terminal emulator](https://wezterm.org).

## Table of Contents <!-- omit in toc -->

- [Install](#install)
  - [Windows](#windows)
  - [Linux](#linux)
- [Links](#links)

## Install

### Windows

- Install `wezterm` with `winget`, `scoop`, `choco`, etc.
  - Optionally, use the [Windows `wezterm` install script](./scripts/windows/install-wezterm.ps1)
- Copy or symlink one of the [configurations in the `configs/` directory](./configs/) to `%USERPROFILE%\.config\wezterm`
  - Optionally, use the [Windows `wezterm` configuration install script](./scripts/windows/install-wezterm-config.ps1)

### Linux

- Install `wezterm`
  - Your package repositories might have a wezterm package, or you can use the [Linux `install_wezterm.sh` script](./scripts/linux/install_wezterm.sh).
- After installing `wezterm`, run the [`install_nerdfont.sh` script](./linux/install_nerdfont.sh) to install the NerdFonts I use (Hack, FiraCode, FiraMono).
- Copy or symlink one of the [configurations in the `configs/` directory](./configs) to `~/.config/wezterm`

## Links

- [Wezterm home](https://wezterm.org)
- [Wezterm configuration docs](https://wezterm.org/config/files.html)
  - [Wezterm config Lua modules](https://wezterm.org/config/files.html#making-your-own-lua-modules)
  - [Wezterm list of config options](https://wezterm.org/config/lua/config/index.html)
- [Wezterm CLI reference](https://wezterm.org/cli/general.html)
