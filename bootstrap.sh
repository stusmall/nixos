#!/usr/bin/env bash
set -euo pipefail

echo "Running the initial set up of the system..."
REPO_ROOT=$(dirname "$0")
echo "Setting symlinks to point to $REPO_ROOT"


echo "Which machine are we setting up?"
MACHINES=("Desktop" "New System" "Exit")
select MACHINE in "${MACHINES[@]}"; do
  case $MACHINE in
    "Desktop")
      echo "Setting hardware config symlink"
      sudo rm -f /etc/nixos/hardware-configuration.nix || true
      sudo ln -s "$REPO_ROOT"/hardware-configuration/desktop.nix /etc/nixos/hardware-configuration.nix
      break
      ;;
    "New System")
      echo "Skipping setting up a hardware config symlink"
      break
      ;;
    "Exit")
      echo "Cancelling setup"
      exit
      ;;
    *) echo -e "Invalid selection.  Please try again";;
esac
done

echo "Setting home-manager symlink"
mkdir -p /home/stusmall/.config/home-manager/
rm -f /home/stusmall/.config/home-manager/home.nix || true
ln -s "$REPO_ROOT"/home.nix /home/stusmall/.config/home-manager/home.nix

echo "Setting configuration symlink"
sudo rm -f /etc/nixos/configuration.nix || true
sudo ln -s "$REPO_ROOT"/configuration.nix /etc/nixos/configuration.nix

echo "All done!"