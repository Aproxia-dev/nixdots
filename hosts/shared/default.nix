{
	config,
	pkgs,
  lib,
	...
}: {
	nix.settings.experimental-features = ["nix-command" "flakes"];

  boot.kernelPackages = pkgs.linuxPackages_zen;
	networking.networkmanager.enable = true;
	console.useXkbConfig = true;

	time = {
		timeZone = "Europe/Prague";
		hardwareClockInLocalTime = true;
	};

	i18n = {
        defaultLocale = "en_US.utf8";
        supportedLocales = [ "en_US.UTF-8/UTF-8" "cs_CZ.UTF-8/UTF-8" ];
        extraLocaleSettings = {
            LC_ALL = "en_US.utf8";
            LC_MEASUREMENT = "cs_CZ.utf8";
            LC_MONETARY = "cs_CZ.utf8";
            LC_PAPER = "cs_CZ.utf8";
            LC_TELEPHONE = "cs_CZ.utf8";
        };
    };

	users = {
		mutableUsers = true;
		defaultUserShell = pkgs.zsh;

		users.apro = {
			isNormalUser = true;
			description = "Emily Aproxia";
			extraGroups = ["networkmanager" "wheel"];
		};
	};

	environment = {
		binsh = "${pkgs.bash}/bin/bash";
		shells = with pkgs; [zsh];

		systemPackages = lib.attrValues {
			inherit (pkgs)
				cmake
			  coreutils
			  curl
			  fd
			  ffmpeg
			  gcc
			  git
			  glib
			  home-manager
			  libnotify
				lm_sensors
			  man-pages
				pciutils
			  pulsemixer
				ripgrep
			  unrar
			  unzip
			  neovim
			  wget
			  xarchiver
			  xclip
			  zip;
          
      inherit (pkgs.mate)
        mate-polkit;
    };

		variables.EDITOR = "nvim";
		sessionVariables.MOZ_USE_XINPUT2 = "1";
	};

	fonts = {
		fonts = lib.attrValues {
            inherit (pkgs)
							twitter-color-emoji
							noto-fonts
							lato;
        } ++ [(pkgs.nerdfonts.override {fonts = ["Iosevka" "JetBrainsMono"];})];
        

		fontconfig.defaultFonts = {
			serif = ["Lato"];
			monospace = ["JetBrainsMono"];
			emoji = ["Twitter Color Emoji"];
		};
	};

	systemd.user.services = {
		pipewire.wantedBy = ["default.target"];
		pipewire-pulse.wantedBy = ["default.target"];
	};


	programs = {
		dconf.enable = true;
		gnupg.agent = {
			enable = true;
			enableSSHSupport = true;
		};
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

		dbus = {
    	enable = true;
    	packages = with pkgs; [dconf gcr];
    };

		openssh.enable = true;

		xserver = {
			enable = true;
			layout = "fck";
			
			extraLayouts.fck = {
				description = "Fancy Czech Keyboard";
				languages = [ "en" "cs" ];
				symbolsFile = ../../keymaps/fck;
			};

			windowManager.awesome = {
				enable = true;
				luaModules = lib.attrValues {
					inherit (pkgs.luaPackages) lgi ldbus luadbi-mysql luaposix;
				};
			};

			displayManager = {
				lightdm.enable = true;
				defaultSession = "none+awesome";
			};
		};
	};

	system.stateVersion = "22.11";
}
