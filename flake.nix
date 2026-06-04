{
  description = "My NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix # Ваш основной конфиг

        # ВОТ ЭТУ СТРОКУ НУЖНО ДОБАВИТЬ:
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
