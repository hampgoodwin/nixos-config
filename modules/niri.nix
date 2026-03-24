{ pkgs, config, ... }:

{
  config = {
    # hyprland
    programs.niri = {
      enable = true;
    };
  };
}
