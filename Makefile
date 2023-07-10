#
# Makefile
#

ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

help:
	@echo "help"
	./packages.py --help

check:
	@echo "lint / format"
	luacheck **/*.lua
	stylua **/*.lua

link:
	@echo "link /usr/local/bin/nvim-dep-updater"
	sudo ln -sf $(ROOT_DIR)/packages.py /usr/local/bin/nvim-dep-updater

update:
	@echo "Upgrade Dependencies"
	./packages.py --update

install:
	@echo "Install packages"
	./packages.py

nvim-packer:
	@echo "Nvim First Time Setup"
	nvim --headless +'autocmd User PackerComplete sleep 100ms | qa'
	nvim --headless +'autocmd User PackerComplete sleep 100ms | qa' +'PackerSync'

nvim-lazy:
	@echo "Nvim First Time Setup"
	nvim --headless +'autocmd User LazyInstall sleep 100ms | qa'
	nvim --headless +'autocmd User LazySync sleep 100ms | qa' +'Lazy sync'

all: link install nvim

docker-build:
	docker build . -t nvim:test

docker-dev:
	docker run -it -v $(pwd):/mnt/workspace danielnehrig/nvim:test

docker-run:
	docker run -it -v $(pwd):/mnt/workspace danielnehrig/nvim:latest


# vim:ft=make
#
