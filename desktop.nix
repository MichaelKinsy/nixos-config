# Optional graphical desktop (GNOME).
# Imported only by the "t2-macbook" host, NOT by "t2-macbook-headless".

{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Trim some GNOME apps you probably don't need (optional — remove any you want)
  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
    gnome-music
    gnome-photos
    gnome-maps
    epiphany # GNOME Web browser
    totem # Videos
    cheese # Webcam
  ]);

  environment.systemPackages = with pkgs; [
    firefox
    gnome-tweaks
  ];
}
