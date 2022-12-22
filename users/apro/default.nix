{ config, nixpkgs, home, overlays, inputs, ... }:

let system = "x86_64-linux";
in home.lib.homeManagerConfiguration {
	modules = [
    	./home.nix

		{
			home = {
				username = "apro";
				homeDirectory = "/home/apro";
				stateVersion = "22.11";
			};

			imports = let
        	nurNoPkgs = import inputs.nur {
        		nurpkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        	};
        	in [
        		# NOTE: these modules must be imported here to prevent infinite
        		# recursion. See
        		# <https://github.com/nix-community/home-manager/issues/1642#issuecomment-739012921>.
        		nurNoPkgs.repos.splintah.hmModules.mpdscribble
    		];
		}
	];

	pkgs = import inputs.nixpkgs {
		system = "${system}";
		config.allowUnfree = true;
		inherit overlays;
	};		

	extraSpecialArgs = { inherit inputs system; };
}