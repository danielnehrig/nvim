#
# Makefile
#

ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

help:
	@echo "help"
	./packages.py --help

check:
	@echo "lint / format"
	luacheck ./
	stylua --glob '**/*.lua' ./

link:
	@echo "link /usr/local/bin/nvim-dep-updater"
	sudo ln -sf $(ROOT_DIR)/packages.py /usr/local/bin/nvim-dep-updater

update:
	@echo "Upgrade Dependencies"
	./packages.py --update

install:
	@echo "Install packages"
	./packages.py

nvim:
	@echo "Nvim First Time Setup"
	nvim --headless +'autocmd User LazyInstall sleep 100ms | qa'
	nvim --headless +"Lazy! sync" +qa

all: link install nvim

docker-build:
	docker build . -t nvim:test

docker-dev:
	docker run -it -v $(pwd):/mnt/workspace danielnehrig/nvim:test

docker-run:
	docker run -it -v $(pwd):/mnt/workspace danielnehrig/nvim:latest


# vim:ft=make
#
