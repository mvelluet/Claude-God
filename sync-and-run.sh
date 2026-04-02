#!/bin/zsh
set -e

echo "==> Syncing main with upstream..."
git checkout main
git pull upstream main
git push origin main

echo "==> Rebasing my/features..."
git checkout my/features
git rebase main
git push origin my/features --force-with-lease

echo "==> Building..."
xcodegen generate
xcodebuild -scheme ClaudeGod -configuration Debug build 2>&1 | grep -E "error:|warning:|BUILD (SUCCEEDED|FAILED)"

echo "==> Relaunching Claude God..."
pkill -x "Claude God" 2>/dev/null || true
sleep 1
open "$(find ~/Library/Developer/Xcode/DerivedData/ClaudeGod-*/Build/Products/Debug -name 'Claude God.app' -maxdepth 1 | head -1)"

echo "==> Done."
