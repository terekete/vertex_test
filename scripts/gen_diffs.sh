#! /bin/bash

set -e

git rev-parse HEAD >> commit.txt
git rev-parse --short HEAD >> short_commit.txt
commit=$(cat commit.txt)

printf "commit: ${commit}"
printf "base: ${base_branch}"
if [[ ! -z "${pr_number}" ]]; then
    printf "pull request: #${pr_number}"
fi

git config user.email "<>"
git config user.name "git"
git remote | xargs -n1 git remote remove
git remote add origin ${base_repo_url}
git remote -vv

{
    git branch -D base-branch
} || {
    printf "\n"
}
{
    git branch -D feature
} || {
    printf "\n"
}

if [[ ! -z "${pr_number}" ]]; then
    git fetch origin "pull/${pr_number}/head":feature
    git fetch --unshallow
else
    git branch -m feature
fi

git fetch origin "${base_branch}":base-branch
git checkout base-branch
git diff --name-only feature...base-branch > POTENTIAL_CONFLICT.txt
git merge --no-ff feature
git status


#! /bin/bash
DIFF=$(git diff --name-only origin/"${base_branch}"...HEAD)
DIFF_TEAM=""
DIFF_LIST=""

for file in $DIFF
do
    if [[ "${file}" =~ ^teams/([^/]*)/([^/]*)/([^/]*)/ ]]
    then
        DIFF_TEAM+="${BASH_REMATCH[1]}\n"
        DIFF_LIST+="${BASH_REMATCH[0]}\n"
    fi
done

printf "${DIFF_TEAM}" | sort | uniq > DIFF_TEAM.txt
printf "${DIFF_LIST}" | sort | uniq > DIFF_LIST.txt

printf "\nDIFF_LIST:\n"
cat DIFF_LIST.txt
