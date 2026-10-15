{ ... }:

{
  xdg.configFile."xdg-desktop-portal-wlr/config".text = ''
    [screencast]
    chooser_type=dmenu
    chooser_cmd=noctalia dmenu -p "Select Screen"
  '';
}
