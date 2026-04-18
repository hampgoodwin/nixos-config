{ pkgs, ... }:

{
  # Enable Niri compositor
  programs.niri.enable = true;

  # Enable Noctalia Shell
  programs.noctalia.enable = true;

  # System services often used/required by Noctalia features
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  environment.systemPackages = with pkgs; [
    kitty # terminal from hypr.nix
    xwayland-satellite # for X11 app support in Niri
  ];
}
