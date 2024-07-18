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
    hamp.user.enable = mkEnableOption "enable local users";
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
}
