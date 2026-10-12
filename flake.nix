{
  description = "Advent of Code 2024 in VHDL";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # Only the Julia sources are needed. To hack on a local checkout:
    # nix develop --override-input jhdl path:../JHDL
    jhdl = {
      url = "github:A-H-Technology/JHDL";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      jhdl,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        # Julia resolves `using JHDL` from a load-path dir holding JHDL/src/JHDL.jl.
        # JHDL has no non-stdlib deps, so this skips Pkg entirely.
        jhdlLoadPath = pkgs.linkFarm "jhdl-load-path" [
          {
            name = "JHDL";
            path = jhdl;
          }
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            ghdl
            surfer
            just
            curl
            julia
          ];
          # Trailing colon keeps Julia's default load path (stdlib etc.)
          JULIA_LOAD_PATH = "${jhdlLoadPath}:";
        };
      }
    );
}
