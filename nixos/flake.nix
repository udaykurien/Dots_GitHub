{
  description = "echoes NixOS config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, nix-flatpak, ... }: {
    nixosConfigurations.SpiritBox = nixpkgs.lib.nixosSystem {
      modules = [
       {nixpkgs.hostPlatform = "x86_64-linux";}
        ./configuration.nix
        nix-flatpak.nixosModules.nix-flatpak
        {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = nixpkgs-unstable.legacyPackages.${prev.system};
            })
          ];
        }
      ];
    };
  };
}
