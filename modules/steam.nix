{
  inputs,
  pkgs,
  pkgs-stable,
  ...
}:
{
  config = {
    hardware = {
      graphics.enable = true;
    };

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    programs.gamemode.enable = true;

    # this is how steam gets the proton ge built compatability bin from protonup
    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/hamp/.steam/root/compatibilitytools.d";
    };

    environment.systemPackages = [
      # deps
      pkgs.protonup
      # wine manager
      pkgs-stable.bottles
    ];
  };
}
