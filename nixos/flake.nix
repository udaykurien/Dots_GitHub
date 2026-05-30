{
  description = "echoes NixOS config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, nix-flatpak, ... }:
  let
    system = "x86_64-linux";
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
  in {
    nixosConfigurations.SpiritBox = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit pkgs-unstable; };
      modules = [
        ./configuration.nix
        nix-flatpak.nixosModules.nix-flatpak
      ];
    };
  };
}
