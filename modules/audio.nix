{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
{
  options = {
    audio = {
      enable = mkEnableOption "enable audio";
      bluetooth.enable = mkEnableOption "enable bluetooth";
      packages.enable = mkEnableOption "enable audio packages";
      lowLatency.enable = mkEnableOption "low latency";
      recordingSuite.enable = mkEnableOption "recording suite";
    };
  };

  config = mkIf config.audio.enable {
    # enable bluetooth
    hardware.bluetooth = mkIf config.audio.bluetooth.enable {
      enable = true;
      powerOnBoot = true;
      settings.General.Enable = "Source,Sink,Media,Socket";
    };

    # rtkit is optional but recommended
    security.rtkit.enable = true;

    # system packages
    # pipewire
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      # configure for bluetooth
      wireplumber = {
        extraConfig = {
          "monitor.bluez.properties" = {
            "bluez5.enable-sbc-xq" = true;
            "bluez5.enable-msbc" = true;
            "bluez5.enable-hw-volume" = true;
            "bluez5.roles" = [
              "hsp_hs"
              "hsp_ag"
              "hfp_hf"
              "hfp_ag"
            ];
          };
        };
      };

      # configure extra low latency
      extraConfig.pipewire."92-low-latency" = mkIf config.audio.lowLatency.enable {
        context.properties = {
          default.clock.rate = 48000;
          default.clock.quantum = 32;
          default.clock.min-quantum = 32;
          default.clock.max-quantum = 32;
        };
      };
    };

    environment.systemPackages =
      with pkgs;
      mkIf config.audio.packages.enable [
        wireplumber
        pavucontrol
        qpwgraph
        spotify
        spotify-qt
      ];
  };
}
