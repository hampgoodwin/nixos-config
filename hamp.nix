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
    hamp.user.enable = mkEnableOption "enable local user hamp";
    latitude-7400.user.enable = mkEnableOption "enable local user latitude-7400";
  };

  config = mkIf config.hamp.user.enable {
    # enable the hamp user
    # Enable automatic login for the user.
    services.getty.autologinUser = "hamp";

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.defaultUserShell = pkgs.zsh;
    users.users.hamp = {
      isNormalUser = true;
      description = "hamp";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };
  config = mkIf config.latitude-7400.user.enable {
    # enable the hamp user
    # Enable automatic login for the user.
    services.getty.autologinUser = "latitude-7400";

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.defaultUserShell = pkgs.zsh;
    users.users.latitude-7400 = {
      isNormalUser = true;
      description = "latitude-7400";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };
}
