#!/usr/bin/env bash
set -euo pipefail

echo "Running the initial set up of the system..."
REPO_ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null &&  pwd )
echo "Setting symlinks to point to $REPO_ROOT"


echo "Which machine are we setting up?"
MACHINES=("Desktop" "Dell" "New System" "Exit")
select MACHINE in "${MACHINES[@]}"; do
  case $MACHINE in
    "Desktop")
      echo "Setting configuration.nix symlink"
      sudo rm -f /etc/nixos/configuration.nix || true
      sudo rm -f /etc/nixos/hardware-configuration.nix || true
      sudo ln -s "$REPO_ROOT"/desktop.nix /etc/nixos/configuration.nix
      break
      ;;
    "Dell")
      echo "Setting configuration.nix symlink"
      sudo rm -f /etc/nixos/configuration.nix || true
      sudo rm -f /etc/nixos/hardware-configuration.nix || true
      sudo ln -s "$REPO_ROOT"/dell.nix /etc/nixos/configuration.nix
      break
      ;;
    "New System")
      echo "Skipping setting up hardware/profile config symlinks"
      break
      ;;
    "Exit")
      echo "Cancelling setup"
      exit
      ;;
    *) echo -e "Invalid selection.  Please try again";;
esac
done

echo "Setting up channels"
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
sudo nix-channel --update

echo "Rebuilding the OS"
sudo nixos-rebuild boot

echo "All done!"
