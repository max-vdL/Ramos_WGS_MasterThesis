f() {
    echo " -I $1"
}

arr=(tables/recal_data_d0_temp_*_of_50.interval_list_test.table)
for i in "${!arr[@]}"
do
    arr[$i]=`f ${arr[$i]}`
done
echo ${arr[@]}

gatk GatherBQSRReports \
    ${arr[@]} \
    -O "recal_data_d0_combinded.table" \
    -verbosity DEBUG