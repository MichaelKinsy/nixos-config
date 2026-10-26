# NixOS configuration — MacBook Pro 15,1 (2018, Apple T2)
# Edit freely; rebuild with: sudo nixos-rebuild switch --flake .#t2-macbook

{ config, pkgs, ... }:

{
  # ---- Nix binary caches (prebuilt T2 kernel/firmware) ----
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://t2linux.cachix.org"
      "https://cache.soopy.moe"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "t2linux.cachix.org-1:P733c5Gt1qTcxsm+Bae0renWnT8OLs0u9+yfaK2Bejw="
      "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="
    ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  # ---- Boot ----
  # systemd-boot on the existing EFI System Partition (dual boot with macOS)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ---- T2 Mac hardware (module imported in flake.nix) ----
  hardware.apple-t2.firmware.enable = true; # Broadcom Wi-Fi / Bluetooth firmware
  hardware.apple-t2.enableIGPU = true;      # prefer Intel iGPU over the AMD dGPU (saves power)

  # Broadcom Wi-Fi driver (T2 uses a BCM4364)
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.kernelModules = [ "wl" ];

  # ---- Networking ----
  networking.hostName = "t2-macbook";
  networking.networkmanager.enable = true; # manages Wi-Fi + ethernet

  # ---- Locale & time ----
  time.timeZone = "America/Boise";
  i18n.defaultLocale = "en_US.UTF-8";

  # ---- User ----
  users.users.bigmike = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "changeme"; # change on first login
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCv+1HPLwVlmelrUNMabZBwDXy9c32RMK0QtaUZXfwn+CGlW99t5c27YV2Qwe0qJkhzaSl4WUegQZjTJxSBcb3XCBt1Qqi0o9SMRKTXsGX1NogkxnAp+tiDHPjwkVKT183SWCy0YAU9H/pmgZjOnPgMrkgT7k4rNJ0qxgAHWlEbb839IIK+Y+Ra7BUFF/bjFb2dHD8uR7Zosr+Jc3f3Y9jgjwfZjU3cydw8Ns0vwSNMm39i9kk3J0D/0dQymxx6jR3W/QaUJLwoqM98FPGtiG0vdc6BmoD3TFoJ+vr6Vn60PzyOoyOZzPtBAPitohyIaMnZkTBMgDYRfssWT8xShzXt"
    ];
  };

  # ---- SSH (for headless use) ----
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    # settings.PasswordAuthentication = false; # enable this after you confirm key login works
  };

  # ---- Packages ----
  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
    htop
    tmux
  ];

  # ---- NixOS release this config was written for ----
  system.stateVersion = "26.05";
}
