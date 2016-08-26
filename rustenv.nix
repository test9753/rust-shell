let
  date_nightly = "2016-08-25"; # XXX Change the date as required
  pkgs = import <nixpkgs> {};
  settings = pkgs.fetchFromGitHub {
    owner = "test9753";
    repo = "nix-rust-nightly";
    rev = "e75093a0d0b26325f1e89c363325b280c905c4f5";
    sha256 = "1r8lgd9adg4i81899pyb3bw46nb5y5wac2vjvdxq6cznj6wnlbyk";
  };
  funs = pkgs.callPackage "${settings}/rust-nightly.nix" {};
  cargo_nightly = funs.cargo { date = date_nightly; };
  rust_nightly = funs.rustcWithSysroots {
    rustc = funs.rustc { date = date_nightly; };
    sysroots = [
      (funs.rust-std {
        date = date_nightly;
      })
      (funs.rust-std {
        date = date_nightly;
        system = "x86_64-unknown-linux-musl";
      })
    ];
  };
in rec {
  rustEnv = pkgs.stdenv.mkDerivation rec {
    name = "rusty";
    nativeBuildInputs = [ pkgs.gdb rust_nightly cargo_nightly ];
  };
}
