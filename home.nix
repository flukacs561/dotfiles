{ pkgs, ... }:
let
  args = import ./variables.nix;
in
rec {
  imports = [
    ./helix.nix
    ./newsboat.nix
  ];
  
  home = {
    username = "${args.userName}";
    homeDirectory = "${args.homeDirectory}";
    sessionVariables = {
      BROWSER="brave";
      CABAL_DIR="${args.dataHome}/cabal";
      AGDA_DIR="${args.dataHome}/agda";
      STACK_ROOT="${args.dataHome}/stack";
      PYTHONHISTORY="${args.dataHome}/python/python-history";
    };
    shellAliases = {
      nixr = "sudo nixos-rebuild switch --flake '${args.nixRepo}#abulafia'";
      nixc = "sudo nix-collect-garbage --delete-older-than 14d";
      nixu = "nix flake update ${args.nixRepo} && sudo nixos-rebuild switch --flake '${args.nixRepo}#abulafia'";

      off = "sudo shutdown 0";
      tp = "xinput --set-prop 12 181";
      gitl = "git log --pretty --oneline --graph";
      gs = "git status";
      gd = "git diff";

      ll = "ls -AGFhlv --group-directories-first --time-style=long-iso --color=always";
      l = "ls -GFhlv --group-directories-first --time-style=long-iso --color=always";
      # l = "exa -l -h --git --icons --group-directories-first";
      # ll = "exa -l -a -h --git --icons --group-directories-first";

      hakyllr = "ghc --make site.hs && ./site clean && ./site watch";
      hakylld = "ghc --make site.hs && ./site clean && ./site build && ./site deploy";

      use-unfree = "NIXPKGS_ALLOW_UNFREE=1 nix-shell -p";

      laptop = "xrandr --output eDP-1 --auto --output DP-2 --off";
      monitor = "xrandr --output eDP-1 --off --output DP-2 --auto";

      h = "hx .";
      z = "zathura";
      ff = "hx $(sk)";
      d = "directory_switcher";
      f = "open_and_switch";
      g = "grep_from_directory";
    };
    packages = with pkgs; [ xdotool ];
    file."latexmkrc" = {
      source = ./latexmkrc;
      target = "${args.configHome}/latexmk/latexmkrc";
    };
  };

  programs.emacs.enable = args.isEmacs;
  services.emacs = {
    enable = args.isEmacs;
    defaultEditor = args.isEmacs;
    startWithUserSession = args.isEmacs;
    client.enable = args.isEmacs;
    client.arguments = [ "-c \"emacs\"" ];
  };

  programs.zathura.enable = true;

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableScDaemon = true;
    pinentryFlavor = "tty";
    # 84600 seconds is 24 hours
    defaultCacheTtl = 84600;
    maxCacheTtl = 84600;
    maxCacheTtlSsh = 84600;
    defaultCacheTtlSsh = 84600;
    grabKeyboardAndMouse = true;
  };

  programs.ssh = {
    enable = true;
    matchBlocks."GitHub" = {
      host = "github.org";
      identityFile = "${args.homeDirectory}/.ssh/id_ed25519";
      extraOptions.PreferredAuthentications = "publickey";
    };
  };

  services.screen-locker = {
    enable = args.lock-screen;
    inactiveInterval = 60;
    lockCmd = "XSECURELOCK_SHOW_DATETIME=1 XSECURELOCK_PASSWORD_PROMPT=\"asterisks\" ${pkgs.xsecurelock}/bin/xsecurelock";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    initExtra =
      ''
        autoload -U colors && colors
        PS1="[%F{green}f%f%F{brown}@%f%F{green}💻%f %~] %F{green}>%f "

        directory_switcher() {
          local current_dir
          current_dir=$(pwd)

          cd ~/
      
          local selected_item
          selected_item=$(sk)
      
          # Check if an item was selected
          if [ -n "$selected_item" ]; then
              cd "$selected_item"
          else
              cd "$current_dir"
          fi
      }

      open_and_switch() {
        local current_dir
        current_dir=$(pwd)

        cd ~/

        local selected_item
        selected_item=$(sk)

        if [ -n "$selected_item" ]; then
            cd $(dirname "$selected_item")
            hx $(basename "$selected_item")
        else
            cd "$current_dir"
        fi
      }

      grep_from_directory() {
        local file
        file=$(sk --ansi -i -c 'rg --color=always --line-number "{}"' | cut -d ':' -f 1)

        echo "$file"

        if [ -n "$file" ]; then
            hx "$file"
        fi
      }
        '';
    defaultKeymap = "emacs";
    dotDir = "/.config/zsh";
    history = {
      path = "${args.homeDirectory}/${programs.zsh.dotDir}/zsh_history";
      size = 10000;
      save = 10000;
    };
  };

  programs.git = {
    enable = true;
    userName = "Ferenc Lukács";
    userEmail = "flukacs561@gmail.com";
    ignores = [ "*.o" "*.hi" ];
    extraConfig = {
      core.editor = "${args.editor}";
      core.commitGraph = true;
    };
    signing = {
      signByDefault = true;
      key = "flukacs561@gmail.com";
    };
  };

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };

  xdg = {
    enable = true;
    cacheHome = "${args.homeDirectory}/.cache";
    configHome = "${args.homeDirectory}/.config";
    dataHome = "${args.homeDirectory}/.local/share";
    stateHome = "${args.homeDirectory}/.local/state";
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${args.homeDirectory}";
      documents = "${args.homeDirectory}/dox";
      download = "${args.homeDirectory}/let";
      music = "${args.homeDirectory}/mus";
      pictures = "${args.homeDirectory}/pix";
      templates = "${args.homeDirectory}/code";
      videos = "${args.homeDirectory}/usb";
      publicShare = "${args.homeDirectory}/dox/books";
    };
  };
    
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # document types
      "application/epub+zip" = [ "org.pwmt.zathura.desktop" ];
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      "text/plain" = [ "helix.desktop" ];
      "text/tex" = [ "helix.desktop" ];

      # audio types
      "auido/mpeg" = [ "mpv.desktop" ];
      "audio/ogg" = [ "mpv.desktop" ];
      "audio/opus" = [ "mpv.desktop" ];
      "audio/wav" = [ "mpv.desktop" ];
      "audio/wbm" = [ "mpv.desktop" ];

      # image types
      "image/jpeg" = [ "brave.desktop" ];
      "image/gif" = [ "brave.desktop" ];
      "image/png" = [ "brave.desktop" ];
      "image/svg+xml" = [ "brave.desktop" ];
      "image/vnd.microsoft.icon" = [ "brave.desktop" ];

      # video types
      "video/x-msvideo" = [ "mpv.desktop" ];
      "video/mp4" = [ "mpv.desktop" ];
      "video/mpeg" = [ "mpv.desktop" ];
      "video/webm" = [ "mpv.desktop" ];
      "video/x-matroska" = [ "mpv.desktop" ];

      # web types
      "text/html" = [ "brave.desktop" ];
      "x-scheme-handler/http" = [ "brave.desktop" ];
      "x-scheme-handler/https" = [ "brave.desktop" ];
      "x-scheme-handler/about" = [ "brave.desktop" ];
      "x-scheme-handler/unknown" = [ "brave.desktop" ];
    };
  };

  home.stateVersion = "23.05";
}

