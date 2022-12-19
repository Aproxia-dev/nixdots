{
	description = "Apro's NixOS config";

	inputs = {
		home.url = "github:nix-community/home-manager";
		nix-hw.url = "github:nixos/nixos-hardware/master";
		nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
		nur.url = "github:nix-community/NUR";

		zsh-completions = {
			url = "github:zsh-users/zsh-completions";
			flake = false;
		};

		zsh-syntax-highlighting = {
			url = "github:zsh-users/zsh-syntax-highlighting";
			flake = false;
		};

		master.url = "github:nixos/nixpkgs/master";
		stable.url = "github:nixos/nixpkgs/nixos-22.11";
		nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

		nixpkgs.follows = "nixpkgs-unstable";
		home.inputs.nixpkgs.follows = "nixpkgs";
		nixpkgs-f2k.inputs.nixpkgs.follows = "nixpkgs";
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
				nixpkgs-f2k.overlays.default
			];
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
