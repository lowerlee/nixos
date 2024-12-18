{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/boot.nix
    ./modules/networking.nix
    ./modules/desktop.nix
    ./modules/audio.nix
    ./modules/users.nix
    ./modules/system.nix
    ./modules/home-manager.nix
    ./modules/tailscale.nix
    ./modules/syncthing.nix
  ];

  system.stateVersion = "24.11";
}