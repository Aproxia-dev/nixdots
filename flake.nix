{
  description = "Apro's NixOS config";

  inputs = {
    home.url = "github:nix-community/home-manager";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";

    master.url = "github:nixos/nixpkgs/master";
    stable.url = "github:nixos/nixpkgs/nixos-22.11";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixpkgs.follows = "nixpkgs-unstable";
    home.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-f2k.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, home, nixpkgs, nixpkgs-f2k, ... }@inputs:
    with nixpkgs.lib;
    let
      config = {
	allowUnfree = true;
	allowBroken = true;
      };
      
      overlays = with inputs; [
        (final: _:
	  let inherit (final) system;
	  in 
	    (with nixpkgs-f2k.packages.${system}; {
	      awesome = awesome-git;
	      picom = picom-git;
	    }) // {
	      master = import master { inherit config system; };
	      unstable = import unstable { inherit config system; };
	      stable = import stable { inherit config system; };
	    }
	)
      nixpkgs-f2k.overlays.default
    ];
    in {
      nixosConfigurations = {
        vm = import ./hosts/vm
	  { inherit config nixpkgs overlays inputs; };
      };
      homeConfigurations = {
        apro = import ./users/apro
	  { inherit config nixpkgs home overlays inputs; };
      };
  };
}
