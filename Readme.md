# NVIM Config and VIM Migration to NVIM Story

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

CONFIG SETUP:  

- make vim more like an IDE ✅
- Debloating the Config ✅
- remove unused plugins ✅
- move to the build in LSP ✅
- add formatting and linting ✅
- Debug ☑️
  - Typescript NodeJS ✅
  - Browser Javascript ✅
  - Rust ✅
  - Go ❓
  - Python ❓
- intutive mappings ✅
- fast tab/buffer navigation ✅
- project managment ✅
- session managment ✅
- file managment ✅
- lazy load plugins ✅
- Treesitter Setup ✅
- DONE AS OF 18.05.21

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
