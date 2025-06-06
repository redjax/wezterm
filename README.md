# Wezterm Configuration <!-- omit in toc -->

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
- Copy or symlink one of the [configurations in the `configs/` directory](./configs) to `~/.config/wezterm`

## Links

- [Wezterm home](https://wezterm.org)
- [Wezterm configuration docs](https://wezterm.org/config/files.html)
  - [Wezterm config Lua modules](https://wezterm.org/config/files.html#making-your-own-lua-modules)
  - [Wezterm list of config options](https://wezterm.org/config/lua/config/index.html)
- [Wezterm CLI reference](https://wezterm.org/cli/general.html)
