{ pkgs, config, ... }:

{
  config = {

    # enable gtk for dislpaying gtk windows
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    # hyprland
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    environment.systemPackages = with pkgs; [
      hyprpaper
      hypridle
      hyprlock
    ];
  };
}
