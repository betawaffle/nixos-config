{ pkgs, ... }:
{
  environment.sessionVariables = {
    # TODO: Figure out if this is still necessary.
    GTK_USE_PORTAL = "1";

    XCURSOR_THEME = "Adwaita";
  };

  environment.systemPackages = with pkgs; [
    arc-theme
    catppuccin-gtk
    gruvbox-dark-gtk
    gruvbox-dark-icons-gtk
    gnome.adwaita-icon-theme

    glib
    greetd.gtkgreet
  ];

  gtk.iconCache.enable = true;

  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
  ];
}
