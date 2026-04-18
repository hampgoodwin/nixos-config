{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
{
  options.sh.enable = mkEnableOption "enable zsh";

  config = mkIf config.sh.enable {
    programs.zsh = {
      enable = true;
    };
  };
}
