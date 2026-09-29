{
  lib,
  pkgs,
  pkgs-stable,
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
    boot.kernelModules = [ "v4l2loopback" ];
    boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

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
        enable = true;
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
    };

    environment.systemPackages = lib.concatLists [
      (lib.optionals config.audio.enable [
        pkgs.pulseaudio
        pkgs.wireplumber
        pkgs.pavucontrol
        pkgs.qpwgraph
        # pkgs.sonusmix # rmv due to lack of maint
      ])

      (lib.optionals (config.audio.enable && config.audio.recordingSuite.enable) [
        pkgs.reaper
        pkgs.alsa-scarlett-gui
        pkgs.neural-amp-modeler-lv2
        pkgs.calf
        pkgs.lsp-plugins
      ])
    ];

    programs.obs-studio = mkIf config.audio.recordingSuite.enable {
      enable = true;
      enableVirtualCamera = true;
    };

  };
}
