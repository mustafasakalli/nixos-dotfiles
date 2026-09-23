{
  description = "Mustafa'nin Kusursuz Flake Yapilandirmasi";
   
  inputs = {
    # nixpkgs: unstable yerine stable (nixos-25.05) kullan
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # home-manager: Sürümle uyumlu olması için release-25.05 dalını kullan
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs"; # nixpkgs'i ortak kullanmaya devam et
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
