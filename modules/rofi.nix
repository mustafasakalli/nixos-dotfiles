{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;

    # Stable sürümde 'settings' yok; 'extraConfig' kullanılır.
    # Tüm değerler string olarak yazılmalı, çünkü rasi config.rasi'ye gömülür.
    extraConfig = {
      terminal             = "${pkgs.alacritty}/bin/alacritty";
      modi                 = "run,drun,window";
      icon-theme           = "Papirus-Dark";
      show-icons           = "true";
      drun-display-format  = "{icon} {name}";
      location             = "0";
      disable-history      = "false";
      hide-scrollbar       = "true";
      display-drun         = "    Apps ";
      display-run          = "    Run ";
      display-window       = " 󰕰  Window ";
      sidebar-mode         = "true";
    };

    # Stable sürümde 'theme' bir dosya yolu bekler.
    # Ayrı .rasi dosyası olarak yazdık.
    theme = ./rofi-theme.rasi;
  };
}
