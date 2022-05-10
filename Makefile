#
# Makefile
#

ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

help:
	@echo "help"
	./packages.py --help

link:
	@echo "link /usr/local/bin/nvim-dep-updater"
	sudo ln -sf $(ROOT_DIR)/packages.py /usr/local/bin/nvim-dep-updater

update:
	@echo "Upgrade Dependencies"
	./packages.py --update

install:
	@echo "Install"
	./packages.py

nvim:
	@echo "Nvim First Time Setup"
	nvim --headless +'autocmd User PackerComplete sleep 100ms | qa'
	nvim --headless +'autocmd User PackerComplete sleep 100ms | qa' +'PackerSync'
	nvim --headless +'TSInstall bash python cpp rust go lua dockerfile yaml typescript javascript java tsx tsdoc c org scss css toml make json html php' +'sleep 15' +'qa'

all: link install nvim

docker-build:
	docker build . -t nvim:test

docker-dev:
	docker run -it -v $(pwd):/mnt/workspace danielnehrig/nvim:test

docker-run:
	docker run -it -v $(pwd):/mnt/workspace danielnehrig/nvim:latest


# vim:ft=make
#
