#!/bin/bash

# Check arguments
repoName=$1
while [ -z "$repoName" ]; do
  echo "Provide a repository name"
  read -r -p "Repository name: " repoName
done

# Initialize local repo
echo "# $repoName" >> README.md
git init
git add .
git commit -m "First commit"
git branch -M main

# Create remote repo on GitHub
curl -u "$GITHUB_USERNAME:$GITHUB_TOKEN" \
  https://api.github.com/user/repos \
  -d '{"name": "'"$repoName"'", "private": false}'

# Get clone URL
GIT_URL=$(curl -s -H "Accept: application/vnd.github.v3+json" \
  -u "$GITHUB_USERNAME:$GITHUB_TOKEN" \
  https://api.github.com/repos/$GITHUB_USERNAME/$repoName | jq -r '.clone_url')

# Add remote and push
if git remote | grep -q origin; then
	git remote set-url origin "&GIT_URL"
else
	git remote add origin "$GIT_URL"
fi
	git push -u origin main

