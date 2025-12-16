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
      # global languages / compilers
      zig # testing out if this will do the c compilation for us?
      # tools
      ## file transfer tools
      wget
      ## command line
      ripgrep
      tree
      fzf
      fd
      ## text editors etc
      bat
      kitty
      ## containers
      gnumake
      docker
      colima
    ];

    programs = {
      git = {
        enable = true;
        config = {
          init.defaultBranch = "main";
          user = {
            name = "hampgoodwin";
            email = "hampgoodwin@gmail.com";
          };
        };
      };
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      neovim = {
        enable = true;
        defaultEditor = true;
      };
    };

  };
}
