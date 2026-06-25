{
  # These options can take some time to build
  withFourmolu ? true,
  withHlint ? true,
  withHLS ? false,
}:
let
  sources = import ./npins;

  pkgs = import sources."nixpkgs" { };
  inherit (pkgs) lib;

  ghc9102-pin = import (pkgs.fetchFromGitHub {
    owner = "nixos";
    repo = "nixpkgs";
    rev = "7282cb574e0607e65224d33be8241eae7cfe0979";
    hash = "sha256-hYKMs3ilp09anGO7xzfGs3JqEgUqFMnZ8GMAqI6/k04=";
  }) { };
in
pkgs.mkShell (
  let
    libs = with pkgs; [
      zlib
      libpq
      libsodium
      gperftools
      libunwind
    ];

    hlib = pkgs.haskell.lib;

    callHackage =
      {
        haskellPackages ? pkgs.haskellPackages,
        name,
        version,
      }:
      lib.pipe (haskellPackages.callHackage name version { }) [
        hlib.justStaticExecutables
        hlib.dontCheck
        hlib.doJailbreak
      ];

    allowGhcReference =
      drv:
      pkgs.haskell.lib.overrideCabal drv (_: {
        disallowGhcReference = false;
      });
  in
  {
    name = "flora";
    packages =
      with pkgs;
      # These don't build directly and need to be pinned
      [
        (callHackage {
          name = "postgresql-migration";
          version = "0.2.1.8";
        })

        haskellPackages.cabal-gild
        haskellPackages.cabal-install
        haskellPackages.ghc

        yarn

        pkg-config
        esbuild
        changelog-d
      ]
      ++ lib.optional withFourmolu (callHackage {
        name = "fourmolu";
        version = "0.18.0.0";
        haskellPackages = ghc9102-pin.haskell.packages.ghc912;
      })
      ++ lib.optionals withHlint [
        (callHackage {
          name = "hlint";
          version = "3.10";
        })
        (allowGhcReference (callHackage {
          name = "apply-refact";
          version = "0.15.0.0";
          haskellPackages = ghc9102-pin.haskell.packages.ghc912;
        }))
      ]
      ++ lib.optional withHLS haskellPackages.haskell-language-server
      ++ libs;

    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath libs;
  }
)
