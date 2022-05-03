FROM archlinux/archlinux:latest
COPY . /root/.config/nvim/

RUN pacman -Sy \
  && pacman -S --needed --noconfirm sudo base-devel # Install sudo
RUN useradd builduser -m # Create the builduser
RUN passwd -d builduser # Delete the buildusers password
RUN printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers # Allow the builduser passwordless sudo

RUN pacman -S --needed --noconfirm git lolcat bat nodejs npm python python-pip rustup lua go luarocks ripgrep
RUN sudo -u builduser bash -c 'cd ~ && git clone https://aur.archlinux.org/yay-git.git && cd yay-git && makepkg -si --noconfirm' \
  && rm -rf yay-git
RUN sudo -u builduser yay --save --nocleanmenu --nodiffmenu --noconfirm -Syu \
  && sudo -u builduser yay --save --nocleanmenu --nodiffmenu --noconfirm -S neovim-git \
  && rustup install nightly
RUN echo 'PATH+=":$HOME/.local/bin"' >> /root/.bashrc \
  && echo 'PATH+=":$HOME/.cargo/bin"' >> /root/.bashrc \
  && echo 'PATH+=":$HOME/go/bin"' >> /root/.bashrc \
  && echo 'PATH+=":$HOME/.local/lib/python3.9/site-packages"' >> /root/.bashrc \
  && echo 'PATH+=":$HOME/root/.luarocks/bin"' >> /root/.bashrc \
  && echo 'export npm_config_prefix="$HOME/.local"' >> /root/.bashrc \
  && npm set prefix="$HOME/.local"
RUN sudo -u builduser yay -Sc --noconfirm
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
RUN nvim --headless +'TSInstall bash python cpp rust go lua dockerfile yaml typescript javascript java tsx tsdoc c org scss css toml make json html php' +'sleep 30' +qa
# Avoid container exit.
WORKDIR /mnt/workspace
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["tail", "-f", "/dev/null"]

