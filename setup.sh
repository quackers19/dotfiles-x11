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

echo "adding user to groups and fixing backlight"
sudo usermod -a -G video $USER 
cd ~/dotfiles-x11
sudo cp backlight.rules /etc/udev/rules.d/

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
sudo pacman -S i3-wm wmctrl maim dunst nm-connection-editor firefox curl wget ncdu picom polybar tlp-rdw alacritty nano neofetch nitrogen rofi breeze-gtk thunar lxappearance ttf-hack pacman-contrib htop openssh iwd wireless_tools wpa_supplicant smartmontools xdg-utils i3lock i3status i3blocks xterm sddm dkms xorg-server xorg-xinit tlp --noconfirm
sudo pacman -S zip bluez bluez-utils xorg-xbacklight xbindkeys zsh-syntax-highlighting --noconfirm
yay -S archlinux-themes-sddm --noconfirm
echo "apps installed!"


echo "graphics drivers installng"
sudo pacman -S intel-media-driver mesa vulkan-intel xf86-video-intel --noconfirm

echo "enable pacchae.timer and disk trim"
systemctl enable paccache.timer fstrim.timer sddm.service tlp.service bluetooth.service
systemctl mask systemd-rfkill.service systemd-rfkill.socket
echo "enabled paccahe.timer and disk trim"

read -p "Do you want to enable systemmd boot auto update? (yes/no) " yn

case $yn in 
	yes ) systemctl enable systemd-boot-update.service;;
	no ) echo exiting...;;
	* ) echo invalid response;;
esac


read -p "Do you want to install other apps spotify discord vpn ect? (yes/no) " yn

case $yn in 
	yes ) yay -S spotify-launcher discord cloudflare-warp-bin --noconfirm
	systemctl enable warp-svc.sevice
	;;
	no ) echo exiting...;;
	* ) echo invalid response;;
esac



echo "adding fonts"
cd ~/dotfiles-x11
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
echo "Oh-my-zsh installed!"

echo "adding configs"
cd ~/dotfiles-x11
mkdir -p ~/.config
cp -r .config/* ~/.config
cp .p10k.zsh ~/
cp .zshrc ~/
cp .Xinitrc ~/
cp .Xresources ~/
cp .xbindkeysrc ~/
sudo cp default.conf /etc/

echo "set default shell to zsh"
chsh -s $(which zsh)
