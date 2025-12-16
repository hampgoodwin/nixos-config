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
    user.enable = mkEnableOption "enable local user";
    user.name = mkOption {
      type = types.str;
      description = "user name";
    };
  };

  config = mkIf config.user.enable {
    # enable the user
    # Enable automatic login for the user.
    services.getty.autologinUser = "${config.user.name}";

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.defaultUserShell = pkgs.zsh;
    users.users.${config.user.name} = {
      isNormalUser = true;
      description = "${config.user.name}";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };
}
