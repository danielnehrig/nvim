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

run:
	docker run -rm -it -v $(pwd):/mnt/workspace danielnehrig/nvim:latest nvim


# vim:ft=make
#
