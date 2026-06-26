{
  description = "Mustafa'nin Kusursuz Flake Yapilandirmasi";

  inputs = {
    # Sistem paketleri için ana kaynak (26.05 veya unstable kullanabilirsin)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Kullanıcı ayarları için Home Manager kaynağı
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Çakışma olmasın diye ortak nixpkgs'i kullandırıyoruz
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix # Ana sistem dosyası
        
        # Home Manager'ı Flake modülü olarak sisteme enjekte ediyoruz
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mustafa = import ./home.nix;
        }
      ];
    };
  };
}
