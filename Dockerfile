FROM archlinux/archlinux:latest
ARG version=neovim
COPY . /root/.config/nvim/

RUN pacman -Sy \
  && pacman -S --needed --noconfirm sudo base-devel
RUN useradd builduser -m \
  && passwd -d builduser \
  && printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers

RUN pacman -S --needed --noconfirm git lolcat bat nodejs npm python python-pip rustup lua go luarocks ripgrep
RUN sudo -u builduser bash -c 'cd ~ && git clone https://aur.archlinux.org/yay-git.git && cd yay-git && makepkg -si --noconfirm' \
  && rm -rf yay-git \
  && pacman -Sc \
  && rustup install nightly \
  && echo 'PATH+=":$HOME/.local/bin"' >> /root/.bashrc \
  && echo 'PATH+=":$HOME/.cargo/bin"' >> /root/.bashrc \
  && echo 'PATH+=":$HOME/go/bin"' >> /root/.bashrc \
  && echo 'PATH+=":$HOME/.local/lib/python3.9/site-packages"' >> /root/.bashrc \
  && echo 'PATH+=":$HOME/root/.luarocks/bin"' >> /root/.bashrc \
  && echo 'export npm_config_prefix="$HOME/.local"' >> /root/.bashrc \
  && npm set prefix="$HOME/.local"
RUN sudo -u builduser yay -S --noconfirm ${version}
RUN /root/.config/nvim/packages.py --sudo builduser

# flakey for some reason --headless packersync does not work like without headless
RUN nvim --headless\
  +'autocmd User PackerComplete sleep 100m | qall'
RUN nvim --headless\
  +'autocmd User PackerComplete sleep 100m | qall'\
  +PackerSync
RUN nvim --headless +'TSInstall bash python cpp rust go lua dockerfile yaml typescript javascript java tsx tsdoc c org scss css toml make json html php' +'sleep 30' +qa
# Avoid container exit.
WORKDIR /mnt/workspace
EXPOSE 5555
ENTRYPOINT ["/bin/bash", "-c", "source /root/.bashrc && nvim"]
CMD ["tail", "-f", "/dev/null"]

