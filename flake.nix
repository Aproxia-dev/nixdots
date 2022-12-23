{
	description = "Apro's NixOS config";

	inputs = {
		home.url = "github:nix-community/home-manager";
		nix-hw.url = "github:nixos/nixos-hardware/master";
		nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
		nur.url = "github:nix-community/NUR";


		master.url = "github:nixos/nixpkgs/master";
		stable.url = "github:nixos/nixpkgs/nixos-22.11";
		nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

		nixpkgs.follows = "nixpkgs-unstable";
		home.inputs.nixpkgs.follows = "nixpkgs";
		nixpkgs-f2k.inputs.nixpkgs.follows = "nixpkgs";

		secrets = {
			url = "path:/home/apro/.secrets";
			flake = false;
		};
	};

	outputs = {
		self,
		home,
		nixpkgs,
		nix-hw,
		...
	} @ inputs:
		with nixpkgs.lib; let
			config = {
				allowUnfree = true;
				allowBroken = true;
			};

			filterNixFiles = k: v: v == "regular" && hasSuffix ".nix" k;
    		
			importNixFiles = path:
      			(lists.forEach (mapAttrsToList (name: _: path + ("/" + name))
          			(filterAttrs filterNixFiles (builtins.readDir path)))) import;

			overlays = with inputs; [
				(
					final: _: let
						inherit (final) system;
					in
						(with nixpkgs-f2k.packages.${system}; {
							awesome = awesome-git;
							picom = picom-git;
						})
						// {
							master = import master {inherit config system;};
							unstable = import unstable {inherit config system;};
							stable = import stable {inherit config system;};
						}
				)
				nur.overlay
				nixpkgs-f2k.overlays.default
			] ++ (importNixFiles ./overlays);
		in {
			nixosConfigurations = {
				vm =
					import ./hosts/vm
					{inherit config nixpkgs overlays inputs;};
				thonkpad =
					import ./hosts/thonkpad
					{inherit config nixpkgs nix-hw overlays inputs;};
			};
			homeConfigurations = {
				apro =
					import ./users/apro
					{inherit config nixpkgs home overlays inputs;};
			};
		};
}
