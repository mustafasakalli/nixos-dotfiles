{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;

    extraConfig = {
      terminal            = "${pkgs.alacritty}/bin/alacritty";
      modi                = "run,drun,window";
      icon-theme          = "Papirus-Dark";
      show-icons          = true;   # Tırnak kaldırıldı (boolean)
      drun-display-format = "{icon} {name}";
      location            = 0;      # Tırnak kaldırıldı (integer)
      disable-history     = false;  # Tırnak kaldırıldı (boolean)
      sidebar-mode        = false;  # Tırnak kaldırıldı (boolean)
      display-drun        = "    Apps ";
      display-run         = "    Run ";
      display-window      = " 󰕰  Window ";
    };

    theme = ./rofi-theme.rasi;
  };
}
