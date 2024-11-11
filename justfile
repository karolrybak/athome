build-nixos:
    # @nixos-rebuild --file ./nixos/configuration.nix dry-build
    @sudo rsync -av --delete --no-perms ./nixos/ /etc/nixos --exclude hardware-configuration.nix
    @sudo nixos-rebuild switch   
set-channels:
    sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    sudo nix-channel --add https://channels.nixos.org/nixos-unstable nixos
    nix-channel --update