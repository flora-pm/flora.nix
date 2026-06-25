{
  # These options can take some time to build
  withFourmolu ? true,
  withHlint ? true,
  withHLS ? false,
}:
let
  sources = import ./npins;
  pkgs = import sources."nixpkgs" { };
in
let
  inherit (pkgs) lib;
  inherit (pkgs) haskell haskellPackages;
  hlib = pkgs.haskell.lib;
in
let
  assertVersion =
    expectedVersion: drv:
    lib.throwIfNot (lib.getVersion drv == expectedVersion) ''
      Want ${lib.getName drv} ${expectedVersion}, but got ${lib.getVersion drv}.
    '' drv;
in
let
  libs = with pkgs; [
    zlib
    libpq
    libsodium
    gperftools
    libunwind
  ];
in
pkgs.mkShell {
  name = "flora";

  env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath libs;

  packages = [
    pkgs.npins

    pkgs.haskellPackages.cabal-gild
    pkgs.haskellPackages.cabal-install
    pkgs.haskell.compiler.ghc9103

    pkgs.yarn

    pkgs.pkg-config
    pkgs.esbuild
    pkgs.changelog-d
  ]
  ++ lib.optionals withFourmolu [
    (
      let
        fourmolu = haskellPackages.callCabal2nix "fourmolu" sources.fourmolu {
          Cabal-syntax = haskellPackages.Cabal-syntax_3_16_1_0;
          ghc-lib-parser = haskellPackages.ghc-lib-parser_9_14_1_20251220;
        };
      in
      hlib.dontCheck (hlib.justStaticExecutables fourmolu)
    )
  ]
  ++ lib.optionals withHlint [
    (assertVersion "3.10" haskellPackages.hlint)
    (assertVersion "0.15.0.0" haskell.packages.ghc912.apply-refact)
  ]
  ++ lib.optionals withHLS [
    haskell.compilers.ghc9103.haskell-language-server
  ]
  ++ libs;
}
