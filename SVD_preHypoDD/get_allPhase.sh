#!/bin/sh

# Give the directory
#data directory
dir="."
echo $dir
#cd $dir
#output files directory relative to each year's data directory
dir1="."

# Get directories info
year_list=($(ls -d 20*))
#echo "${year_list[*]}"

# Loop to work on each year
len=${#year_list[@]}
echo $len
#cd ${year_list[$0]}/Loc
for ((i=0; i<$len; i++))
do  cd ${year_list[$i]}
    cat data.phase >> ../all_data.phase
#    ls
#    ls > ../../$dir1/${year_list[$i]}.txt
    cd ../
#    pwd
done


