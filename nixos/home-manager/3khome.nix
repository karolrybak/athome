# WARN: this file will get overwritten by $ cachix use <name>
{ pkgs, config, lib, ... }:
let 
  extrasZsh = builtins.readFile ./init.zsh;

  krUserConfig = { config, lib, pkgs, ... }: {
    programs.home-manager.enable = true;
    programs.zsh = {
      enable = true;
      autocd = true;
      dotDir = ".config/zsh";
      
      initExtra = extrasZsh;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting = {
        enable = true;
        highlighters = ["main" "brackets"];
      };
      history = {
        extended = true;
        path = "$ZDOTDIR/.zsh_history";
        save = 1000000;
        size = 10000;
        share = true;
      };
      
      shellAliases = {
        nixos-edit =
          "sudo micro /etc/nixos/configuration.nix && sudo nixos-rebuild switch";
        scs = "systemctl status";
        scd = "systemctl disable";
        sce = "systemctl enable";
        scr = "systemctl restart";
        scS = "systemctl start";
        scx = "systemctl stop";
        ls = "lsd";
        l = "lsd -lha";
        z = "zoxide";
        vi = "micro";
      };
      plugins = [
        {
          name = "trapd00r/LS_COLORS";
          file = "lscolors.sh";
          src = pkgs.fetchFromGitHub {
            owner = "trapd00r";
            repo = "LS_COLORS";
            rev = "master";
            sha256 = "sha256-/l4LpOBHPvfg6kmLvK96b5pOjEk9wh5QwfH79h5aVpw=";
          };
        }
        {
          name = "zsh-users/zsh-completions";
          file = "zsh-completions.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-completions";
            rev = "master";
            sha256 = "sha256-ibdEDgyUiJ84OUdlwrlvedlySE8uwQfNqQ6HEM+QCLM=";
          };
        }
        {
          name = "bashi";
          file = "bashi.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "karolrybak";
            repo = "bashi";
            rev = "master";
            sha256 = "sha256-Iq4wkQ6yN7tLkKWSNgGeBgoEePsfW/LadVxcq5aKypc=";
          };
        }
        {
          name = "vapniks/zsh-keybindings";
          file = "keycode_defs.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "vapniks";
            repo = "zsh-keybindings";
            rev = "master";
            sha256 = "sha256-gcFL1uL4gWBrJ1mkSVR+eGDs8m/sjNnDm7QymMqTQxs=";
          };
        }
      ];
    };
    
    programs.atuin = {
      enable = true;
      flags = [
        "--disable-up-arrow"
      ];
      enableZshIntegration = true;
    };
    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      settings = builtins.fromJSON(builtins.readFile "/etc/nixos/oh-my-posh.json");
    };
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };
    home.stateVersion = "24.05";
  };

in {
  home-manager.users.kr = krUserConfig;
}
