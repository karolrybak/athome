build-nixos:
    # @nixos-rebuild --file ./nixos/configuration.nix dry-build
    @sudo rsync -av --delete --no-perms ./nixos/ /etc/nixos
    @sudo nixos-rebuild switch   
