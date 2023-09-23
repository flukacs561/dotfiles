{ lib, fetchFromGitHub, haskellPackages }:
haskellPackages.mkDerivation {
  pname = "hxh";
  version = "0.1.0.0";
  # src = ./.;
  src = fetchFromGitHub {
    owner = "flukacs561";
    repo = "hxh";
    rev = "676c0f57e03088fe4efb54a1b63b5854a393ee51";
    sha256 = "0pkqb7y16gx5qrfjm3c9qflnxi3z58x5w0swq0567bw1r5zw0lbs";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ haskellPackages.base ];
  description = "Helix Haskell extensions";
  license = lib.licenses.gpl3Plus;
  mainProgram = "hxh";
}
