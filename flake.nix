{
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        name = "c_cpp_dev";
        shellHook = ''
          export _ZO_DATA_DIR="$(realpath ./.localzoxide)"
        '';
        buildInputs = [
          pkgs.pkg-config
          pkgs.gdb
          pkgs.rr
          pkgs.just
          pkgs.tree-sitter
          pkgs.clang
          pkgs.ninja
          pkgs.cmake
          pkgs.python3
        ];
      };
    };
}

