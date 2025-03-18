#!/bin/bash

GIT_AUTHOR_NAME="mBernathPiccolotto"
GIT_COMMITTER_NAME="mBernathPiccolotto"
GIT_AUTHOR_EMAIL="68627670+mBernathPiccolotto@users.noreply.github.com"
GIT_COMMITTER_EMAIL="68627670+mBernathPiccolotto@users.noreply.github.com"

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
  GIT_AUTHOR_NAME="$GIT_AUTHOR_NAME" GIT_AUTHOR_EMAIL="$GIT_AUTHOR_EMAIL" \
  GIT_COMMITTER_NAME="$GIT_COMMITTER_NAME" GIT_COMMITTER_EMAIL="$GIT_COMMITTER_EMAIL" \
  GIT_AUTHOR_DATE="$today 12:00:00" GIT_COMMITTER_DATE="$today 12:00:00" \
  git commit -m "Update Goodhart's Law"
done

git push origin master
