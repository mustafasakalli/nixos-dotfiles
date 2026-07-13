{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
  ];

  # Önyükleyici (Boot Loader) Ayarları
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  
  # Unfree (mülk/kapalı kaynak) paketlere izin ver (Vivaldi için şart)
  nixpkgs.config.allowUnfree = true;

  # Ağ Ayarları
  networking.networkmanager.enable = true;

  # Zaman Dilimi ve Konsol Klavye Düzeni
  time.timeZone = "Europe/Istanbul";
  console.keyMap = "trq";
  
  # Otomatik Çöp Toplama (Garbage Collection)
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";       
    options = "--delete-older-than 7d"; 
  };

  # X11 Görsel Sunucu ve Grafik Arayüz Ayarları (LightDM & Qtile)
  services.xserver = {
    enable = true; 
    displayManager.lightdm.enable = true;
    windowManager.qtile.enable = true;

    xkb = {
      layout = "tr";
      variant = "";
    };
  };

  # Kullanıcı Hesabı Tanımlaması (Sistem düzeyinde)
  users.users.mustafa = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Sudo yetkisi
    shell = pkgs.zsh;          # Varsayılan kabuk

  };

  # Sistem Genelinde Font Paketleri (Iosevka buraya eklendi!)
  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      iosevka
    ];
  };

  programs.firefox.enable = true;

  # Sistem Genelinde Aktif Edilen Programlar
  programs.zsh.enable = true;
  
  # Flakes ve yeni Nix komutlarını aktif ediyoruz
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}
