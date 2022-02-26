README

Alignment & Preprocessing
=========================
Generation of analysis-ready reads was performed according to the gatk best practices for whole genome sequencing data. The timeline can be follwed by the index of the command files.
Any action needing samtools or gatk was performed with the `mySamtools.yml` environment. 
The reference genome for alignment and the intervals for BQSR were pulled from the gatk resource bucket [link] https://console.cloud.google.com/storage/browser/genomics-public-data/resources/broad/hg38/v0;tab=objects?pli=1&prefix=&forceOnObjectsSortingFiltering=false
For regional alignments of MutPE data on the BCL6 and IgH locus custom chromosomes were made. They can be found in `alt_ref_genomes`.

Mutation callers
================

SomaticSeq
----------
The SSeq pipeline here was adapted from [link] https://github.com/ObenaufLab/snv-calling-nf which in turn uses [link] https://github.com/bioinform/somaticseq.
The Nextflow pipeline was run with the `mySomaticSeq.yml` environment. The singularity images were unfortunaltely too large to be included here, but the versions of the tools that were run are always described in the names of the images:
lofreq:2.1.3.1-1
samtools:1.7
gatk:4.0.5.2
scalpel:0.5.4
somaticsniper:1.0.5.0-2
bedtools:2.26.0
strelka:2.9.5
tabix:1.7
vardictjava:1.5.2
While the initial structure of the `.cmd` scripts was automatically generated by calling the snv-calling-nf script, many adaptations had to be made so that the tools ran successfully.

Varscan2
--------
Varscan2 was run with the `varscan somatic` function. This required pileup files. They were genereated with samtools in the `makePileUp.sh` scripts.
The vcf files generated by varscan vary slightly from the standard expected by downstream tools. The `varscan_basename_table_cleanup.R` script fixes this.

NeuSomatic
----------
NeuSomatic was adapted from [link] https://github.com/bioinform/neusomatic . An ensemble caller was already in use with SomaticSeq, so only the standalone function of NeuSomatic was used here. 
The `neusomatic_latest.sif` singularity image can also be found at the linked repository. 

Pileup analysis
===============
![Image](pilup_workflow.png) 