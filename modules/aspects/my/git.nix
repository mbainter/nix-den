{
  my.git.homeManager =
    { lib, pkgs, ... }:
    let
      opcli = lib.getExe pkgs._1password-cli;
      ghbin = lib.getExe pkgs.gh;
    in
    {
      programs = {
        jujutsu.enable = true;
        jjui.enable = true;
        delta = {
          enable = true;
          enableGitIntegration = true;
          enableJujutsuIntegration = true;
          options = {
	    features = "catppuccin-Macchiato";
            navigate = true;
            # side-by-side = true;
            # line-numbers = true;
          };
        };

        git = {
          enable = true;
          # gitFull to get access to scalar
          package = pkgs.gitFull;
          lfs.enable = true;
          signing = {
            key = "0xD77610FD26110F0C";
            signByDefault = false;
          };
          #commit.gpgSign = false;
          #gpg.program = "${config.programs.gpg.package}/bin/gpg2";

          includes = [
            {
              path = "~/.repos.gitconfig";
            }
	    {
	      # FIXME: Remove after amending email addresses for signing key.
	      path = "~/repos/github.com/mbainter/.gitconfig";
	      condition = "gitdir:**/github.com/mbainter/";
	    }
	    {
	      path = "~/repos/github.com/work/.gitconfig";
	      condition = "gitdir:**/github.com/work/";
	    }
	    {
	      path = "~/repos/github.com/work/.gitconfig";
	      condition = "gitdir/i:**/github.com/Litmus*/";
	    }
	    {
	      path = "~/repos/github.com/work/.gitconfig";
	      condition = "gitdir/i:**/github.com/validity*/";
	    }
          ];

          ignores = [
            "*~"
            "*.swp"
            ".envrc.local"
            ".direnv"
            "result"
          ];

          settings = {
            user = {
              name = "Mark Bainter";
              email = "mbainter@opscraft.com";
            };

            init = {
              #templateDir = "/home/mbainter/.git-template";
              defaultBranch = "main";
            };

            core = {
              fsmonitor = lib.getExe pkgs.rs-git-fsmonitor;
            };

            alias = {
              co-pr = "!bash -c 'git fetch origin pull/$1/head:pr/$1 && git checkout pr/$1' -";
              create-branch = "!bash -c 'git push origin HEAD:refs/heads/$1 && git fetch origin && git branch --track $1 origin/$1 && cd . && git checkout $1' -";
              delete-branch = "!bash -c 'git push origin :refs/heads/$1 && git branch -D $1' -";
              merge-branch = "!git checkout master && git merge @{-1}";
              aa = "add --all";
              l = "log --decorate --max-count 5 --oneline";
              gslog = "log --graph --decorate --all --max-count 5 --name-status --oneline";
              glog = "log --graph --pretty=format:\"%Cred%h%Creset . %an: %s %Cgreen(%cr)%Creset\" --abbrev-commit --date=relative";
              pr = "\"!_git_pr() { git fetch origin pull/$1/head:pr-$1 && git checkout pr-$1; }; _git_pr\"";
              branches = "for-each-ref --sort=-committerdate --format=\"%(color:blue)%(authordate:relative)\t%(color:red)%(authorname)\t%(color:white)%(color:bold)%(refname:short)\" refs/remotes";
              fpush = "push --force-with-lease";
              lgb = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset%n' --abbrev-commit --date=relative --branches";
              clone-worktree = ''
                !f() { \
                  url="$1"; \
                  name=$(basename "$url" .git); \
                  repoHub=$(realpath -m "''${2:-$name}"); \
                  if [ -e "$repoHub" ]; then \
                    echo "Error: '$repoHub' already exists"; \
                    exit 1; \
                  fi; \
                  mkdir "$repoHub"; \
                  git clone --bare "$url" "$repoHub/.bare"; \
                  printf 'gitdir: ./.bare\n' > "$repoHub/.git"; \
                  git -C "$repoHub" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'; \
                  git -C "$repoHub" fetch; \
                  defaultBranch=$(git -C "$repoHub" symbolic-ref --short HEAD); \
                  git -C "$repoHub" worktree add "$dest/$branch" "$branch"; \
                }; f
              '';
            };

            push = {
              default = "simple";
            };

            pull = {
              rebase = true;
              ff = "only";
            };

            fetch = {
              prune = true;
            };

            rebase = {
              autosquash = true;
              updateRefs = true;
            };

            merge = {
              conflictStyle = "diff3";
              ff = "only";
            };

            github = {
              user = "Mark-Bainter_Validity";
            };

            credential = {
              helper = "!${opcli} plugin run -- ${ghbin} auth git-credential";

              "https://github.com/" = {
                helper = "!${opcli} plugin run -- ${ghbin} auth git-credential";
              };
              "https://gist.github.com/" = {
                helper = "!${opcli} plugin run -- ${ghbin} auth git-credential";
              };
              "https://dev.azure.com/" = {
                useHttpPath = true;
              };
            };

            branch = {
              "*" = {
                rebase = true;
                autosetuprebase = "always";
              };
            };

            difftool = {
              prompt = false;
              trustExitCode = true;
            };

            maintenance.strategy = "incremental";

            url = {
              "https://github.com" = {
                insteadOf = "ssh://git@github.com";
              };
              "https://gitlab.com" = {
                insteadOf = "ssh://git@gitlab.com";
              };
            };
          };
        };
      };
    };
}
