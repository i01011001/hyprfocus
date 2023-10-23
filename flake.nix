{
  inputs = {
    hyprland.url = "github:hyprwm/Hyprland";
    nix-filter.url = "github:numtide/nix-filter";
  };
  outputs = { self, hyprland, nix-filter, ... }:
    let
      inherit (hyprland.inputs) nixpkgs;
      forHyprlandSystems = fn: nixpkgs.lib.genAttrs (builtins.attrNames hyprland.packages) (system: fn system nixpkgs.legacyPackages.${system});
    in
    {
      packages = forHyprlandSystems
        (system: pkgs: rec {
          hyprfocus = pkgs.gcc13Stdenv.mkDerivation {
            pname = "hyprfocus";
            version = "0.1";
            src = nix-filter.lib {
              root = ./.;
              include = [
                "src"
                ./Makefile
              ];
            };


            nativeBuildInputs = with pkgs; [ pkg-config ];

            buildInputs = with pkgs; [
              hyprland.packages.${system}.hyprland.dev
            ]
            ++ hyprland.packages.${system}.hyprland.buildInputs;

            installPhase = ''
              install ./hyprfocus.so $out
            '';

            meta = with pkgs.lib; {
              homepage = "https://github.com/VortexCoyote/hyprfocus";
              description = "A hyprland plugin which provides focus animations for us borderless folks.";
              license = licenses.bsd3;
              platforms = platforms.linux;
            };


          };
          default = hyprfocus;
        });
    };
}

