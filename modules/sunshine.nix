{
  lib,
  pkgs,
  config,
  ...
}:

{
  config = {

    services.sunshine = {
      enable = true;
      settings = {
        # min_log_level = "verbose";
        address_family = "both";
      };
      applications = {
        env = {
          PATH = "$(PATH):$(HOME)/.local/bin";
        };
        apps = [
          {
            name = "Desktop 2560x1440@240";
            image-path = "desktop.png";
            prep-cmd = [
              {
                do = ''
                  ${pkgs.hyprland}/bin/hyprctl keyword monitor desc:Samsung Electric Company LC49G95T H4ZNC02666,2560x1440@240,0x0,1
                '';
                undo = "${pkgs.hyprland}/bin/hyprctl keyword monitor desc:Samsung Electric Company LC49G95T H4ZNC02666,5120x1440@240,0x0,1";
              }
            ];
            exclude-global-prep-cmd = "false";
            auto-detach = "true";
          }
          {
            name = "Steam 2560x1440@240";
            image-path = "steam.png";
            output = "${config.users.users.hamp.home}/logs/sunshine/steam.log";
            working-dir = "/run/current-system/sw/bin";
            prep-cmd = [
              {
                do = ''
                  hyprctl keyword monitor desc:Samsung Electric Company LC49G95T H4ZNC02666,5120x1440@240,0x0,1
                '';
                undo = "hyprctl keyword monitor desc:Samsung Electric Company LC49G95T H4ZNC02666,5120x1440@240,0x0,1";
              }
            ];
            exclude-global-prep-cmd = "false";
            detached = [ "setsid -c steam steam://open/bigpicture" ];
            auto-detach = "true";
          }
          {
            name = "Kitty 2560x1440@240";
            # image-path = "";
            output = "${config.users.users.hamp.home}/logs/sunshine/kitty.log";
            working-dir = "/run/current-system/sw/bin";
            prep-cmd = [
              {
                do = ''
                  hyprctl keyword monitor desc:Samsung Electric Company LC49G95T H4ZNC02666,2560x1440@120,0x0,1
                '';
                undo = "hyprctl keyword monitor desc:Samsung Electric Company LC49G95T H4ZNC02666,5120x1440@240,0x0,1";
              }
            ];
            exclude-global-prep-cmd = "false";
            cmd = "kitty";
          }
          {
            name = "FFXIV 2560x1440@240";
            # image-path = "";
            output = "${config.users.users.hamp.home}/logs/sunshine/ffxiv.log";
            working-dir = "/run/current-system/sw/bin";
            prep-cmd = [
              {
                do = ''
                  hyprctl keyword monitor desc:Samsung Electric Company LC49G95T H4ZNC02666,5120x1440@120,0x0,1
                '';
                undo = "hyprctl keyword monitor desc:Samsung Electric Company LC49G95T H4ZNC02666,5120x1440@240,0x0,1";
              }
            ];
            exclude-global-prep-cmd = "false";
            cmd = "steam steam://rungameid/39210";
          }
        ];
      };
      openFirewall = true;
      capSysAdmin = true;
      autoStart = true;
    };
  };
}
