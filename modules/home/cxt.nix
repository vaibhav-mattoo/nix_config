{ config, pkgs, ... }:

let
  # Fetch the entire source tree from GitHub
  cxt-src = pkgs.fetchFromGitHub {
    owner = "vaibhav-mattoo";
    repo = "cxt";
    rev = "v0.1.1"; 
    sha256 = "Oq2lh+KOV0r9qerhRMp1pyyWgeI/vGckDpwwApl5ScM=";
  };

  cxt = pkgs.rustPlatform.buildRustPackage rec {
    pname = "cxt";
    version = "0.1.1";
    src = cxt-src;
    cargoLock = {
      lockFile = "${cxt-src}/Cargo.lock";
    };
    # Optionally, you can also specify cargoToml if needed:
    # cargoToml = "${cxt-src}/Cargo.toml";
    meta = with pkgs.lib; {
      description = "Aggregates file/directory contents and sends them to the clipboard, a file, or stdout";
      homepage = "https://github.com/vaibhav-mattoo/cxt";
      license = licenses.mit;
      platforms = platforms.unix;
    };
  };
in
{
  home.packages = with pkgs; [
    cxt
  ];
}
