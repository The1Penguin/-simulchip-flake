
{
  description = "simulchip goes flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    simulchip = {
      url = "github:dfiru/simulchip";
      flake = false;
    };
  };

  outputs = inputs@{ nixpkgs, flake-parts, simulchip, ... }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem = {self', pkgs, system, ...}: {
        packages.default = self'.packages.simulchip;
        packages.simulchip = pkgs.python3.pkgs.buildPythonApplication {
          name = "simulchip";
          version = "1.0.0";

          src = simulchip;
          build-system = [
            pkgs.python3.pkgs.setuptools
          ];
          dependencies = with pkgs.python3Packages; [
            requests
            reportlab
            pillow
            toml
            typer
            rich
            rich-pixels
          ];
          
          format = "pyproject";

        };
      };

    };
}
