#!/bin/bash

# Navigate to the spidey_notes directory
cd /home/pradyun/Documents/Spidey_Notes

# Add all changes to git
git add .

# Commit changes with a message containing the current date and time
git commit -m "Automated commit on $(date)"

# Push changes to the remote repository
git push origin master
