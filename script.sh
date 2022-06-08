#!/usr/bin/sh

# OpenSUSE Install Script by tduck973564
# Makes life a little bit easier

echo CD into home directory
cd ~

echo Adding Flathub to Flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo Installation of Packman
sudo zypper ar -cfp 90 https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman
sudo zypper dup --from packman --allow-vendor-change

echo Patch GNOME
echo "[Settings]\ngtk-hint-font-metrics=1" >> ~/.config/gtk-4.0/settings.ini
sudo zypper ar https://download.opensuse.org/repositories/home:/tjyrinki_suse:/branches:/openSUSE:/Factory/openSUSE_Tumbleweed/home:tjyrinki_suse:branches:openSUSE:Factory.repo

echo Update System before continuing
sudo zypper up

echo Installation of Oh My Zsh!
sudo zypper in zsh git
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
chsh -s /usr/bin/zsh
sed -e s/robbyrussell/lukerandall/ ~/.zshrc > ~/.zshrc.tmp && mv ~/.zshrc.tmp ~/.zshrc

echo Installation of GitHub CLI and setup of Git
sudo zypper addrepo https://cli.github.com/packages/rpm/gh-cli.repo
sudo zypper ref
sudo zypper in gh
sh -c "gh auth login"

echo "Type in your git username: "
read GITUSERNAME
echo "Type in your git email: "
read GITEMAIL

git config --global user.name $GITUSERNAME
git config --global user.email  $GITEMAIL

echo Installation of VSCode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
sudo zypper ref
sudo zypper in code

echo Installation of Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable --profile default -y

echo Installation of Python
pip install --upgrade pip
pip install pylint
curl -sSL https://install.python-poetry.org | python3 -

echo Installation of TypeScript and JavaScript
sudo zypper in nodejs16
sudo npm install -g typescript npm

echo Installation of Java
sudo zypper in java-17-openjdk java-17-openjdk-devel

echo Installation of build-essential equivalent, clang, Meson and Ninja
sudo zypper in make automake gcc gcc-c++ kernel-devel clang clang-tools meson ninja

echo Installation of JetBrains
curl -fsSL https://raw.githubusercontent.com/nagygergo/jetbrains-toolbox-install/master/jetbrains-toolbox.sh | bash
jetbrains-toolbox

echo Installation of VSCode extensions
code --install-extension ms-python.python
code --install-extension VisualStudioExptTeam.vscodeintellicode
code --install-extension vadimcn.vscode-lldb
code --install-extension icrawl.discord-vscode
code --install-extension rust-lang.rust-analyzer
code --install-extension serayuzgur.crates
code --install-extension bungcip.better-toml
code --install-extension emilast.LogFileHighlighter
code --install-extension wakatime.vscode-wakatime
code --install-extension michelemelluso.code-beautifier
code --install-extension mrmlnc.vscode-scss
code --install-extension ritwickdey.liveserver
code --install-extension ritwickdey.live-sass
code --install-extension github.vscode-pull-request-github
code --install-extension eamodio.gitlens
code --install-extension ms-vscode.cpptools-extension-pack
code --install-extension ms-vscode.makefile-tools
code --install-extension mesonbuild.mesonbuild
code --uninstall-extension ms-vscode.cpptools
code --install-extension llvm-vs-code-extensions.vscode-clangd

echo Set VSCode settings

echo Installation of miscellaneous useful apps
sudo zypper in discord ffmpeg pavucontrol easyeffects gnome-tweaks rhythmbox firewall-config
sudo flatpak install -y com.github.tchx84.Flatseal org.gnome.Extensions

echo Log into accounts on web browser
firefox https://accounts.google.com/
firefox https://login.microsoftonline.com/
firefox https://discord.com/app
firefox https://github.com/login

echo Make some folders
mkdir ~/Repositories
mkdir ~/Coding
mkdir ~/Games

echo Install onedrive
sudo zypper in onedrive
onedrive --synchronize
systemctl --user enable onedrive
systemctl --user start onedrive

echo Download icon theme and fonts
sudo zypper addrepo https://ftp.lysator.liu.se/pub/opensuse/repositories/M17N:/fonts/openSUSE_Tumbleweed/ fonts-x86_64
sudo zypper in papirus-icon-theme fira-code-fonts ibm-plex-sans-fonts ibm-plex-mono-fonts ibm-plex-serif-fonts inter-fonts materia-gtk-theme

echo Dotfiles
git clone https://github.com/tduck973564/dotfiles ~/.dotfiles
echo ". ~/.dotfiles/.aliases" >> ~/.zshrc

echo "Fix inconsistent GNOME 42 theming; you will need to enable the theme in tweaks"
sudo zypper in sassc
cd ~/Repositories
git clone https://github.com/lassekongo83/adw-gtk3
cd adw-gtk3
meson build
sudo ninja -C build install
cd ~
sudo flatpak install -y org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark

echo Install firefox theme
cd ~/Repositories
git clone https://github.com/rafaelmardojai/firefox-gnome-theme
cd firefox-gnome-theme
./scripts/auto-install.sh
cd ~

echo Remove some crapware 
sudo zypper rm gnome-music gnome-screenshot pidgin git-gui 

echo -e '\nDone!'
