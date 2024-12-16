{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.kevin = { pkgs, ... }: {
    home.packages = with pkgs; [
      vscode
      brave
      gnomeExtensions.dash-to-panel
    ];

    programs = {
      git = {
        enable = true;
        userName = "lowerlee";
        userEmail = "minleekevin@gmail.com";
      };
    };

    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          "dash-to-panel@jderose9.github.com"
        ];
      };
    };

    home.stateVersion = "24.11";
  };

  home-manager.users.root = { pkgs, ... }: {
    programs = {
      git = {
        enable = true;
        userName = "lowerlee";
        userEmail = "minleekevin@gmail.com";
      };
    };

    home.stateVersion = "24.11";
  };
}