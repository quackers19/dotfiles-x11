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
sudo pacman -S firefox curl wget picom polybar alacritty nano neofetch nirtogen rofi breeze-gtk thunar lxappearance  pacman-contrib --noconfirm
echo "apps installed!"


echo "enable pacchae.timer"
systemctl enable paccache.timer
echo "enabled paccahe.timer"

echo "adding configs"
mkdir -p ~/.config
cp -r .config ~/

echo "adding fonts"
mkdir -p ~/.fonts
cp -r .fonts/* ~/.fonts/

echo "Installing oh-my-zsh:"
sudo pacman -Sy zsh --noconfirm
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k
echo "Oh-my-zsh installed!"

echo "set default shell to zsh"
chsh -s $(which zsh)
