{
	config,
	pkgs,
	...
}: {
	programs.firefox = {
		enable = true;

		extensions = with pkgs.nur.repos.rycee.firefox-addons; [
			ublock-origin
			darkreader
			sponsorblock
			return-youtube-dislikes
			tabcenter-reborn
			stylus
			enhanced-github
			refined-github
			octotree
			new-tab-override
			https-everywhere
			h264ify
		];

		profiles = {
			apro = {
				id = 0;
				settings = {
					"browser.startup.homepage" = "https://startpage.aproxia.me/";
					"general.smoothScrolling" = true;
				};

				userChrome = import ./userChrome.nix;
				# userContent = import ./userContent.nix;

        		extraConfig = ''
        		  user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
        		  user_pref("full-screen-api.ignore-widgets", true);
        		  user_pref("media.ffmpeg.vaapi.enabled", true);
        		  user_pref("media.rdd-vpx.enabled", true);
        		'';
			};
		};
	};
}