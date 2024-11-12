# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Enable Home Manager
  home-manager.useGlobalPkgs = true;  # Use the system's pkgs
  home-manager.useUserPackages = true; # Install to /etc/profiles instead of ~/.nix-profile

  # Home Manager configuration
  home-manager.users.k = { pkgs, ... }: {
    # Enable git with basic configuration
    programs.git = {
      enable = true;
      userName = "kevin";
      userEmail = "minleekevin@gmail.com";
      
      aliases = {
        s = "status";
        co = "checkout";
        ci = "commit";
      };

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
    };

    # Create directories for git repositories
    home.file = {
      "development/personal/.keep".text = "";
      "development/work/.keep".text = "";
      "development/contributions/.keep".text = "";
      "development/archived/.keep".text = "";
    };

    # The state version should match your NixOS version when you first installed it
    home.stateVersion = "24.05";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
 
  # Save the configuration.nix file for each generation
  system.copySystemConfiguration = true;

  # Disable lid switch
  services.logind = {
    lidSwitch = "ignore";
    extraConfig = ''
      HandleLidSwitch=ignore
      HandleLidSwitchExternalPower=ignore
      HandleLidSwitchDocked=ignore
    '';
  };

  # Disable sleep and hibernation
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowSuspendThenHibernate=no
    AllowHybridSleep=no
  '';

  # Enable networking
  networking.networkmanager.enable = true;
  
  # Enable nftables
  networking.nftables.enable = true;

  # Disable the default firewall
  networking.firewall.enable = false;

  networking.nftables.ruleset = ''
    table inet filter {
      chain input {
        type filter hook input priority 0;
        
        # Accept established connections
        ct state established,related accept

        # Allow RSS-Bridge
        tcp dport 3000 accept

        # Allow Syncthing TCP ports
        tcp dport { 8343, 22000, 8080 } accept
        
        # Allow Syncthing UDP ports
        udp dport { 22000, 21027 } accept
        
        # Allow SSH (default port is 22)
        tcp dport 22 accept
        
        # Allow Jellyfin (default port is 8096 for HTTP and 8920 for HTTPS)
        tcp dport { 8096, 8920 } accept
        
        # Basic rules
        iifname lo accept
        ct state invalid drop
        icmp type echo-request accept
      }

      # Mullvad split tunneling configuration
      chain output {
        type route hook output priority 0; policy accept;
        ip daddr 10.0.0.171 ct mark set 0x00000f41 meta mark set 0x6d6f6c65
      }
    }
  '';

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.k = {
    isNormalUser = true;
    description = "k";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    qbittorrent-nox
    git
    gitFull
  ];

  # List services that you want to enable:

  # Enables ssh remote using password
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
    };
  };

  # Enables Jellyfin
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "k";
  };

  # Create the /mnt/media directory
  systemd.tmpfiles.rules = [
    "d /mnt/media 0750 k users -"
    "d /home/k/notes 0755 k users -"
    "d /home/k/rss-bridge-config 0755 k users -"
  ];

  # Automatically mount /dev/sda1/ to /mnt/media on system startup
  fileSystems."/mnt/media" = {
    device = "/dev/sda1";
    fsType = "ext4";
    options = [ "nofail" "users" ];
  };

  # Enable Syncthing
  services.syncthing = {
    enable = true;
    user = "k"; 
    dataDir = "/home/k/.config/syncthing";
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8343";
    settings = {
      gui = {
        address = "0.0.0.0:8343";
        user = "k";
        password = "k";
      };
      devices = {
        "personal-pc" = { id = "TAFMD2K-TZSGS3D-RMB3W6D-JNK2PJV-RQDHZCA-XINWXIC-KG5PBC4-WYH6HAP"; };
        "phone" = { id = "25E6N42-MJMW4G4-GYOUDGC-55GPVZK-MTFEJID-YC3QW5A-UZO7Q65-W4L23QC"; };
        "work" = { id = "2LLI7DA-4BOH25B-NGXNM7H-NIWCRZX-MYCZA5F-VVQ3XWN-PFNKEUJ-67C5HAF"; };
      };
      folders = {
        notes = {
          path = "/home/k/notes";
          devices = [ "personal-pc" "phone" "work" ];
          type = "sendreceive";
          rescanIntervalS = 3600;
          fsWatcherEnabled = true;
          versioning = {
            type = "simple";
            params = {
              keep = "5";
            };
          };
        };
      };
    };
  };

  # Don't create default ~/Sync folder
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

  # Enable qbittorrent-nox
  systemd.services.qbittorrent-nox = {
    description = "qBittorrent-nox service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      User = "k";  # Replace with your username
      ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=8080";
      Restart = "on-failure";
    };
  };

  # Enable mullvad-vpn
  services.mullvad-vpn = {
    enable = true;
  };

  # Enable Docker
  virtualisation.docker = {
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}