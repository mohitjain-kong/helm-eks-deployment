#!/bin/sh
dialog --title "DevOps settings" --backtitle "The used variables can be preset in your shell environment" --ok-label "Done" \
  --stdout --form "Credentials" 10 70 4 \
  "DEVOPS_USERNAME" 1 1 "$DEVOPS_USERNAME" 1 23 255 0 \
  "DEVOPS_PASSWORD" 2 1 "$DEVOPS_PASSWORD" 2 23 255 0 \
  "DEVOPS_GITHUB_USERNAME" 3 1 "$DEVOPS_GITHUB_USERNAME" 3 23 255 0 \
  "DEVOPS_GITHUB_TOKEN" 4 1 "$DEVOPS_GITHUB_TOKEN" 4 23 255 0 \
   > output.txt
export DEVOPS_USERNAME=$(cat output.txt | head -1)
export DEVOPS_PASSWORD=$(cat output.txt | head -2 | tail -1)
export DEVOPS_GITHUB_USERNAME=$(cat output.txt | head -3 | tail -1)
export DEVOPS_GITHUB_TOKEN=$(cat output.txt | head -4 | tail -1)
