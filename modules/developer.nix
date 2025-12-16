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
      # base languages/compilers
      zig # testing out if this will do the c compilation for us?
      # tools
      ## file transfer tools
      wget
      ## security
      ## command line
      ripgrep
      git
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

    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

  };
}
