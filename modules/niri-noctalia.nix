{ pkgs, inputs, ... }:

{
  # Enable Niri compositor
  programs.niri.enable = true;

  # System services often used/required by Noctalia features
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    xwayland-satellite # for X11 app support in Niri
    xdg-utils # for xdg-open etc
  ];

  xdg.portal = {
    enable = true;
    config = {
      common.default = [ "gtk" ];
      niri = {
        default = [ "gtk" "gnome" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
  };

  xdg.mime.defaultApplications = { };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    GTK_USE_PORTAL = "1";
  };
}
