let
  args = import ./variables.nix;
in  
{
  programs.helix = {
    enable = args.isHelix;
    # defaultEditor = args.isHelix;
    settings = {
      theme = "github_light";
      editor = {
        line-number = "relative";
        cursorline = true;
        mouse = false;
        bufferline = "never";
        idle-timeout = 50;
        cursor-shape.insert = "bar";
        statusline.left = ["mode" "spinner" "file-name" "spacer" "file-modification-indicator" ];
        statusline.right = ["diagnostics" "version-control" "selections" "position" "file-encoding"];
        text-width = 120;
        soft-wrap = {
          enable = false;
          wrap-at-text-width = true;
        };
      };
      keys.normal = {
        g.u = ":lsp-restart";
        esc = ["collapse_selection" "keep_primary_selection"];
        "A-e" = ["collapse_selection" "keep_primary_selection"];
      };
      keys.select."A-e" = ["collapse_selection" "keep_primary_selection" "normal_mode"];
      keys.insert."A-e" = "normal_mode";
    };
    languages = {
      language = [{
        name = "haskell";
        scope = "source.haskell";
        injection-regex = "haskell";
        file-types = ["hs"];
        roots = [];
        auto-format = false;
        comment-token = "--";
        language-server = {
          command = "haskell-language-server-wrapper";
          args = ["--lsp"];
        };
      }
      {
        name = "latex";
        soft-wrap.enable = true;
        language-server.command = "texlab";
        config.texlab = {
          build.args = ["-pdf" "-interaction=nonstopmode" "-synctex=1" "%f"];
          build.onSave = true;
          completion.matcher = "prefix-ignore-case";
          cleanAuxiliary = true;
        };
      }
      {
        name = "markdown";
        soft-wrap.enable = true;
      }
      ];

    };
  };
}
