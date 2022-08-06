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

print_message "Updating repositories:"
sudo pacman -Syu
print_message "Finished updating repositories!"

print_message "Installing base-devel:"
sudo pacman -Syy --needed --noconfirm base-devel
print_message "base-devel installed!"

print_message "Installing yay:"
cd /tmp && git clone https://aur.archlinux.org/yay && cd /tmp/yay && makepkg -si
print_message "Yay installed!"

cd ~

print_message "Installing oh-my-zsh:"
sudo pacman -Sy zsh --noconfirm
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k
print_message "Oh-my-zsh installed!"

print_message "installing apps"
sudo pacman -S firefox curl wget picom polybar alacritty nano neofetch nirtogen rofi breeze-gtk thunar lxappearance  pacman-contrib --noconfirm
print_message "apps installed!"


print_message "enable pacchae.timer"
systemctl enable paccache.timer
print_message "enabled paccahe.timer"
