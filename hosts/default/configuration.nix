{ pkgs, inputs, ... }:
{
  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Europe/Ljubljana";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "sl_SI.UTF-8";
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "slovene";
  };

  programs.git.enable = true;
  programs.fish.enable = true;
  programs.nix-ld.enable = true; # Allows vscode remote ssh to work

  # services.resolved.enable = true;
  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    gnumake
    ncurses # support different terminals when u ssh (for example)
  ];

  networking.firewall.allowedTCPPorts = [ 22 ];
}
