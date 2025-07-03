{
  profile,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./zshrc-personal.nix
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = ["main" "brackets" "pattern" "regexp" "root" "line"];
    };
    historySubstringSearch.enable = true;

    history = {
      ignoreDups = true;
      save = 10000;
      size = 10000;
    };

    oh-my-zsh = {
      enable = true;
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
    ];



initContent = ''
  # Your existing bindkey settings
  bindkey "\eh" backward-word
  bindkey "\ej" down-line-or-history
  bindkey "\ek" up-line-or-history
  bindkey "\el" forward-word
  bindkey ';' autosuggest-accept


  function yazi-launch() {
  # Create a temporary file to store the last directory
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"

  # Launch Yazi, telling it where to write its last CWD on quit
  yazi --cwd-file="$tmp"

  # Read the CWD from the temp file safely.
  local cwd
  IFS= read -r  cwd < "$tmp"

  # If a CWD was written and it's different from the current directory, change to it
  if [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    cd -- "$cwd"
  fi

  # Clean up
  rm -f -- "$tmp"
  zle reset-prompt
}

# Make it a ZLE widget that modifies shell state
zle -N yazi-launch
bindkey '^F' yazi-launch


  if [ -f $HOME/.zshrc-personal ]; then
    source $HOME/.zshrc-personal
  fi
'';

    shellAliases = {
      sv = "sudo nvim";
      v = "nvim";
      c = "clear";
      fr = "nh os switch --hostname ${profile}";
      fu = "nh os switch --hostname ${profile} --update";
      ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      cat = "bat";
      man = "batman";
      lg = "lazygit";
      ":q" = "exit";
      ":Q" = "exit";
      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -iv";
      mkdir = "mkdir -pv";
    };
  };
}
