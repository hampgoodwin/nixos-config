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
        gnumake
        ripgrep
        tree
        fzf
        fd
        ## text editors etc
        kitty
        ## containers
        docker
        colima
      ]
      # linux only and not darwin pkgs
      ++ lib.optionals pkgs.stdenv.isLinux [

      ]
      ++ lib.optionals config.developer.ai.enable [
        gemini-cli
      ];

    programs = lib.mkMerge [
      {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
        neovim = {
          enable = true;
          defaultEditor = true;
        };
      }
    ];

    services = {
      # Enable the OpenSSH daemon.
      openssh.enable = true;
    };
  };
}
