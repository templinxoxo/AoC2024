
# make a new directory for the today or passed day
day=${1:-$(date +'%d')}
mkdir lib/src/day$day
# copy templates
cp lib/template/day_X.ex          lib/src/day$day/day_$day.ex
cp lib/template/day_X.test.exs    lib/src/day$day/day_$day.test.exs

# replace placeholder day value with the actual day
placeholder='__DAY__'
sed -i -e "s/$placeholder/$day/g" lib/src/day$day/day_$day.ex
sed -i -e "s/$placeholder/$day/g" lib/src/day$day/day_$day.test.exs