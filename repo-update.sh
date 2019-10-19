#!/bin/bash
echo 'updating repo command'
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
echo 'repo update complete'

