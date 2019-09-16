#n=$(wc -l < ../genLoc/clusterList.txt)
#echo "number of files: $n"
#
#for i in $n

#sed 's/   0.5      120     9     3     8      1     100/   0.5      120     9     3     8      1     100/' ph2dt.inp

# Get all target files
file_phase_list=($(ls ../File/*.phase))
#echo "${file_list[*]}"
file_ccr_list=($(ls ../File/*.ccr))

# Loop to work on each SVD file
len=${#file_phase_list[@]}
#echo $len




for ((i=1; i<$len; i++))
do  filename=$(basename ${file_phase_list[$i]} .phase)
    hypoLoc=${filename}.loc
    hypoReloc=${filename}.reloc
    hypoSta=${filename}.sta
    hypoRes=${filename}.res
    hypoSrc=${filename}.src
    sed -i .bak -e "5s|.*|${file_phase_list[$i]}|g" ph2dt.inp
    ../../../HYPODD/src/ph2dt/ph2dt ph2dt.inp
    sed -i .bak -e "4s|.*|${file_ccr_list[$i]}|g" hypoDD.inp
    sed -i .bak -e "17s|.*|$hypoLoc|g" hypoDD.inp
    sed -i .bak -e "19s|.*|$hypoReloc|g" hypoDD.inp
    sed -i .bak -e "21s|.*|$hypoSta|g" hypoDD.inp
    sed -i .bak -e "23s|.*|$hypoRes|g" hypoDD.inp
    sed -i .bak -e "25s|.*|$hypoSrc|g" hypoDD.inp
    sed -i .bak -e "32s|.*|    2     3     400|g" hypoDD.inp
    sed -i .bak -e "45s|.*|    2        1      2 |g" hypoDD.inp
    ../../../HYPODD/src/hypoDD/hypoDD hypoDD.inp 
done





