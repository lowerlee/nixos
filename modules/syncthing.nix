{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
    openDefaultPorts = true;
    dataDir = "/home/kevin";
    user = "kevin";
    settings = {
      gui = {
        user = "nixos-desktop";
        password = "k";
      };
      devices = {
        "pixel9-pro-xl" = { id = "25E6N42-MJMW4G4-GYOUDGC-55GPVZK-MTFEJID-YC3QW5A-UZO7Q65-W4L23QC"; };
      };
      folders = {
        "notes" = {
          path = "/home/kevin/Documents/obsidian";
          devices = [ "pixel9-pro-xl" ];
        };
      };
      options = {
        localAnnounceEnabled = false;
        relaysEnabled = false;
      };
    };
  };
}