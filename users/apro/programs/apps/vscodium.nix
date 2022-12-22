{
	config,
	pkgs,
	...
}: {
	programs.vscode = {
		enable = true;
		package = pkgs.vscodium;
		extensions = with pkgs.vscode-extensions; [
			sumneko.lua
			vscodevim.vim
			ms-python.python
			jnoortheen.nix-ide
			catppuccin.catppuccin-vsc
		];
	};
}