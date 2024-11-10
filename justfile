build-nixos:
    # @nixos-rebuild --file ./nixos/configuration.nix dry-build
    @sudo rsync -av --delete --no-perms ./nixos/ /etc/nixos
    @sudo nixos-rebuild switch   
set-channels:
    sudo nix-channel --add https://github.com/nix-community/home-manager/archive/unstable.tar.gz home-manager 
    sudo nix-channel --add https://channels.nixos.org/nixos-unstable nixos
    nix-channel --update