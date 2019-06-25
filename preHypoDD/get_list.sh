#!/bin/sh

# Give the directory
#data directory
dir="/Volumes/Untitled/Data"
echo $dir
cd $dir
#output files directory relative to each year's data directory
dir1="/Users/yixinzhang/Desktop/test_HYPODD/Event_list"

# Get directories info
year_list=($(ls -d 20*))
echo "${year_list[*]}"  

# Loop to work on each year
len=${#year_list[@]}
echo $len
#cd ${year_list[$0]}/Loc
for ((i=0; i<$len; i++))
do  cd $dir/${year_list[$i]}/Loc
#    ls
    echo "$dir/${year_list[$i]}/Loc"
    ls -d 20* > $dir1/${year_list[$i]}.txt
    cd $dir
#    pwd
done
cd $dir1
pwd

