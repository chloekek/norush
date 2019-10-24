let
    pkgs = import ./nix/pkgs.nix {};
    octokit = import ./nix/octokit.nix {inherit pkgs;};
in
    pkgs.stdenv.mkDerivation {
        name = "norush";
        buildInputs = [pkgs.makeWrapper];
        phases = ["installPhase"];
        installPhase = ''
            mkdir --parents $out/{bin,share/lib}

            cp --recursive ${./bin} $out/share/bin
            cp --recursive ${./lib} $out/share/lib/Norush

            makeWrapper ${pkgs.powershell}/bin/pwsh $out/bin/norush \
                --prefix PSModulePath : $out/share/lib \
                --set OCTOKIT ${octokit} \
                --add-flags $out/share/bin/norush.ps1
        '';
    }
