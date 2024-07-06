{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
      ];

      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        packages.default = pkgs.hello;

        formatter = pkgs.alejandra;

        devenv.shells.default = {
          packages = [config.packages.default];

          languages = {
            javascript = {
              enable = true;
              npm.enable = true;
              bun = {
                enable = true;
              };
            };
          };

          processes = {
#            watch.exec = "npm run watch";
          };

#          enterShell = ''
#            hello
#          '';
        };
      };
    };
}
