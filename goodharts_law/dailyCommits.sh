#!/bin/bash

today=$(date -I)  # Get today's date
day_of_week=$(date +%u)  # 1 = Monday, 7 = Sunday

# Determine whether to skip the day
if { [ $day_of_week -ge 6 ] && [ $((RANDOM % 10)) -lt 8 ]; } ||  # 80% skip on weekends
   { [ $day_of_week -lt 6 ] && [ $((RANDOM % 10)) -lt 2 ]; }; then  # 20% skip on weekdays
  echo "Skipping commits for $today"
  exit 0
fi

num_commits=$((RANDOM % 10 + 1))  # 1-10 commits
echo "Making $num_commits commits for $today"

for ((i=0; i<num_commits; i++)); do
  echo "Commit $i on $today" > file.txt  # Modify a file
  git add file.txt
  GIT_AUTHOR_DATE="$today 12:00:00" GIT_COMMITTER_DATE="$today 12:00:00" git commit -m "Commit #$i for $today"
done

git push origin main  # Change 'main' if using another branch
