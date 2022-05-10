#!/bin/bash

rm -rf ~/.config/nvim
git clone https://github.com/danielnehrig/nvim ~/.config/nvim
cd ~/.config/nvim
./packages.py
nvim --headless +'autocmd User PackerComplete sleep 100ms | qa'
nvim --headless +'autocmd User PackerComplete sleep 100ms | qa' +'PackerSync'
nvim --headless +'TSInstall bash python cpp rust go lua dockerfile yaml typescript javascript java tsx tsdoc c org scss css toml make json html php' +'sleep 15' +'qa'
