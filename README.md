# Dotfiles
All the dotfiles are in folder 

- Windows Manager: i3
- Theme: breeze-gtk
- Run: rofi
- Editor: nano
- Bar: polybar
- Composter: picom
- Shell: zsh with powerline10k
- Terminal: alacritty
- File manger: Thunar
- Wallpaper manger: nitrogen


Wll add screen shots later


Notes about post-install tweaks
- install breeze-gtk for theme then install and use lxapearance to switch
- make sure to install pacman-contrib and enable paccache.timer this clear pacman cache every week
  - use systemctl enable paccache.timer
- enable parallel downloads in pacman.conf
- install reflector to sync pacman download mirrors
  - enable reflector.service so it syncs on boot
