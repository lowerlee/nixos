{ config, pkgs, ... }:

{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.checkReversePath = "loose";
    nftables.enable = true;
  };

  services.resolved = {
    enable = true;
    dnssec = "true";
  };
}