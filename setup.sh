#/bin/sh

if [ "$(id -u)" = 0 ]; then
    echo "##################################################################"
    echo "This script MUST NOT be run as root user since it makes changes"
    echo "to the \$HOME directory of the \$USER executing this script."
    echo "The \$HOME directory of the root user is, of course, '/root'."
    echo "We don't want to mess around in there. So run this script as a"
    echo "normal user. You will be asked for a sudo password when necessary."
    echo "##################################################################"
    exit 1
fi

echo "enabled parrele downloads pacman"
sudo sed -i '/ParallelDownloads/s/^#//g' /etc/pacman.conf

echo "Updating repositories:"
sudo pacman -Syu
echo "Finished updating repositories!"

echo "Installing base-devel:"
sudo pacman -Syy --needed --noconfirm base-devel
echo "base-devel installed!"

echo "Installing yay:"
cd /tmp && git clone https://aur.archlinux.org/yay && cd /tmp/yay && makepkg -si
echo "Yay installed!"

cd ~

echo "installing apps"
sudo pacman -S firefox curl wget picom polybar alacritty nano neofetch nitrogen rofi breeze-gtk thunar lxappearance ttf-hack pacman-contrib --noconfirm
echo "apps installed!"


echo "enable pacchae.timer"
systemctl enable paccache.timer
echo "enabled paccahe.timer"


echo "adding fonts"
cd ~/dotfiles
mkdir -p ~/.fonts
cp -r .fonts/* ~/.fonts/

echo "setting up wallpaper"
mkdir -p ~/wallpaper
cp 211007-Wallpaper.jpg ~/wallpaper
nitrogen --set-auto ~/wallpaper/211007-Wallpaper.jpg

echo "Installing oh-my-zsh:"
sudo pacman -Sy zsh --noconfirm
echo "zsh installed"

# install oh-my-zsh
curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh --output install-oh-my-zsh.sh
sh install-oh-my-zsh.sh --unattended

# install powerlevel10k theme in oh-my-zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k
echo "Oh-my-zsh installed!"

echo "adding configs"
cd ~/dotfiles
mkdir -p ~/.config
cp -r .config/* ~/.config
cp .p10k.zsh ~/
cp .zshrc ~/

echo "set default shell to zsh"
chsh -s $(which zsh)
