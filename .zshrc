alias ghlogin='gh auth login --with-token < ~/"qdoc repo"'
alias pushu='git push --set-upstream origin $(git branch --show-current)'
alias cmds='grep -E "function|alias" < ~/.zshrc'
alias sed='gsed'
export PATH="/opt/homebrew/opt/node@16/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
#export PATH="/Users/xian/Downloads/sonar-scanner-4.7.0.2747-macosx/bin:$PATH"

# Added by Amplify CLI binary installer
export PATH="$HOME/.amplify/bin:$PATH"

function newbranch() {
  if [ -z "$1" ]; then
    return 1
  fi
  branch='dev'
  name="$1"
  while getopts "b:n:" option; do
    case "${option}" in
      b)
        branch=$OPTARG
        ;;
      n)
        name=$OPTARG
        ;;
      *)
        echo "Usage:"
        echo "newbranch [-n name] [-b base]"
        echo "newbranch name"
        return 0
    esac
  done
  git checkout "$branch"
  git fetch
  git pull
  fullname="xm/QM-$name"
  git checkout -b "$fullname"
  git push --set-upstream origin "$fullname"
}

function check() {
  git checkout "xm/QM-"$1
}

function mergedev() {
  curr=`git branch --show-current`
  git checkout dev
  git pull
  git checkout "$curr"
  git merge --squash dev

}

function createpr() {
  #if [ -z "$(gh auth status | grep 'Logged in')" ]; then
    #echo "Not currently logged in"
    #return 1
  #fi
  branch="$(git branch --show-current)"
  if [ "$branch" = "dev" ]; then
    echo "Currently on dev"
    return 1
  fi
  ticket=$branch[4,-1]

  title=$ticket
  body=""
  mergeTo="dev"

  while getopts "b:t:m:h:" option; do
    case "${option}" in
      b)
        body=$OPTARG
        ;;
      t)
        title=$title" - "$OPTARG
        ;;
      m)
        mergeTo=$OPTARG
        ;;
      h)
        echo "Usage: createpr [-b BODY] [-t TITLE] [-m TARGET_BRANCH]"
        return 1
        ;;
      *)
        echo "Usage: createpr [-b BODY] [-t TITLE] [-m TARGET_BRANCH]"
    esac
  done

  ticketLink="https://qdoc.atlassian.net/browse/$ticket"
  if [ -z "$body" ]; then
    body=$ticketLink
  else
    lines=$'\n\n'
    body=$body$lines$ticketLink
  fi

  echo $body
  echo $mergeTo
  echo $title

  git push &&
  gh pr create --body $body --base $mergeTo --title $title
}

testopts() {

  multi=''
  while getopts "h:" option; do
    case "${option}" in
      h)
        multi+=("$OPTARG")
        echo $OPTARG
        ;;
      *)
        echo "Usage: createpr [-b BODY] [-t TITLE] [-m TARGET_BRANCH]"
    esac
  done
  shift $((OPTIND -1))
  echo $multi
  echo "${multi[@]}"
}

function hotfix() {
  # with changes made and not committed, on a branch based on dev
  title=$1
  if [ -z "$title" ]; then
    echo "provide hotfix title"
    return 0
  else
    fullPRTitle=" - "$title
  fi
  branchTitle="xm/hotfix-$title"
  testingBranchTitle="xm/hotfix-testing-$title"

  git stash
  git checkout dev && git pull
  git checkout -b $branchTitle
  git push --set-upstream origin $branchTitle
  git stash pop
  git commit -a -m "automated hotfix commit" && \
  git push
  gh pr create --base dev --title "[HOTFIX] autoPR$fullPRTitle" --body "beep boop"

  git reset HEAD~1
  git stash
  git checkout testing && git pull
  git checkout -b $testingBranchTitle
  git push --set-upstream origin $testingBranchTitle
  git stash pop
  git commit -a -m "automated hotfix commit" && \
  git push && \
  gh pr create --base testing --title "[HOTFIX] [testing] autoPR$fullPRTitle" --body "beep boop"

}

autoload -Uz compinit && compinit
