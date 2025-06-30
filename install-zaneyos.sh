#!/usr/bin/env bash

if [ -n "$(grep -i nixos < /etc/os-release)" ]; then
  echo "Verified this is NixOS."
  echo "-----"
else
  echo "This is not NixOS or the distribution information is not available."
  exit
fi

if command -v git &> /dev/null; then
  echo "Git is installed, continuing with installation."
  echo "-----"
else
  echo "Git is not installed. Please install Git and try again."
  echo "Example: nix-shell -p git"
  exit
fi

echo "Default options are in brackets []"
echo "Just press enter to select the default"
sleep 2

echo "-----"

echo "Ensure In Home Directory"
cd || exit

echo "-----"

read -rp "Enter Your New Hostname: [ fuckotheclown ] " hostName
if [ -z "$hostName" ]; then
  hostName="fuckotheclown"
fi

echo "-----"

read -rp "Enter Your Hardware Profile (GPU)
Options:
nvidia-laptop
vm
Please type out your choice: " profile
if [ -z "$profile" ]; then
  profile="nvidia-laptop"
fi

echo "-----"

backupname=$(date "+%Y-%m-%d-%H-%M-%S")
if [ -d "nix_config" ]; then
  echo "nix_config exists, backing up to .config/nix_config-backups folder."
  if [ -d ".config/nix_config-backups" ]; then
    echo "Moving current version of nix_config to backups folder."
    mv "$HOME"/nix_config .config/nix_config-backups/"$backupname"
    sleep 1
  else
    echo "Creating the backups folder & moving nix_config to it."
    mkdir -p .config/nix_config-backups
    mv "$HOME"/nix_config .config/nix_config-backups/"$backupname"
    sleep 1
  fi
else
  echo "Thank you for choosing my nix_config."
  echo "I hope you find your time here enjoyable!"
fi

echo "-----"

echo "Cloning & Entering nix_config Repository"
git clone https://github.com/vaibhav-mattoo/nix_config.git
cd nix_config || exit
mkdir hosts/"$hostName"
cp hosts/default/*.nix hosts/"$hostName"
installusername=$(echo $USER)
git config --global user.name "$installusername"
git config --global user.email "$installusername@gmail.com"
git add .
git config --global --unset-all user.name
git config --global --unset-all user.email
sed -i "/^\s*host[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$hostName\"/" ./flake.nix
sed -i "/^\s*profile[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$profile\"/" ./flake.nix


read -rp "Enter your keyboard layout: [ us ] " keyboardLayout
if [ -z "$keyboardLayout" ]; then
  keyboardLayout="us"
fi

sed -i "/^\s*keyboardLayout[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$keyboardLayout\"/" ./hosts/$hostName/variables.nix

echo "-----"

read -rp "Enter your console keymap: [ us ] " consoleKeyMap
if [ -z "$consoleKeyMap" ]; then
  consoleKeyMap="us"
fi

sed -i "/^\s*consoleKeyMap[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$consoleKeyMap\"/" ./hosts/$hostName/variables.nix

echo "-----"

sed -i "/^\s*username[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$installusername\"/" ./flake.nix

echo "-----"

echo "Generating The Hardware Configuration"
sudo nixos-generate-config --show-hardware-config > ./hosts/$hostName/hardware.nix

echo "-----"

echo "Setting Required Nix Settings Then Going To Install"
NIX_CONFIG="experimental-features = nix-command flakes"

echo "-----"

sudo nixos-rebuild switch --flake ~/nix_config/#${profile}
