<div align="center">

<h1>NVIM Config</h1>

[![docker build](https://img.shields.io/github/actions/workflow/status/danielnehrig/nvim/docker.yml?label=build&logo=docker&style=for-the-badge)](https://hub.docker.com/r/danielnehrig/nvim/tags)
[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
[![Neovim Stable](https://img.shields.io/badge/Neovim%20Stable-green.svg?style=for-the-badge&logo=neovim)](https://neovim.io)
[![Neovim Nightly](https://img.shields.io/badge/Neovim%20Nightly-red.svg?style=for-the-badge&logo=neovim)](https://neovim.io)
![Work In Progress](https://img.shields.io/badge/Work%20In%20Progress-orange?style=for-the-badge)

</div>

- [Preview](#preview)
  - [Try it out with Docker!](#try-it-out-with-docker)
  - [Pitch](#pitch)
  - [The Main Goals](#the-main-goals)
  - [Philosophy and side infos](#philosophy-and-side-infos)
    - [Nvim Log](#nvim-log)
- [Setup](#setup)
  - [Manual Setup](#manual-setup)
  - [Auto Setup](#auto-setup)
  - [Requirements](#requirements)
  - [Customize](#customize)
  - [Mappings](#mappings)
- [Inspirations and sources](#inspirations-and-sources)

# Preview

https://user-images.githubusercontent.com/4050749/169545588-198c7dab-11fa-4306-bcd0-9f1eea4b0556.mp4

## Try it out with Docker!

_(stable version)_

```bash
docker run -it \
  -v $(pwd):/mnt/workspace \
  danielnehrig/nvim:latest
```

_(nightly version)_

```bash
docker run -it \
  -v $(pwd):/mnt/workspace \
  danielnehrig/nvim:nightly
```

## Pitch

This Config represents a full IDE experience\
Focus on idiomatic mappings with simplicity

<details>
<summary>Synopsis</summary>
I've been using vim for about 7-8 years now

While I was aware that neovim was a thing
I didn't really understand or tried to understand
which problems it tries to solve which vim has
one day I jumped about features for the 0.5.0 upcoming release
which was about the native LSP in neovim
while I was using YCM at that time for VIM
(which I was pretty happy with)
I thought lets give it a shot how it works for neovim
this is when I realized that neovim had a LUA JIT
implemented at that moment I was sold to it due to prior lua experience
I investigated the lua plugin ecosystem while fairly small at that time
it grew and grew and grew... It looked promising
now we are here back at it again configuring the same editor
with better features
this time getting an IDE like experience
getting rid of prior pain points with vim
and getting rid of bad habits.
The journey begins

</details>

Started 09.04.21

CONFIG SETUP:

- IDE capabilities (lsp, debug, project management, build, lint, test) ✅
- remove unused plugins ✅
- move to the build in LSP ✅
- add formatting and linting ✅
- Debug ✅
- intuitive mappings ✅
- fast tab/buffer navigation ✅
- project management ✅
- session management ✅
- file management ✅
- lazy load plugins ✅
- Treesitter Setup ✅
- Refactoring ✅

## Philosophy and side infos

Vim is a modal text editing solution so is neovim\
it does not strive to be an ID, but it offers IDE like capabilities\
with it's exposed lua API and the Community revolving around it\
creating a big up-and-coming plugin ecosystem\
since vim/neovim are writtin in c it's a blazing fast editor\
vs its competitors
while it has its plugin ecosystem and IDE like capabilities\
it does not offer an out-of-the-box solution like VSCode\
for that case boilerplate configurations like Lunarvim or Lvim are out there\
even this config would be a great place to start to have IDE like capabilities\
it's inspired by Lvim though not cloned

# Setup

## Manual Setup

0. `git clone https://github.com/danielnehrig/nvim ~/.config/nvim && cd ~/.config/nvim`
1. `./package.py`
2. `nvim +'autocmd User LazyInstall sleep 100ms | qa'`
3. `nvim +'autocmd User LazyDone TSInstall all' +'Lazy sync'`

## Auto Setup

**DESTRUCTIVE**\
_NOTE: THIS WILL DELETE YOUR CURRENT ~/.config/nvim folder_\
`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/danielnehrig/nvim/master/autoinstall.sh)"`

## Requirements

Most of the requirements can be installed over the `./package.py` script

<details>
<summary>Requirements</summary>

Font:

_Nerd Font any Monospaced One (if not monospaced the dashboard logo will not work)_
**I use FiraCode Nerd Font Mono for regular and bold and VictorMono Nerd Font for italics**

_Package managers:_

- _python3.9_ >
- pip
- _node_
- _go_
- _rust/cargo_
- _luarocks_
- _brew_ (mac support)
- _yay_ (archlinux support)

_NVIM V ^0.7.\*_

_LSPs in path:_

- pyright
- efm (for lint and formatting mainly lua and JS, TS)
- typescript-language-server
- rust-analyzer
- gopls
- sumneko-lua
- jdtls
- etc... check lsp config for more info

_DAP:_

- Some Adapters can be installed with Dap install
- Java Adapter has to be installed manually

</details>

## Customize

We have a config layer copy and paste the default config layout from `config.core.default_config`
and create folder and file `rootFolder/lua/config/custom/init.lua`
paste in the default_configs values and adjust accordingly

# Supported Languages / Syntax

The Config should fully support:

<details>
<summary>Languages</summary>

- Typescript / Javascript
- CSS/SASS/SCSS
- Rust
- Java
- C, C++
- C# (omnisharp)
- Go
- Dockerfile
- Yaml
- Json
- Python
- Lua
- Toml

</details>

## Mappings

<details>
<summary>Maps</summary>

- Space is the leader key

- d - is for Debug
- g - is for misc LSP actions
- q - quickfix
- l - loclist
- u - utility (disable diagnostic etc)
- f - file related (telescope)
- w - window

</details>

# Inspirations and sources

- Lvim
- nvchad and module suite
  - Theme based solution (which I incorporated packer themes in)
  - If the theme modules wouldn't be strictly written for nvchad I would have used their module
- base16
