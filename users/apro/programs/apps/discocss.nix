{
	config,
	...
}: {
	programs.discocss = {
		enable = true;
		css = import ../../etc/discord-css.nix;
		discordAlias = true;
	};
}