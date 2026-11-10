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
      ai.enable = mkEnableOption "enable ai tools";
    };
  };

  config = mkIf config.developer.enable {
    environment.systemPackages =
      with pkgs;
      [
        # global languages / compilers
        zig # testing out if this will do the c compilation for us?
        # tools
        ## file transfer tools
        wget
        ## command line
        kitty-bin
        gnumake
        ripgrep
        tree
        fzf
        fd
        ## text editors etc
        tree-sitter
        ## containers
        docker
        colima
      ]
      # linux only and not darwin pkgs
      ++ lib.optionals pkgs.stdenv.isLinux [
        kitty
      ]
      ++ lib.optionals config.developer.ai.enable [
        antigravity-cli
        antigravity-acp
      ];

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      neovim = mkIf pkgs.stdenv.isLinux {
        enable = true;
        defaultEditor = true;
      };
    };

    services = mkIf pkgs.stdenv.isLinux {
      # Enable the OpenSSH daemon.
      openssh.enable = true;
    };
  };
}
