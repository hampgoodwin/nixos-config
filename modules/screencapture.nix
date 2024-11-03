{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
{
  imports = [ ];

  options = {
    screencapture = {
      enable = mkEnableOption "enable screencapture via hyprshot";
    };
  };

  config = mkIf config.screencapture.enable {
    environment.systemPackages = with pkgs; [
      hyprshot
      jq
      grim
      slurp
      wl-clipboard
      libnotify
    ];
  };
}
