{
  description = "NixOS system configuration for finleyv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
  };

  outputs = { nixpkgs, home-manager, nur, ... }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      codexPackageFor =
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        pkgs.callPackage ./pkgs/codex { };
    in
    {
      packages = forAllSystems (system: {
        codex = codexPackageFor system;
        default = codexPackageFor system;
      });

      homeConfigurations.finleyv =
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            overlays = [ nur.overlays.default ];
          };
          modules = [ ./home.nix ];
        };

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit codexPackageFor;
        };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [ nur.overlays.default ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.finleyv = import ./home.nix;
          }
        ];
      };
    };
}
