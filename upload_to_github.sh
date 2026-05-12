#!/usr/bin/env bash
set -euo pipefail

# Usage: ./upload_to_github.sh <github-username> <repo-name> [public|private] [https|ssh|gh]
# Example: ./upload_to_github.sh gurpreetsingh LocalEventsExplorer public https

USERNAME=${1:-}
REPO=${2:-}
VISIBILITY=${3:-public}
PROTO=${4:-https}

if [[ -z "$USERNAME" || -z "$REPO" ]]; then
  echo "Usage: $0 <github-username> <repo-name> [public|private] [https|ssh|gh]"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

# Ensure .gitignore exists
if [[ ! -f .gitignore ]]; then
  cat > .gitignore <<'GITIGNORE'
# Xcode
build/
DerivedData/
*.xcworkspace
xcuserdata/
*.xcuserdata
*.xcscmblueprint
*.xcodeproj/project.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings

# Swift package manager
/.build/
/.swiftpm/

# CocoaPods
Pods/

# Carthage
Carthage/Build/

# fastlane
/fastlane/report.xml
/fastlane/Preview.html

# personal settings
*.DS_Store

# macOS
*.DS_Store

# Bundler
/.bundle/

# Derived files
*.hmap
*.ipa
*.dSYM.zip
*.dSYM
GITIGNORE
fi

# Ensure LICENSE exists (MIT)
if [[ ! -f LICENSE ]]; then
  year=$(date +%Y)
  cat > LICENSE <<LICENSE
MIT License

Copyright (c) ${year} ${USERNAME}

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
LICENSE
fi

# Initialize git if needed
if [[ ! -d .git ]]; then
  git init
fi

git add -A
# If there are no commits, create initial commit
if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
  git commit -m "Initial commit — LocalEventsExplorer"
else
  # Otherwise create a new commit if there are changes
  if ! git diff --cached --quiet; then
    git commit -m "Update project files"
  else
    echo "No changes to commit"
  fi
fi

REMOTE_URL=""

if [[ "$PROTO" == "gh" ]]; then
  if ! command -v gh >/dev/null 2>&1; then
    echo "gh CLI not found. Install it or use https/ssh mode."
    exit 1
  fi
  vis="--public"
  if [[ "$VISIBILITY" == "private" ]]; then
    vis="--private"
  fi
  gh repo create ${USERNAME}/${REPO} $vis --source=. --remote=origin --push
  echo "Repository created and pushed using gh CLI"
  exit 0
fi

if [[ "$PROTO" == "ssh" ]]; then
  REMOTE_URL="git@github.com:${USERNAME}/${REPO}.git"
else
  REMOTE_URL="https://github.com/${USERNAME}/${REPO}.git"
fi

# Add remote if not present
if ! git remote | grep -q origin; then
  git remote add origin "$REMOTE_URL" || true
else
  git remote set-url origin "$REMOTE_URL"
fi

# Create remote repo using GitHub API if possible (requires GH_TOKEN or gh)
if command -v gh >/dev/null 2>&1; then
  echo "Using gh to ensure remote exists and push"
  visFlag="--public"
  if [[ "$VISIBILITY" == "private" ]]; then
    visFlag="--private"
  fi
  # gh repo create is idempotent when remote exists
  gh repo create ${USERNAME}/${REPO} $visFlag --source=. --remote=origin --push || true
  git push -u origin main
  exit 0
fi

# Fallback: attempt to push. If remote doesn't exist, GitHub will reject and you'll need to create it manually.

git branch -M main

echo "Pushing to $REMOTE_URL (you may be prompted for credentials)"
git push -u origin main

echo "Done. If the remote repo did not exist, create it on GitHub and re-run this script or use gh CLI."
