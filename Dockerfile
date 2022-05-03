FROM archlinux/archlinux:latest
RUN pacman -Syy

RUN pacman -S --needed --noconfirm sudo base-devel # Install sudo
RUN useradd builduser -m # Create the builduser
RUN passwd -d builduser # Delete the buildusers password
RUN printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers # Allow the builduser passwordless sudo

RUN pacman --noconfirm -S git lolcat bat nodejs npm python python-pip rustup lua go luarocks ripgrep
RUN sudo -u builduser bash -c 'cd ~ && git clone https://aur.archlinux.org/yay-git.git && cd yay-git && makepkg -si --noconfirm' # Clone and build a package
RUN rm -rf yay-git
RUN sudo -u builduser yay --save --nocleanmenu --nodiffmenu --noconfirm -Syu
RUN sudo -u builduser yay --save --nocleanmenu --nodiffmenu --noconfirm -S neovim-git
RUN rustup install nightly
RUN echo 'PATH+=":$HOME/.local/bin"' >> /root/.bashrc
RUN echo 'PATH+=":$HOME/.cargo/bin"' >> /root/.bashrc
RUN echo 'PATH+=":$HOME/go/bin"' >> /root/.bashrc
RUN echo 'PATH+=":$HOME/.local/lib/python3.9/site-packages"' >> /root/.bashrc
RUN echo 'PATH+=":$HOME/root/.luarocks/bin"' >> /root/.bashrc
RUN echo 'export npm_config_prefix="$HOME/.local"' >> /root/.bashrc
RUN npm set prefix="$HOME/.local"
RUN sudo -u builduser yay -Sc --noconfirm
COPY . /root/.config/nvim/
SHELL ["/bin/bash", "-c"]
RUN /root/.config/nvim/packages.py
# flakey for some reason --headless packersync does not work like without headless
RUN nvim --headless\
  +'autocmd User PackerComplete sleep 100m | qall'\
  +PackerSync
RUN nvim --headless\
  +'autocmd User PackerComplete sleep 100m | qall'\
  +PackerSync
RUN nvim --headless\
  +'autocmd User PackerComplete sleep 100m | qall'\
  +PackerSync
RUN nvim --headless +'TSInstall rust go lua dockerfile yaml typescript javascript java tsc tsdoc c org scss css toml make json html php' +'sleep 20' +qa
# Avoid container exit.
WORKDIR /mnt/workspace
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["source /root/.bashrc", "&&", "tail", "-f", "/dev/null"]

