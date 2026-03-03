{
  my.shells.bash =
    { lib, config, pkgs, ... }:
    let
      functions = builtins.readFile ./functions.bash;
    in
    {
      programs.bash = {
        enable = true;
        enableCompletion = true;
        historySize = 10000;
        historyFile = "$HOME/.bash_history";
        historyFileSize = 100000;
        historyControl = ["erasedups" "ignoreboth"];
        historyIgnore = ["ls" "cd" "exit" "pwd"];

        shellAliases = {
          ll = "ls -alF";
          la = "ls -A";
          l = "ls -CF";
          vi = "nvim";
          vim = "nvim";
        };

        bashrcExtra = ''
          [ -n "$WEZTERM_PANE" ] && export NVIM_LISTEN_ADDRESS="/tmp/nvim$WEZTERM_PANE"
        '';

        initExtra = ''
          # ~/.bashrc: executed by bash(1) for non-login shells.
          # If not running interactively, don't do anything
          case $- in
              *i*) ;;
                *) return;;
          esac

          # append to the history file, don't overwrite it
          shopt -s histappend

          # check the window size after each command and, if necessary,
          # update the values of LINES and COLUMNS.
          shopt -s checkwinsize

          # make less more friendly for non-text input files, see lesspipe(1)
          [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

          # set a fancy prompt (non-color, unless we know we "want" color)
          case "$TERM" in
              wezterm|xterm-color|*-256color) color_prompt=yes;;
          esac

          # enable color support of ls and also add handy aliases
          # if [ -x /usr/bin/dircolors ]; then
          #     test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
          #     alias ls='ls --color=auto'
              #alias dir='dir --color=auto'
              #alias vdir='vdir --color=auto'

          #     alias grep='grep --color=auto'
          #     alias fgrep='fgrep --color=auto'
          #     alias egrep='egrep --color=auto'
          # fi

          # colored GCC warnings and errors
          #export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

          eval "$(${pkgs.bat-extras.batman}/bin/batman --export-env)"
          eval "$(${pkgs.bat-extras.batpipe}/bin/batpipe)"

          if [ -f ~/.bash_aliases ]; then
              . ~/.bash_aliases
          fi

          export LC_ALL=en_US.UTF-8
          export LANG=en_US.UTF-8

          ${functions}
          complete -C ${pkgs.terraform}/bin/terraform terraform
        '';
      };
    };
}
