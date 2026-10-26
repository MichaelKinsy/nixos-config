# Hyprland (Wayland tiling compositor) — the riced desktop.
# Imported only by the "t2-macbook" host, NOT by "t2-macbook-headless".

{ config, pkgs, ... }:

{
  programs.hyprland.enable = true;

  # graphical login
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # screen-sharing portal
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];

  # system-wide starter config (override per-user at ~/.config/hypr/hyprland.conf)
  environment.etc."hypr/hyprland.conf".source = ./hyprland.conf;

  environment.systemPackages = with pkgs; [
    kitty # terminal
    waybar # status bar
    rofi # app launcher
    mako # notifications
    swww # wallpaper daemon
    hyprlock # lock screen
    hypridle # idle daemon
    grim # screenshot
    slurp # region select
    wl-clipboard # copy/paste
    firefox
  ];
}
