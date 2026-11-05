{
  description = "echoes NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };
    umbriel.url = "github:noctalia-dev/umbriel";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixpkgs-unstable,
    nix-flatpak,
    home-manager,
    silentSDDM,
    umbriel,
    ...
  }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.SpiritBox = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit nixpkgs-unstable;
        inherit inputs;
      };

      modules = [
        ./configuration.nix
        silentSDDM.nixosModules.default
        nix-flatpak.nixosModules.nix-flatpak
        home-manager.nixosModules.home-manager
        umbriel.nixosModules.default

        {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                inherit system;
                config = prev.config;
              };
            })
          ];

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.echoes = import ./home.nix;

        }
      ];
    };
  };
}
