let
    pkgs = import ./nix/pkgs.nix {};
    octokit = import ./nix/octokit.nix {inherit pkgs;};
in
    pkgs.stdenv.mkDerivation {
        name = "norush";
        buildInputs = [pkgs.makeWrapper];
        phases = ["installPhase"];
        installPhase = ''
            mkdir --parents $out/{bin,share/vendor}

            cp --recursive ${./lib} $out/share/lib

            makeWrapper ${pkgs.powershell}/bin/pwsh $out/bin/norush \
                --add-flags $out/share/lib/norush.ps1 \
                --add-flags -OctokitPath --add-flags ${octokit}
        '';
    }
