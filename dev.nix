{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = { };
  options = { };

  config = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    environment.systemPackages = with pkgs; [
      # languages, linters, formatters, language-servers, and debuggers
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
    ];
  };

}
