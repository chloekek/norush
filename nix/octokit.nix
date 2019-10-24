{pkgs}:
let
    src = pkgs.fetchurl {
        url = "https://globalcdn.nuget.org/packages/octokit.0.36.0.nupkg";
        sha256 = "1ymbibj2cjfprczn7abg0b8d0qwzw46i2i5vp4rvg7x1xnxhlplp";
    };
in
    pkgs.stdenv.mkDerivation {
        name = "octokit";
        buildInputs = [pkgs.unzip];
        phases = ["installPhase"];
        installPhase = ''
            mkdir --parents $out/lib
            unzip ${src}
            mv lib/net46/Octokit.dll $out/lib
        '';
    }
