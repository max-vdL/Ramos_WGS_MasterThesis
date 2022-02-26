/* 
 * pipeline input parameters 
 */
params.input = "/groups/pavri/bioinfo/max/wgs/ramos_JG/Ramos_JG_d0_marked.bam"
params.reference = "/groups/pavri/bioinfo/max/wgs/ramos_JG/resource/Homo_sapiens_assembly38.fasta"
params.vcfs = ["/groups/pavri/bioinfo/max/wgs/ramos_JG/vcfs/dbsnp_146.hg38.vcf", "/groups/pavri/bioinfo/max/wgs/ramos_JG/vcfs/Mills_and_1000G_gold_standard.indels.hg38.vcf"]
params.outdir = "/groups/pavri/bioinfo/max/wgs/ramos_JG/tables"
params.intervals = "/groups/pavri/bioinfo/max/wgs/ramos_JG/resource/scattered_calling_intervals/**"

log.info """\
         GATK BQSR PIPELINE   
         ===================================
         Input		: ${params.input}
         Reference	: ${params.reference}
         outdir		: ${params.outdir}
         """
         .stripIndent()

Channel
	.fromPath(params.intervals)
	.into { interval_ch }


process baserecalibrator {
    publishDir params.outdir, mode:'copy'

    input:
    path interval from interval_ch

    output:
    file("recal_data_d0_*_test.table")

    shell:
    """
	gatk BaseRecalibrator \
		-R !{params.reference} \
		-I !{params.input} \
		--known-sites /groups/pavri/bioinfo/max/wgs/ramos_JG/vcfs/Mills_and_1000G_gold_standard.indels.hg38.vcf \
		--known-sites /groups/pavri/bioinfo/max/wgs/ramos_JG/vcfs/dbsnp_146.hg38.vcf \
		-L !{interval} \
		-O "recal_data_d0_!{interval}.table"
	"""  
//	intervalID=`echo "!{interval}" | sed 's/\\/groups\\/pavri\\/bioinfo\\/max\\/wgs\\/ramos_JG\\/resource\\/scattered_calling_intervals\\///g' | sed 's/\\/scattered.interval_list//g'`
}

/*
Channel
    .fromPath("/groups/pavri/bioinfo/max/wgs/ramos_JG/tables/recal_data_d0_temp_*_of_50.interval_list_test.table")
    .into { tables_ch }


process prep {
    tag 

    input:
    val filename from "/groups/pavri/bioinfo/max/wgs/ramos_JG/tables/recal_data_d0_temp_*_of_50.interval_list_test.table"

    output:
    val in into inputs_ch

    shell:
    """
    f(x) = {
        echo `' -I' + \$x`
    }
    for i in 
    """

}
// ADD THE GatherBQSRReports

process gather {
    tag 

    input:
    val filename from tables_ch

    output:


    shell:
    """
    for i in 
    """
}
*/