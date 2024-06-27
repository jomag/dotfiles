gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Works well on my 4k LG monitor...
gsettings set org.gnome.desktop.interface text-scaling-factor 1.2

# Install extension manager and extensions
sudo apt install -y gnome-shell-extension-manager pipx
pipx install gnome-extensions-cli --system-site-packages


