{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 1;
          y = 1;
        };
        dynamic_padding = false;
        decorations = "none";
        title = "alacritty";
        dynamic_title = true;
      };
      font = {
        normal = {
          family = "Iosevka Comfy";
          style = "Regular";
        };
        bold = {
          family = "Iosevka Comfy";
          style = "Bold";
        };
        italic = {
          family = "Iosevka Comfy";
          style = "Italic";
        };
        bold_italic = {
          family = "Iosevka Comfy";
          style = "Bold Italic";
        };
        size = 6.5;
        offset = {
          x = -1;
          y = -1;
        };
      };
      bell.duration = 0;
      bell.command = "None";
      colors = {
  # Default colors
        primary = {
          background = "0xffffff";
          foreground = "0x24292f";
        };

  # Normal colors
        normal = {
          black = "0x24292e";
          red = "0xd73a49";
          green = "0x28a745";
          yellow = "0xdbab09";
          blue = "0x0366d6";
          magenta = "0x5a32a3";
          cyan = "0x0598bc";
          white = "0x6a737d";
        };

  # Bright colors
        bright = {
          black = "0x959da5";
          red = "0xcb2431";
          green = "0x22863a";
          yellow = "0xb08800";
          blue = "0x005cc5";
          magenta = "0x5a32a3";
          cyan = "0x3192aa";
          white = "0xd1d5da";
        };
      };
    };
  };
}

