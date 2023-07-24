# This is the build container image
FROM archlinux/archlinux:latest as build
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
RUN /root/.config/nvim/packages.py --sudo builduser --debug

RUN nvim --headless\
  +'autocmd User LazyInstall sleep 100m | qall'
RUN nvim --headless\
  +'autocmd User LazySync sleep 100m | qall'\
  +"Lazy sync"

# Create a run image / container with minimal size. use alpine
FROM alpine:latest as main
# Copy files from build container to run container.

COPY --from=build /root/.config/nvim /root/.config/nvim
COPY --from=build /root/.local /root/.local
COPY --from=build /root/go /root/go
COPY --from=build /root/.cargo /root/.cargo
COPY --from=build /usr/sbin/node /bin/node
COPY --from=build /usr/sbin/nvim /bin/nvim
COPY --from=build /usr/sbin/go /bin/go
COPY --from=build /usr/sbin/rustup /bin/rustup
COPY --from=build /usr/sbin/rustc /bin/rustc
COPY --from=build /usr/sbin/cargo /bin/cargo
COPY --from=build /usr/sbin/lua /bin/lua
COPY --from=build /usr/lib/lua-language-server /usr/lib/lua-language-server
COPY --from=build /usr/sbin/lua-language-server /bin/lua-language-server

# Avoid container exit.
WORKDIR /mnt/workspace
EXPOSE 5555
ENTRYPOINT ["/bin/bash", "-c", "source /root/.bashrc && nvim"]
CMD ["tail", "-f", "/dev/null"]
