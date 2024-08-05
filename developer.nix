{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
{
  options = {
    developer.enable = mkEnableOption "enable audio";
  };
  config = mkIf config.developer.enable {
    programs = {
      neovim = {
        enable = true;
        defaultEditor = true;
      };
    };

    environment.systemPackages = with pkgs; [
      # programming
      ## go
      go
      gopls
      golangci-lint
      gofumpt
      delve
      ## rust
      rustup
      rust-analyzer
      ## node / js
      nodejs_22
      nodePackages.typescript-language-server
      eslint_d
      ## nix
      nil
      nixfmt-rfc-style
      ## lua
      lua
      luajitPackages.luarocks
      lua-language-server
      stylua
      ## bash
      shellcheck
      nodePackages.bash-language-server
      # tools
      libgcc
      clang
      gnumake
      ripgrep
      git
      bat
      kitty
      zellij
      tree
      zoxide
      fzf
      ollama
      eza
      zoxide
      fd
      delta
      tlrc
    ];

  };
}
