
# make a new directory for the today or passed day
day_number=${1:-$(date +'%d')}
day=day_$day_number

if git rev-parse --verify $day
then
  git checkout $day
else
  git checkout master
  git pull
  git checkout -b $day
fi;

if [ -f lib/src/$day/$day.ex ]
then
  echo "already initialized, skipping"
else
  # copy templates
  mkdir lib/src/$day

  cp lib/template/puzzle_template.txt       lib/src/$day/$day.ex
  cp lib/template/puzzle_test_template.txt  lib/src/$day/$day.test.exs

  # replace placeholder day value with the actual day
  placeholder='__DAY__'
  sed -i -e "s/$placeholder/$day_number/g" lib/src/$day/$day.ex
  sed -i -e "s/$placeholder/$day_number/g" lib/src/$day/$day.test.exs
fi;