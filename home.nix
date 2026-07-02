{ config, pkgs, ... }:

{
  # Kullanıcı ve Ev Dizini Bilgileri
  home.username = "mustafa";
  home.homeDirectory = "/home/mustafa";
  home.stateVersion = "26.05"; 

  # Home Manager'ın kendi kendini yönetmesini sağlar
  programs.home-manager.enable = true;

  # 🛠️ YENİ NESİL MODÜLER BAĞLANTI BURADA:
  imports = [
    ./modules/alacritty.nix
    ./modules/rofi.nix
    ./modules/zsh.nix
  ];

  # Qtile Ayar Dosyasını Otomatik Bağlama
  xdg.configFile."qtile/config.py".source = ./qtile/config.py;
    
  home.packages = with pkgs; [
    tree
    bat
    geany
    fastfetch
    pcmanfm
    git
    micro
    nsxiv
    fresh-editor
  ];
}
