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
  ];

  # Qtile Ayar Dosyasını Otomatik Bağlama
  xdg.configFile."qtile/config.py".source = ./qtile/config.py;
  
  # ZSH Yapılandırması
  programs.zsh = {
    enable = true;
    enableCompletion = true; 
    autosuggestion.enable = true; 
    syntaxHighlighting.enable = true; 

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "robbyrussell"; 
    };

    shellAliases = {
      ll = "ls -l";
      nrs = "sudo nixos-rebuild switch --flake ~/dotfiles#nixos"; 
      nfu = "nix flake update ~/dotfiles";                        
      qtile-bak = "geany ~/dotfiles/qtile/config.py";    
      gs  = "git status";
	  gcm = "git commit -m";
      ga  = "git add .";          
    };
  };
  
  home.packages = with pkgs; [
    tree
    bat
    geany
    fastfetch
    pcmanfm
    git
  ];
}
