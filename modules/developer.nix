{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
{
  options = {
    developer = {
      enable = mkEnableOption "enable developer applications";
    };
  };
  config = mkIf config.developer.enable {
    environment.systemPackages = with pkgs; [
      # programming
      ## go
      go
      gopls
      golangci-lint
      gofumpt
      delve
      ## rust
      cargo
      rustc
      rust-analyzer
      ## node / js
      nodejs_22
      typescript
      typescript-language-server
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
      bash-language-server

      # tools
      ## build
      libgcc
      clang
      gnumake
      ## command line
      ripgrep
      git
      tree
      zoxide
      fzf
      eza
      fd
      delta
      tlrc
      ## text editors etc
      neovim
      bat
      kitty
      zellij
    ];

  };
}
