GIT_COMMITTER_NAME="mBernathPiccolotto"
GIT_AUTHOR_NAME="mBernathPiccolotto"
GIT_AUTHOR_EMAIL="68627670+mBernathPiccolotto@users.noreply.github.com"
GIT_COMMITTER_EMAIL="68627670+mBernathPiccolotto@users.noreply.github.com"


start_date="2024-03-17"  # Change this to your desired start date
end_date=$(date -I)       # Sets end date to today

while [ "$start_date" != "$end_date" ]; do
  day_of_week=$(date -d "$start_date" +%u)  # 1 = Monday, 7 = Sunday

  # Determine whether to skip the day
  if { [ $day_of_week -ge 6 ] && [ $((RANDOM % 10)) -lt 8 ]; } ||  # 80% skip on weekends
     { [ $day_of_week -lt 6 ] && [ $((RANDOM % 10)) -lt 2 ]; }; then  # 20% skip on weekdays
    echo "Skipping $start_date"
  else
    num_commits=$((RANDOM % 10 + 1))  # 1-10 commits
    echo "Making $num_commits commits on $start_date"

    for ((i=0; i<num_commits; i++)); do
      echo "Commit $i on $start_date" > file.txt  # Modify a file
      git add file.txt
      GIT_AUTHOR_NAME="$GIT_AUTHOR_NAME" GIT_AUTHOR_EMAIL="$GIT_AUTHOR_EMAIL" \
      GIT_COMMITTER_NAME="$GIT_COMMITTER_NAME" GIT_COMMITTER_EMAIL="$GIT_COMMITTER_EMAIL" \
      GIT_AUTHOR_DATE="$start_date 12:00:00" GIT_COMMITTER_DATE="$start_date 12:00:00" \
      git commit -m "Backdated commit #$i for $start_date"
    done
  fi

  # Increment the date
  start_date=$(date -I -d "$start_date + 1 day")
done

git push origin master
