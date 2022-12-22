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

	environment.systemPackages = with pkgs; [
        acpi
        blueberry
        brightnessctl
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
