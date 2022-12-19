{
	config,
	pkgs,
	overlays,
	lib,
	...
}: {
	nix.settings.experimental-features = ["nix-command" "flakes"];

	boot.loader = {
		efi = {
			canTouchEfiVariables = true;
			efiSysMountPoint = "/boot/efi";
		};
		grub = {
			enable = true;
			efiSupport = true;
			# efiInstallAsRemovable = true;
			device = "nodev";
			useOSProber = true;
	 	};
	};

	networking.hostName = "thonkpad";

	hardware = {
        bluetooth = {
            enable = true;
            package = pkgs.bluez;
        };

        enableRedistributableFirmware = true;
    };
    
    # TODO: Get rid of all of these
	services.xserver = {
		enable = true;
		windowManager.awesome = {
			enable = true;
			luaModules = lib.attrValues {
				inherit (pkgs.luaPackages) lgi ldbus luadbi-mysql luaposix;
			};
		};
		displayManager.sddm.enable = true;

		layout = "us";
		xkbVariant = "colemak_dh";
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
	# !!! up until this line

	environment.systemPackages = with pkgs; [
        acpi
        blueberry
        brightnessctl

		# TODO: get rid of st too
		(st.overrideAttrs
		    (old: rec {
		    	src = builtins.fetchTarball {
		    		url = "https://github.com/Aproxia-dev/st-flexipatch/archive/master.tar.gz";
		    		sha256 = "1j0spdlqmi8q6ghxg2b095r470hdfmmpspr5wmqgj431cp2cz5v9";
		    	};
		    	buildInputs = old.buildInputs ++ [harfbuzz];
		    	patches = [
		    		(fetchpatch {
		    			url = "https://cdn.discordapp.com/attachments/738723193128222743/1043119710897721405/nixos-st-font-fix.diff";
		    			sha256 = "uPELu9SEZ1APV43+H5yGWiQQBuLz/fbO4DW1MhXF5Ts=";
		    		})
		    	];
		    })
        )
	];

	programs.nm-applet.enable = true;
	
    services = {
        acpid.enable = true;
        upower.enable = true;
    };
	
    imports = [
		./hardware-configuration.nix

        # Shared configuration across all systems
        ../shared
	];
}
