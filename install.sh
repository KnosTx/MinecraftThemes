#!/bin/bash

clear

installTheme(){
    cd /var/www/
    tar -cvf MinecraftThemesbackup.tar.gz pterodactyl
    echo "Installing theme..."
    cd /var/www/pterodactyl
    rm -r MinecraftThemes
    git clone https://github.com/NurAzliYT/MinecraftThemes.git
    cd MinecraftThemes
    rm /var/www/pterodactyl/resources/scripts/MinecraftThemes.css
    rm /var/www/pterodactyl/resources/scripts/index.tsx
    mv index.tsx /var/www/pterodactyl/resources/scripts/index.tsx
    mv MinecraftThemes.css /var/www/pterodactyl/resources/scripts/MinecraftThemes.css
    cd /var/www/pterodactyl

    curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    apt update
    apt install -y nodejs

    npm i -g yarn
    yarn

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear


}

installThemeQuestion(){
    while true; do
        read -p "Are you sure that you want to install the theme [y/n]? " yn
        case $yn in
            [Yy]* ) installTheme; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

repair(){
    bash <(curl https://raw.githubusercontent.com/NurAzliYT/MinecraftThemes/master/repair.sh)
}

restoreBackUp(){
    echo "Restoring backup..."
    cd /var/www/
    tar -xvf MinecraftThemesbackup.tar.gz
    rm MinecraftThemesbackup.tar.gz

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear
}
echo "Copyright (c) 2024 NurAzliYT | github.com/NurAzliYT"
echo "This program is free software: you can redistribute it and/or modify"
echo ""
echo "[1] Install theme"
echo "[2] Restore backup"
echo "[3] Repair panel (use if you have an error in the theme installation)"
echo "[4] Exit"

read -p "Please enter a number: " choice
if [ $choice == "1" ]
    then
    installThemeQuestion
fi
if [ $choice == "2" ]
    then
    restoreBackUp
fi
if [ $choice == "3" ]
    then
    repair
fi
if [ $choice == "4" ]
    then
    exit
fi
