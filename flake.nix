{
  description = "Squire environment configuration via Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lumen = {
      url = "github:jnsahaj/lumen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    revdiff = {
      url = "github:umputun/revdiff";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, lumen, revdiff, ... }:
    let
      pkgs = import nixpkgs {
        system = "aarch64-linux";
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations.user = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit lumen revdiff; };
        modules = [ ./home.nix ];
      };
    };
}
