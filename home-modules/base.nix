{ pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./bash.nix
    ./direnv.nix
    ./git.nix
    ./smartcard.nix
    ./zed.nix
    ./zellij.nix
  ];

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    dig
    helix
    ripgrep
    nixfmt
    nmap
    opentofu
    tofu-ls
    tokei
    tree
    trivy
  ];

  home.stateVersion = "25.11";
}
