#!/bin/bash
set -e

git config --global --add safe.directory /github/workspace

# Define the branch names
main_branch=main=$1

echo $1
echo $2

custom_pattern="${INPUT_PATTERN}"

# Get all commit messages from the feature branch that are not in the main branch
commits=($(git log --pretty="%s EON" origin/$2 ^origin/$1))

pattern=""
if [ -z "${custom_pattern}" ]; then
  pattern="(feat|fix|ci|chore|docs|test|style|refactor): +#([0-9]+) -.{1,}$"
else
  echo "Apply custom pattern: ${custom_pattern}"
  pattern="${custom_pattern}"
fi

# Loop through the array and create other structure data
commits_struct=()
for commit in "${commits[@]}"; do
  if [ $commit != "EON" ]; then
    commit_msg+=" $commit"
  fi
  if [ $commit == "EON" ]; then
    commits_struct+=("${commit_msg}")
    commit_msg=""
  fi
done

all_commits_ok="true"
echo "| commit | status"
for msg in "${commits_struct[@]}"; do
  if [[ $msg =~ .*"Merge branch".* ]]; then
    echo "$msg | skipped"
    continue
  fi
  if [[ $msg =~ $pattern ]]; then
    echo "$msg | ok"
  else
    echo "$msg | invalid"
    all_commits_ok="false"
  fi
  echo "--"
done

if [ $all_commits_ok == "true" ]; then
  echo "commit-checker=true" >>$GITHUB_OUTPUT
  exit 0
else
  echo "commit-checker=false" >>$GITHUB_OUTPUT
  exit 1
fi
