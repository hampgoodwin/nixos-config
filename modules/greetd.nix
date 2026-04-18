{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # tuigreet lets you choose your session and remembers your last choice.
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --remember --remember-session --sessions /run/current-system/sw/share/wayland-sessions --cmd niri-session";
        user = "greeter";
      };
    };
  };

  # Prevent boot messages from interlacing with the tuigreet prompt
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Send errors to the journal
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
