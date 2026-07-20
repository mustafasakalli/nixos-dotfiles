{ config, pkgs, ... }: {
    
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
      nfu = "nix flake update";                        
      qtile-bak = "geany ~/dotfiles/qtile/config.py";    
      gs  = "git status";
      gcm = "git commit -m";
      ga  = "git add .";          
    };
  };
}
