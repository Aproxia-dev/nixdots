final: prev: {
	apro-st = prev.callPackage ../derivations/apro-st.nix {};
	catppuccin-folders = prev.callPackage ../derivations/catppuccin-folders.nix {};
	catppuccin-gtk = prev.callPackage ../derivations/catppuccin-gtk.nix {};
}