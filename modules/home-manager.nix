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
      obsidian
    ];

    programs = {
      git = {
        enable = true;
        userName = "lowerlee";
        userEmail = "minleekevin@gmail.com";
      };
      bash = {
        enable = true;
        shellAliases = {
          build = "sudo nixos-rebuild switch";
          sshk = "ssh k@10.0.0.102";
          bridge = "sshfs k@10.0.0.102:/etc/nixos/ ~/nixos-server/";
          add = "sudo git add .";
          commit = "sudo git commit -m";
          push = "sudo git push origin";
          branch = "sudo git branch";
          checkout = "sudo git checkout";
          merge = "sudo git merge";
          nixos = "cd /etc/nixos";
        };
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