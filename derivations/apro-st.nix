{
	lib,
	stdenv,
	fetchFromGitHub,
	fetchpatch,
	pkg-config,
	ncurses,
	fontconfig,
	freetype,
	libX11,
	libXft,
	harfbuzz,
	...
}:

stdenv.mkDerivation {
	pname = "apro-st";
	version = "latest";

	src = fetchFromGitHub {
		repo = "st-flexipatch";
		owner = "Aproxia-dev";
		rev = "98cb137c116a997c70bdf6a49ca0a5ef463d9ff3";
		sha256 = "1j0spdlqmi8q6ghxg2b095r470hdfmmpspr5wmqgj431cp2cz5v9";
	};

	patches = [
		(fetchpatch {
			url = "https://cdn.discordapp.com/attachments/738723193128222743/1043119710897721405/nixos-st-font-fix.diff";
			sha256 = "uPELu9SEZ1APV43+H5yGWiQQBuLz/fbO4DW1MhXF5Ts=";
		})
	];

	strictDeps = true;

	makeFlags = [
		"PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
	];

	nativeBuildInputs = [
		pkg-config
		ncurses
		fontconfig
		freetype
	];
  
  	buildInputs = [
    	libX11
    	libXft
		harfbuzz
  	];

	preInstall = ''
    	export TERMINFO=$out/share/terminfo
	'';

	installFlags = [ "PREFIX=$(out)" ];
}