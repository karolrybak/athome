nixos-boot:
    just nixos-update-config
    @sudo nixos-rebuild boot
nixos-switch:
    just nixos-update-config
    @sudo nixos-rebuild switch   
nixos-update-config:
    @sudo rsync -av --delete --no-perms ./nixos/ /etc/nixos --exclude hardware-configuration.nix
set-channels:
    sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    sudo nix-channel --add https://channels.nixos.org/nixos-unstable nixos
    nix-channel --update