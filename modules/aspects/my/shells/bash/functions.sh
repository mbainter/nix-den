#!/usr/bin/env bash

function repoUpdate {
  fd -apH "/\.git/config" $HOME/repos -X rg -U --multiline-dotall --pcre2 "\[maintenance\][^[]*auto\s*=\s*false" -l | awk 'BEGIN { print "[maintenance]" } { match($0, /(.*)\/\.git\/config$/, rp); printf("  repo = %s\n",rp[1]) }' > $HOME/.repos.gitconfig
}
