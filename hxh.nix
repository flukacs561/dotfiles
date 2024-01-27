{ lib, fetchFromGitHub, haskellPackages }:
haskellPackages.mkDerivation {
  pname = "hxh";
  version = "0.1.0.0";
  # src = ./.;
  src = fetchFromGitHub {
    owner = "flukacs561";
    repo = "hxh";
    # This is the full hash of the commit.
    rev = "44b377d7811646d441c5a64318c8c519359ad015";
    # nix-prefetch-url --unpack https://github.com/flukacs561/hxh/archive/refs/heads/master.zip
    sha256 = "1vpgdhp2x1wp42sbf7hds14grkvyrdy6njpmnsyc832x2wrv8hjz";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ haskellPackages.base ];
  description = "Helix Haskell extensions";
  license = lib.licenses.gpl3Plus;
  mainProgram = "hxh";
}
