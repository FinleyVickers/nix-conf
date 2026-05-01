{ lib, pkgs, codexConfigTemplate, piSettingsTemplate }:

{
  # Codex updates this file itself when you change models interactively, so it
  # cannot live as an immutable Home Manager symlink in /nix/store.
  home.activation.codexWritableConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    target="$HOME/.codex/config.toml"

    mkdir -p "$HOME/.codex"

    if [ ! -e "$target" ] || [ -L "$target" ]; then
      rm -f "$target"
      cp ${codexConfigTemplate} "$target"
    fi
  '';

  # Pi updates this file when packages/extensions are installed through the CLI,
  # so seed it as a normal writable file instead of an immutable store symlink.
  home.activation.piWritableSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    target="$HOME/.pi/agent/settings.json"

    mkdir -p "$HOME/.pi/agent"

    if [ ! -e "$target" ] || [ -L "$target" ]; then
      rm -f "$target"
      cp ${piSettingsTemplate} "$target"
      chmod u+w "$target"
    fi
  '';

  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";
    profiles.finleyv = {
      isDefault = true;
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        sponsorblock
        tampermonkey
        ublock-origin
      ];
      settings = {
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;
        "layout.css.prefers-color-scheme.content-override" = 0;
        "ui.systemUsesDarkTheme" = 1;
      };
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=11";
        pad = "12x12";
      };
      "colors-dark" = {
        alpha = "0.96";
        foreground = "cdd6f4";
        background = "1e1e2e";
        regular0 = "45475a";
        regular1 = "f38ba8";
        regular2 = "a6e3a1";
        regular3 = "f9e2af";
        regular4 = "89b4fa";
        regular5 = "cba6f7";
        regular6 = "94e2d5";
        regular7 = "bac2de";
        bright0 = "585b70";
        bright1 = "f38ba8";
        bright2 = "a6e3a1";
        bright3 = "f9e2af";
        bright4 = "89b4fa";
        bright5 = "cba6f7";
        bright6 = "94e2d5";
        bright7 = "a6adc8";
      };
    };
  };

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    autocd = true;
    defaultKeymap = "emacs";
    enableCompletion = true;
    enableVteIntegration = true;

    autosuggestion = {
      enable = true;
      strategy = [ "history" "completion" ];
    };

    history = {
      append = true;
      expireDuplicatesFirst = true;
      extended = true;
      findNoDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      save = 10000;
      share = true;
      size = 10000;
    };

    historySubstringSearch.enable = true;

    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" "pattern" ];
    };

    completionInit = ''
      autoload -Uz compinit
      compinit
      zmodload zsh/complist
      _comp_options+=(globdots)
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' menu select
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      zstyle ':completion:*' squeeze-slashes true
      bindkey '^I' autosuggest-accept
    '';

    initContent = ''
      setopt AUTO_MENU
      setopt COMPLETE_IN_WORD
      setopt INTERACTIVE_COMMENTS
      setopt NO_FLOW_CONTROL

      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
    '';
  };
}
