FROM testcab/yay
RUN yay --save --nocleanmenu --nodiffmenu --noconfirm -Syu
RUN yay --save --nocleanmenu --nodiffmenu --noconfirm -S neovim-git
RUN yay --save --nocleanmenu --nodiffmenu --noconfirm -S nodenv nodenv-node-build
RUN yay --save --nocleanmenu --nodiffmenu --noconfirm -S python python-pip rustup go lua luarocks
RUN nodenv install 16.4.2 \
  && nodenv global 16.4.2 \
  && nodenv rehash \
  && eval "$(nodenv init -)"
RUN rustup install nightly
RUN echo 'eval "$(nodenv init -)"' >> /home/makepkg/.bashrc
RUN echo 'PATH+="$HOME/.local/bin"' >> /home/makepkg/.bashrc
RUN echo 'PATH+="$HOME/.cargo/bin"' >> /home/makepkg/.bashrc
RUN echo 'PATH+="$HOME/go/bin"' >> /home/makepkg/.bashrc
RUN echo 'PATH+="$HOME/.local/lib/python3.9/site-packages"' >> /home/makepkg/.bashrc
COPY . /home/makepkg/.config/nvim/
RUN bash
RUN mkdir /home/makepkg/.config/nvim/plugin
RUN /home/makepkg/.config/nvim/packages.py
RUN nvim --headless +PackerSync +q

# Avoid container exit.
CMD ["tail", "-f", "/dev/null"]
