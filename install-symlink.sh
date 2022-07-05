#!/usr/bin/env bash

cd ..
repo_path=$(realpath tfmanager/)
ln -sf "$repo_path/tfmanager" "$HOME/.bin/tfmanager"
ln -sf "$repo_path/tgmanager" "$HOME/.bin/tgmanager"
