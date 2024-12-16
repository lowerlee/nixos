{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.kevin = { pkgs, ... }: {
    home.packages = with pkgs; [
      vscode
      brave
    ];

    programs = {
      git = {
        enable = true;
        userName = "lowerlee";
        userEmail = "minleekevin@gmail.com";
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