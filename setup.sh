#/bin/bash

print_message "Updating repositories:"
sudo pacman -Syu
print_message "Finished updating repositories!"

print_message "Installing base-devel:"
sudo pacman -Syy --needed --noconfirm base-devel
print_message "base-devel installed!"

print_message "Installing yay:"
cd /tmp && git clone https://aur.archlinux.org/yay && cd /tmp/yay && makepkg -si
print_message "Yay installed!"