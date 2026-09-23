{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
    ];

    userSettings = {
      "files.autoSave" = "afterDelay";
      "workbench.startupEditor" = "none";

      # Font ve Bitişik Harf (Ligature) Ayarları
      "editor.fontFamily" = "'JetBrains Mono', monospace";
      "editor.fontLigatures" = true; # ->, !=, == gibi karakterlerin şık birleşmesini sağlar
      "editor.fontSize" = 14;        # İsteğe bağlı yazı boyutu
    };
  };
}
