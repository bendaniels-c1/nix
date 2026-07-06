{
  description = "Ben's system configuration via Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      mkHome = system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit system; };
        };
    in
    {
      homeConfigurations = {
        "bendaniels@darwin" = mkHome "aarch64-darwin";
        "bendaniels@linux" = mkHome "x86_64-linux";
        "bendaniels@linux-aarch64" = mkHome "aarch64-linux";
      };
    };
}
