{ config, nixpkgs, nix-hw, overlays, inputs, ... }:

nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";

  modules = [
    {
      nixpkgs = { inherit config overlays; };
    }

    nix-hw.nixosModules.lenovo-thinkpad-t460s
    ./configuration.nix
  ];

  specialArgs = { };
}
