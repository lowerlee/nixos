{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    videoDrivers = ["nvidia"];
    
    # GNOME specific settings
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
        enable = true;
        finegrained = false;
    };
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.printing.enable = true;

  nixpkgs.config.allowUnfree = true;
  
  programs.firefox.enable = true;
}