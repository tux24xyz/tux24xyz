#!/bin/bash


printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

rm -r public resources .hugo_build.lock

# Build the project.
hugo --gc --minify
# Go To Public folder
cd public

# Add changes to git.
git add -A

# Commit changes.
msg="網站更新 $(date +'%Y-%m-%d %H:%M:%S')"
if [ -n "$*" ]; then
    msg="$*"
fi
git commit -m "$msg"

git pull --rebase origin main
# Push source and build repos.
git push -f origin main
git push -f origin main

