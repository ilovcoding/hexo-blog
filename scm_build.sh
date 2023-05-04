#!/bin/bash
set -e
npm install -g pnpm --force
pnpm install
rm -rf .deploy_git
pnpm run deploy
cd .deploy_git
git checkout -b main
cd ..
pnpm run deploy

