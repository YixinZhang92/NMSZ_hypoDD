#!/bin/sh

# Give the directory
#data directory
#dir="./Phase"
#echo $dir
#cd $dir
#output files directory relative to each year's data directory
#dir1="."

#pwd
# Get directories info
year_list=($(ls 20*))
#echo "${year_list[*]}"

# Loop to work on each year
len=${#year_list[@]}
echo $len
# touch all_data.phase
#cd ${year_list[$0]}/Loc





for ((i=0; i<$len; i++))
do  cat ${year_list[$i]} >> ../all_data.phase
    pwd

#    ls
#    ls > ../../$dir1/${year_list[$i]}.txt
#    cd ../
#    pwd
 done


