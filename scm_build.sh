#!/bin/bash
set -e
npm install -g yarn --force
yarn install
rm -rf .deploy_git
yarn run deploy
cd .deploy_git
git checkout -b main
cd ..
yarn run deploy

