
{
  nix = {
    settings = {
      substituters = [
        "https://devenv.cachix.org"
      ];
      trusted-public-keys = [
        "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU= devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=;"
      ];
    };
  };
}
