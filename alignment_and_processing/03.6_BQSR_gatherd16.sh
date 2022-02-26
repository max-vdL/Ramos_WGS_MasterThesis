f() {
    echo " -I $1"
}

arr=(tables/recal_data_d16_temp_*_of_50.interval_list.table)
for i in "${!arr[@]}"
do
    arr[$i]=`f ${arr[$i]}`
done
echo ${arr[@]}

gatk GatherBQSRReports \
    ${arr[@]} \
    -O "tables/recal_data_d16_combinded.table" \
    -verbosity DEBUG