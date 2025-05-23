#!/bin/bash

# Install Python package
sudo pip install pylrc --break-system-packages --root-user-action

# Install packages with paru and pacman
paru -S rust-nightly-bin gtk3 --noconfirm
sudo pacman -S --noconfirm base-devel libconfig libev libxdg-basedir pcre pixman \
  xcb-util-image xcb-util-renderutil hicolor-icon-theme libglvnd libx11 libxcb \
  libxext libdbus asciidoc uthash

# Build and install eww
cd ~/Downloads
git clone https://github.com/elkowar/eww.git
cd eww
cargo build --release -j "$(nproc)"
sudo mv target/release/eww /usr/bin/eww
cd ~

# Build and install xqp
cd ~/Downloads
git clone https://github.com/baskerville/xqp.git
cd xqp
make
sudo make install
cd ~

# Build and install custom picom
cd ~/Downloads
git clone https://github.com/pijulius/picom.git
cd picom
meson --buildtype=release . build --prefix=/usr -Dwith_docs=true
sudo ninja -C build install
cd ~

# Add user to adm group and enable services
sudo usermod -aG adm "$USER"
sudo systemctl enable --now com.system76.PowerDaemon
sudo systemctl enable bluetooth

# Install GTK theme
cd ~/Downloads
git clone https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme.git
cd Tokyo-Night-GTK-Theme/
sudo mv themes/Tokyonight-Dark-BL /usr/share/themes/
cd ~

# Copy hotfiles (dotfiles setup)
cd ~/Downloads
git clone https://github.com/syndrizzle/hotfiles.git -b bspwm
cd hotfiles
cp -r .config .scripts .local .cache .wallpapers ~/
cp .xinitrc .gtkrc-2.0 ~/
cd .fonts
sudo mv * /usr/share/fonts
cd ../etc
sudo mv slim.conf environment /etc/
sudo cp -r ../usr/* /usr/

read -p "Reboot Now (y/n)?" choice
case "$choice" in 
  y|Y ) reboot now;;
  n|N ) echo "fine, Goodbye...";;
  * ) echo "fine, Goodbye...";;
esac

