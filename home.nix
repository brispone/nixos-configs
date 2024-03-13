{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "brad";
  home.homeDirectory = "/home/brad";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs;  [
    alacritty
    wezterm
    starship
    neofetch
    git
    cava
    vlc

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/brad/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
  };

  # Cursors
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.google-cursor;
    name = "Google-Dot";
    size = 24;
  };

  nixpkgs.config.allowUnfree = true;

  programs.git = {
    enable = true;
    userName = "Brad Rispone";
    userEmail = "bradrispone@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      color.ui = "auto";
      pull.rebase = "false";
    };
  };

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      gruvbox
    ];
    extraConfig = ''
      colorscheme gruvbox
    '';
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "ls --color=auto --group-directories-first";
      c = "clear";
      mkdir = "mkdir -pv";

      # Confirmations
      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";
    };
    initExtra = ''
      function take {
        mkdir $1
        cd $1
      }
      function note {
        echo "date: $(date)" >> $HOME/Documents/notes.txt
	echo "$@" >> $HOME/Documents/notes.txt
	echo "" >> $HOME/Documents/notes.txt
        echo "Note saved to $HOME/Documents/notes.txt"
      }
      '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      scan_timeout = 10;
      format = "[╭╴](238)\$all[╰─](238)$character";
      character = {
        success_symbol = "[[](bold red)[](bold yellow)[](bold green)](238)";
        error_symbol = "[](bold red)(238)";
      };
      directory = {
        truncation_length = 3;
        truncation_symbol = ".../";
        home_symbol = " ~";
        read_only_style = "197";
        read_only = "  ";
      };
      username = {
        style_user = "white";
        style_root = "white";
        format = "  ";
        disabled = false;
        show_always = true;
      };
      hostname = {
        ssh_only = false;
        format = "@ [$hostname](bold yellow) (bold green) ";
        disabled = true;
      };
    };
  };
  
  programs.vscode = {
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    music = "${config.home.homeDirectory}/Media/Music";
    videos = "${config.home.homeDirectory}/Media/Videos";
    pictures = "${config.home.homeDirectory}/Media/Pictures";
    download = "${config.home.homeDirectory}/Downloads";
    documents = "${config.home.homeDirectory}/Documents";
    desktop = null;
    publicShare = null;
    templates = null;
  };  

}
