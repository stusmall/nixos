These are my NixOS configs.  There isn't much here that is useful for anyone else.  Feel free to look around and borrow
snippets as you see fit.  I wouldn't bother trying to use them as is to configure your own systems, unless you have a 
laptop identical to mine and really want the username "stusmall".

The bootstrap.sh script is used to create links as needed.  It will link from /etc/nixos/configuration.nix to the 
relevant entry point.  Each system I have has its own entry point (desktop.nix, dell.nix, etc) which will then import
base.nix and then any other modules it needs.