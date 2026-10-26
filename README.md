# NixOS — MacBook Pro 15,1 (T2)

Declarative NixOS configuration for a 2018 MacBook Pro 15" (Intel i7-8750H,
Apple T2 chip, Broadcom Wi-Fi, AMD Radeon Pro 555X + Intel UHD 630).

## Layout

- `flake.nix` — pins `nixpkgs` (nixos-26.05) + `nixos-hardware`; defines host `t2-macbook`
- `configuration.nix` — system config (boot, T2 hardware, Wi-Fi, SSH, user)
- `hardware-configuration.nix` — **auto-generated** during install by `nixos-generate-config` (not committed until then)

## Rebuild

```bash
sudo nixos-rebuild switch --flake .#t2-macbook
```

## First install (on the machine)

1. Boot the NixOS installer.
2. Partition: keep the existing EFI System Partition, create an ext4 root partition.
3. `sudo nixos-generate-config --root /mnt` (writes `hardware-configuration.nix`).
4. Copy `configuration.nix` + `flake.nix` into `/mnt/etc/nixos/`.
5. `sudo nixos-install --flake .#t2-macbook`.

## Notes

- Wi-Fi needs `hardware.apple-t2.firmware.enable = true` + the `broadcom_sta` (`wl`) module.
- For a headless box, SSH is enabled with the key in `configuration.nix`.
- Keep macOS around (dual boot) for firmware updates and the Startup Security Utility.
