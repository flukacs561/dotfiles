{
  description = "This is my first attempt at using nix flakes.";

  inputs = {    
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs:
    let
      args = import ./variables.nix;
    in
    {
      nixosConfigurations.abulafia = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-t490
          
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${args.userName} = import ./home.nix;
          }
        ];
      };
    };
  
  nixConfig.experimental-features = "nix-command flakes";
}
