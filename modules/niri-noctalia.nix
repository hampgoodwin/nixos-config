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
  ];
}
