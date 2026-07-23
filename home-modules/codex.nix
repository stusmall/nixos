{ pkgs, lib, ... }:
let
  unstable_pkgs = import (pkgs.fetchgit {
    name = "nixpkgs-unstable-jul-22-2026";
    url = "https://github.com/nixos/nixpkgs/";
    rev = "f361a82ad8e4170a3bcdcfa7816206d8f5fd066e";
    hash = "sha256-wtTh6wGaU6cLx4jeLMGn1JgiIJNqyHA9pnJXqH413fo=";
  }) { };
in
{
  home.packages = with pkgs; [
    burpsuite
    playwright-mcp
    mcp-proxy
  ];

  programs.codex = {
    enable = true;
    package = unstable_pkgs.codex;
    settings = {
      model_provider = "local";
      model = "qwen3.5:9b";
      model_providers = {
        local = {
          name = "Ollama";
          base_url = "http://localhost:11434/v1";
        };
      };
      mcp_servers = {
        playwright = {
          command = "${pkgs.playwright-mcp}/bin/playwright-mcp";
        };
        burpsuite = {
          command = "mcp-proxy";
          args = [
            "--transport"
            "sse"
            "http://127.0.0.1:9876/"
          ];
        };
      };
    };
  };
}
