![docker build]( https://img.shields.io/github/workflow/status/danielnehrig/nvim/ci?label=build&logo=docker&style=plastic )
[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
[![Neovim Stable](https://img.shields.io/badge/Neovim%20Nightly-green.svg?style=for-the-badge&logo=neovim)](https://neovim.io)
[![Neovim Nightly](https://img.shields.io/badge/Neovim%20Nightly-green.svg?style=for-the-badge&logo=neovim)](https://neovim.io)
![Work In Progress](https://img.shields.io/badge/Work%20In%20Progress-orange?style=for-the-badge)

# NVIM Config and VIM Migration to NVIM Story

## Preview

https://user-images.githubusercontent.com/4050749/136713743-4117a967-c5f5-4735-ad1c-9a6743fb743c.mp4


Try it out yourself!  
(stable version)  
```bash
docker run -it \
  --entrypoint /bin/bash \
  -v $(pwd):/mnt/workspace \
  danielnehrig/nvim:latest \
  -c "source /root/.bashrc && nvim"
```
  
(nightly version)  
```bash
docker run -it \
  --entrypoint /bin/bash \
  -v $(pwd):/mnt/workspace \
  danielnehrig/nvim:nightly \
  -c "source /root/.bashrc && nvim"
```

## Synposis

I've been using vim for about 7-8 years now  
while i was aware that neovim was a thing  
i didn't really understand or tried to understand  
which problems it tries to solve which vim has  
one day I jumped about features for the 0.5.0 upcoming release  
which was about the native LSP in neovim  
while i was using YCM at that time for VIM  
(which i was pretty happy with)  
i thought lets give it a shot how it works for neovim  
this is when i realized that neovim had a LUA JIT  
implemented at that moment i was sold to it due to prior lua experience  
i investigated the lua plugin ecosystem while fairly small at that time  
it grew and grew and grew... it looked promising  
now we are here back at it again configuring the same editor  
with better features  
this time getting a IDE like experience  
getting rid of prior pain points with vim  
and getting rid of bad habbits.  
the journy begings

Started 09.04.21

## The Main Goals

The Config should fully support:

- Typescript / Javascript
- Rust
- Java
- Go
- Python

CONFIG SETUP:  

- IDE capabilities (lsp,debug,project managment,build,lint,test) ✅
- Debloating the Config (staying under 100ms bootup time) ✅
- remove unused plugins ✅
- move to the build in LSP ✅
- add formatting and linting ✅
- Debug ✅
- intutive mappings ✅
- fast tab/buffer navigation ✅
- project managment ✅
- session managment ✅
- file managment ✅
- lazy load plugins ✅
- Treesitter Setup ✅
- Refactoring ✅

## Philosophy and side infos

Vim is a modal text editing solution so is neovim  
it does not strive to be a IDE but it offers IDE like capabilities  
with it's exposed lua API and the Community revolving around it  
creating a big up and coming plugin ecosystem  
since vim/neovim are writtin in c it's a blazing fast editor  
vs its competitors 
while it has it's plugin ecosystem and IDE like capabilities  
it does not offer a out of the box solution like VSCode  
for that case boilerplate configurations like Lunarvim or Lvim are out there  
even this config would be a great place to start to have IDE like capabilities  
it's inspired by Lvim though not cloned  

### Nvim Log

*[Logs](./nvim.log) created on*
- i9 9900k 5Ghz
- 32GB Ram
- Arch Linux

### Requirements

*Font:*
- Nerd Font any Monospaced One (if not monospaced the dashboard logo will not work)

*Package managers:*
- *python3.9*
- *node*
- *go*
- *rust/cargo*

*NVIM V ^0.7.\**

*LSPs in path:*
- pyright
- efm (for lint and formatting mainly lua and js,ts)
- typescript-language-server
- rust-analyzer
- gopls
- sumneko-lua
- jdtls
- etc... check lsp config for more info

*DAP:*
- Some Adapters can be installed with Dap install
- Java Adapter has to be installed manually

*GH:* _(plugins.gh)_
- Add a env var with ur github username
- Add a env var with your github token
_hint:_ i use bitwarden and populate with the cli the credentials for the env

### Setup

- Run ./package.py to install debug adapters and lsp
- Run nvim and let it do its thing until its done
- Run `TSInstall maintained`
- Run in nvim `DIInstall python` `DIInstall chrome` `DIInstall jsnode`
