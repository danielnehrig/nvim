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

build:
	docker build . -t nvim:test

dev:
	docker run -it --entrypoint /bin/bash -v $(pwd):/mnt/workspace danielnehrig/nvim:test -c "source /root/.bashrc && nvim"

run:
	docker run -it --entrypoint /bin/bash -v $(pwd):/mnt/workspace danielnehrig/nvim:latest -c "source /root/.bashrc && nvim"


# vim:ft=make
#
