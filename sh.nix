{ pkgs, config, ... }:

{
  programs.zsh = {
    enable = true;
    loginShellInit = "Hyprland";
  };
}
