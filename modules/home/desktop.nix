{ pkgs, catppuccin }:

{
  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-GTK-Dark";
      package = pkgs.magnetic-catppuccin-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.theme = {
      name = "Catppuccin-GTK-Dark";
      package = pkgs.magnetic-catppuccin-gtk;
    };
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Catppuccin-GTK-Dark";
      icon-theme = "Papirus-Dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/chrome" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "application/x-extension-htm" = [ "firefox.desktop" ];
      "application/x-extension-html" = [ "firefox.desktop" ];
      "application/x-extension-shtml" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "application/x-extension-xhtml" = [ "firefox.desktop" ];
      "application/x-extension-xht" = [ "firefox.desktop" ];
      "application/x-7z-compressed" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-7z-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/zip" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-zip" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-zip-compressed" = [ "org.gnome.FileRoller.desktop" ];
      "application/vnd.rar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-rar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-rar-compressed" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/gzip" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-gzip" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-bzip-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-xz-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
    };
    defaultApplications = {
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/chrome" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "application/x-extension-htm" = [ "firefox.desktop" ];
      "application/x-extension-html" = [ "firefox.desktop" ];
      "application/x-extension-shtml" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "application/x-extension-xhtml" = [ "firefox.desktop" ];
      "application/x-extension-xht" = [ "firefox.desktop" ];
      "application/x-7z-compressed" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-7z-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/zip" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-zip" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-zip-compressed" = [ "org.gnome.FileRoller.desktop" ];
      "application/vnd.rar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-rar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-rar-compressed" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/gzip" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-gzip" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-bzip-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-xz-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
    };
  };
  xdg.configFile."mimeapps.list".force = true;

  services.mako = {
    enable = true;
    settings = {
      background-color = "${catppuccin.base}F2";
      border-color = catppuccin.mauve;
      border-radius = 14;
      border-size = 2;
      default-timeout = 6000;
      font = "JetBrainsMono Nerd Font 10";
      height = 160;
      margin = "12";
      padding = "12";
      text-color = catppuccin.text;
      width = 380;
    };
  };

  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    font=JetBrainsMono Nerd Font:size=11
    width=42
    horizontal-pad=18
    vertical-pad=14
    inner-pad=10
    line-height=22

    [colors]
    background=1e1e2eee
    text=cdd6f4ff
    prompt=cba6f7ff
    placeholder=7f849cff
    input=cdd6f4ff
    match=f9e2afff
    selection=313244ff
    selection-text=cdd6f4ff
    selection-match=f9e2afff
    border=cba6f7ff

    [border]
    width=2
    radius=14
  '';

  xdg.configFile."wlogout/layout".text = ''
    [
      {
        "label": "logout",
        "action": "${pkgs.niri}/bin/niri msg action quit",
        "text": "Logout",
        "keybind": "e"
      },
      {
        "label": "suspend",
        "action": "${pkgs.systemd}/bin/systemctl suspend",
        "text": "Suspend",
        "keybind": "s"
      },
      {
        "label": "hibernate",
        "action": "${pkgs.systemd}/bin/systemctl hibernate",
        "text": "Hibernate",
        "keybind": "h"
      },
      {
        "label": "reboot",
        "action": "${pkgs.systemd}/bin/systemctl reboot",
        "text": "Reboot",
        "keybind": "r"
      },
      {
        "label": "shutdown",
        "action": "${pkgs.systemd}/bin/systemctl poweroff",
        "text": "Shutdown",
        "keybind": "p"
      }
    ]
  '';

  xdg.configFile."wlogout/style.css".text = ''
    * {
      border: none;
      border-radius: 0;
      font-family: "JetBrainsMono Nerd Font";
      font-size: 15px;
    }

    window {
      background: alpha(${catppuccin.mantle}, 0.72);
    }

    button {
      background: alpha(${catppuccin.base}, 0.96);
      border: 1px solid ${catppuccin.surface0};
      border-radius: 14px;
      color: ${catppuccin.text};
      margin: 10px;
      padding: 18px;
    }

    button:focus,
    button:hover {
      background: ${catppuccin.surface0};
      border-color: ${catppuccin.mauve};
      color: ${catppuccin.lavender};
    }

    #hibernate {
      border-color: ${catppuccin.blue};
    }

    #shutdown {
      border-color: ${catppuccin.red};
    }
  '';
}
