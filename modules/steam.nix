{
  pkgs,
  ...
}:
{
  config = {
    hardware = {
      graphics.enable = true;
    };

    programs = {
      steam = {
        enable = true;
        gamescopeSession = {
          enable = true;
        };
      };
    };

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "home/hamp/.steam/root/compatibilitytools.d";
    };

    environment.systemPackages = [
      # deps
      pkgs.protonup-ng
      # wine manager
      pkgs.lutris
      pkgs.protonplus
    ];
  };
}
