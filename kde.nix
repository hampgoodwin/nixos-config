{ pkgs, config, ... }:

{
  config = {

    services.xserver.enable = true;

    services.desktopManager.plasma6.enable = true;
  };
}