{ config, pkgs, ... }:
let
  args = import ./variables.nix;
in
{
  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 5;
    efi.canTouchEfiVariables = true;
    timeout = 3;
  };

  networking = {
    hostName = "${args.hostName}";
    networkmanager.enable = args.online-mode;
    hosts =
    let
      sites = [
        "www.instagram.com"
        "instagram.com"
        "facebook.com"
        "fb.com"
        "www.fb.com"
        "4chan.org"
        "www.4chan.org"
        "4channel.org"
        "www.4channel.org"
        "boards.4channel.org"
        "www.boards.4channel.org"
        "www.blikk.hu"
        "blikk.hu"
        "www.nlc.hu"
        "nlc.hu"
        "www.reddit.com"
        "reddit.com"
        "www.origo.hu"
        "origo.hu"
        "tiktok.com"
        "www.tiktok.com"
      ];
    in
      {
        "0.0.0.0" = sites;
        "::0" = sites;
      };
  };

  time.timeZone = "Europe/Budapest";
  i18n.defaultLocale = "en_GB.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  services.xserver = {
    enable = true;
    layout = "hu";
    xkbOptions = "ctrl:nocaps";
    desktopManager.wallpaper.mode = "scale";
  };
  
  services.xserver.libinput = {
    enable = true;
    touchpad.tapping = true;
    touchpad.naturalScrolling = true;
  };

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    plasma-browser-integration
  ];

  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = haskellPackages : [ haskellPackages.xmobar ];
    config = ./xmonad.hs;
  };

  # Light is available regardless of whether an X
  # instance is running, hence it also works in the tty.
  programs.light.enable = true;
  programs.zsh.enable = true;

  # actkbp is an X-agnostic keyboard shortcut manager
  # We cannot use it to set the volumekeys because we use
  # PulseAudio, which supposedly is dependent upon the specific
  # user running it, and actkbp is also user-agnostic.
  # It basically cannot see PulseAudio
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 5"; }
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 5"; }
    ];
  };

  # Enable sound.
 sound.enable = true;
 services.pipewire = {
   enable = true;
   alsa.enable = true;
   alsa.support32Bit = true;
   pulse.enable = true;
 };

 # bluetooth
 hardware.bluetooth = {
   enable = true;
   powerOnBoot = true;
   settings = {
     General = {
       Enable = "Source,Sink,Media,Socket";
     };
   };
 };

  # Define a user account
  users.users.${args.userName} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    # wheel: gives sudo rights
    # networkmanager: don't need sudo for nmtui :)
    # video, audio: further controls
    extraGroups = [ "wheel" "networkmanager" "video" "audio"];
    initialPassword = "change-this";
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment.shells = with pkgs; [ zsh ];

  environment.variables = {
    EDITOR = "${args.editor}";
  };
  
  environment.systemPackages = with pkgs; [
    # GUI programs
    chromium
    brave
    mpv
    keepassxc
    wezterm
    libsForQt5.kolourpaint
    libsForQt5.kmines
    libsForQt5.kdeconnect-kde
    # CLI programs
    xclip
    xsecurelock
    rsync
    git
    helix
    skim
    ripgrep
    ffmpeg
    imagemagick
    cmus
    unzip
    # programming languages
    texlive.combined.scheme-full
    texlab
    marksman
    (pkgs.haskellPackages.ghcWithPackages ( haskell-packages: with haskell-packages; [
      xmonad
      xmonad-contrib
      xmobar
      pandoc
      pandoc-cli
      cabal-install
      time
      text
      hakyll
    ]))
    (callPackage ./hxh.nix {})
    haskell-language-server
    (agda.withPackages ( agda-packages: with agda-packages; [ standard-library ]))
    (python3.withPackages ( python-packages: with python-packages; [
      mutagen
      # numpy
    ]))
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      iosevka-comfy.comfy
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      monospace = [ "Iosevka Comfy" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
