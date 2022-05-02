FROM testcab/yay
RUN yay --save --nocleanmenu --nodiffmenu --noconfirm -Syu
RUN yay --save --nocleanmenu --nodiffmenu --noconfirm -S neovim-git
RUN yay --save --nocleanmenu --nodiffmenu --noconfirm -S node python python-pip rustup go lua luarocks fzf ripgrep
RUN rustup install nightly
RUN echo 'PATH+=":$HOME/.local/bin"' >> /home/makepkg/.bashrc
RUN echo 'PATH+=":$HOME/.cargo/bin"' >> /home/makepkg/.bashrc
RUN echo 'PATH+=":$HOME/go/bin"' >> /home/makepkg/.bashrc
RUN echo 'PATH+=":$HOME/.local/lib/python3.9/site-packages"' >> /home/makepkg/.bashrc
COPY --chown=makepkg . /home/makepkg/.config/nvim/
RUN bash
RUN mkdir /home/makepkg/.config/nvim/plugin
RUN /home/makepkg/.config/nvim/packages.py
RUN nvim --headless\
  +'autocmd User PackerComplete sleep 100m | qall'\
  +PackerSync
RUN nvim --headless\
  +'autocmd User PackerComplete sleep 100m | qall'\
  +PackerSync
RUN nvim --headless\
  +'autocmd User PackerComplete sleep 100m | qall'\
  +PackerSync
# Avoid container exit.
WORKDIR /mnt/workspace
CMD ["tail", "-f", "/dev/null"]
