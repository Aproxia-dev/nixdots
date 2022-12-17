# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, overlays, lib, ... }:


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "kompis"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.utf8";
    LC_IDENTIFICATION = "cs_CZ.utf8";
    LC_MEASUREMENT = "cs_CZ.utf8";
    LC_MONETARY = "cs_CZ.utf8";
    LC_NAME = "cs_CZ.utf8";
    LC_NUMERIC = "cs_CZ.utf8";
    LC_PAPER = "cs_CZ.utf8";
    LC_TELEPHONE = "cs_CZ.utf8";
    LC_TIME = "cs_CZ.utf8";
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    windowManager.awesome = {
      enable = true;
      luaModules = lib.attrValues {
        inherit (pkgs.luaPackages) lgi;
      };
    };
    displayManager.sddm.enable = true;
    layout = "us";
    xkbVariant = "colemak_dh";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.apro = {
    isNormalUser = true;
    description = "Emily Aproxia";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    wget
    zsh
    neofetch
    firefox

    (st.overrideAttrs (old: rec {
      src = builtins.fetchTarball {
        url = "https://github.com/Aproxia-dev/st-flexipatch/archive/master.tar.gz";
	sha256 = "1j0spdlqmi8q6ghxg2b095r470hdfmmpspr5wmqgj431cp2cz5v9";
      };
      buildInputs = old.buildInputs ++ [ harfbuzz ];
      patches = [ (fetchpatch {
        url = "https://cdn.discordapp.com/attachments/738723193128222743/1043119710897721405/nixos-st-font-fix.diff";
	sha256 = "uPELu9SEZ1APV43+H5yGWiQQBuLz/fbO4DW1MhXF5Ts=";
      })];
    }))
  ];

  fonts = { 
    fonts = with pkgs; [
      twitter-color-emoji
      noto-fonts
      lato
      (nerdfonts.override { fonts = [ "Iosevka" "JetBrainsMono" ]; })
    ];

    fontconfig.defaultFonts = {
      serif = [ "Lato" ];
      monospace = [ "JetBrainsMono" ];
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      line_break.disabled = true;
      cmd_duration = {
        min_time = 400;
	show_milliseconds = false;
	style = "bold blue";
      };
      directory = {
        style = "bold purple";
	truncation_symbol = ".../";
      };
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  services = {
    pipewire = {
      enable = true;

      jack.enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
    mpd.enable = true;
  };

  systemd.user.services = {
    pipewire.wantedBy = ["default.target" ];
    pipewire-pulse.wantedBy = [ "default.target" ];
    mpd.wantedBy = ["default.target" ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
