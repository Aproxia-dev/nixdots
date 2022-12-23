{ config, inputs, lib, pkgs, system, ... }:

let run = import ../shared/bin/run.nix { inherit pkgs; };
in {
	home = {
		packages = with pkgs; [
			(rofi.override { plugins = [ rofimoji rofi-bluetooth ];})
			scrot
			(pcmanfm.override { withGtk3 = true; })
			ranger
			mailspring
			feh
			yadm
			ncdu
			duf
			pamixer
			apro-st
			dconf
			btop
			htop
			bottom
			run # credit to alpha for this
		];

		pointerCursor = {
			x11.enable = true;
			gtk.enable = true;
			name = "Catppuccin-Mocha-Dark-Cursors";
			package = pkgs.catppuccin-cursors.mochaDark;
			size = 16;
		};
	};

	gtk = {
		enable = true;
		theme = {
			name = "Catppuccin-Mocha-Standard-Lavender-Dark";
			package = pkgs.catppuccin-gtk;
		};

		iconTheme = {
      		name = "Papirus";
      		package = pkgs.catppuccin-folders;
    	};

		font = {
			name = "Lato";
			size = 12;
		};

		gtk3.extraConfig = {
    		gtk-xft-antialias = 1;
    		gtk-xft-hinting = 1;
    		gtk-xft-hintstyle = "hintslight";
    		gtk-xft-rgba = "rgb";
    		gtk-decoration-layout = "menu:";
    	};
	};

	programs.home-manager.enable = true;

	xresources.extraConfig = import ./etc/xresources.nix;

	imports = [
		./programs/browser
		./programs/shell

		./programs/utils/bat.nix
		./programs/utils/direnv.nix
		./programs/utils/exa.nix
		./programs/utils/git.nix

		./programs/apps/discocss.nix
		./programs/apps/mpd.nix
		./programs/apps/vscodium.nix
	];
}
