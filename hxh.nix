{ lib, fetchFromGitHub, haskellPackages }:
haskellPackages.mkDerivation {
  pname = "hxh";
  version = "0.1.0.0";
  # src = ./.;
  src = fetchFromGitHub {
    owner = "flukacs561";
    repo = "hxh";
    rev = "e6cd1cb3788d28ef45af49ad59f3f158f162ec73";
    sha256 = "02m2zxf9pwpzxmcyz1xza8x9qm8b28iz86an814490x2a2k2fpfc";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ haskellPackages.base ];
  description = "Helix Haskell extensions";
  license = lib.licenses.gpl3Plus;
  mainProgram = "hxh";
}
