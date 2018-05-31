import uuid
import os

#Align reads to the reference genome using HISAT2
rule hisat2_align:
	input:
		lambda wildcards: config["samples"][wildcards.sample]
	output:
		bam = "processed/{study}/hisat2/{sample}.bam",
		ss = "processed/{study}/hisat2_ss/{sample}.splice_sites.txt"
	params:
		local_tmp = "/tmp/a72094_" + uuid.uuid4().hex + "/"
	resources:
		mem = 8000
	threads: 8
	shell:
		"""
		module load samtools-1.6
		mkdir {params.local_tmp}
		rsync -aP --bwlimit=10000 {input[0]} {params.local_tmp}/{wildcards.sample}_1.fq.gz
		rsync -aP --bwlimit=10000 {input[1]} {params.local_tmp}/{wildcards.sample}_2.fq.gz
		hisat2 -p {threads} -x {config[hisat2_index]} {config[hisat2_flags]} --novel-splicesite-outfile {output.ss} -1 {params.local_tmp}/{wildcards.sample}_1.fq.gz -2 {params.local_tmp}/{wildcards.sample}_2.fq.gz | samtools view -Sb > {params.local_tmp}/{wildcards.sample}.bam
		samtools sort -m 1000M -o {params.local_tmp}/{wildcards.sample}.sorted.bam -O BAM --threads 6 {params.local_tmp}/{wildcards.sample}.bam
		rsync -aP --bwlimit=10000 {params.local_tmp}/{wildcards.sample}.sorted.bam {output.bam}
		rm -r {params.local_tmp}
		"""

#Sort bam files by name and quantify gene expression using featureCounts
rule quantify_featureCounts:
	input:
		bam = "processed/{study}/hisat2/{sample}.bam"
	output:
		counts = "processed/{study}/featureCounts/{sample}.featureCounts.txt",
		summary = "processed/{study}/featureCounts/{sample}.featureCounts.txt.summary"
	params:
		local_tmp = "/tmp/a72094_" + uuid.uuid4().hex + "/"
	threads: 6
	resources:
		mem = 8000
	run:
		shell("mkdir {params.local_tmp}")
		shell("rsync -aP --bwlimit=10000 {input.bam} {params.local_tmp}/{wildcards.sample}.bam")
		shell("module load samtools-1.6 && samtools sort -n -m 1000M -o {params.local_tmp}/{wildcards.sample}.sorted.bam -O BAM --threads 5 {params.local_tmp}/{wildcards.sample}.bam")
		if(config["strandedness"] == "Stranded"):
			shell("featureCounts -s2 -p -C -D 5000 -d 50 --donotsort -a {config[ensembl_gtf]} -o {output.counts} {params.local_tmp}/{wildcards.sample}.sorted.bam")
		else:
			shell("featureCounts -s0 -p -C -D 5000 -d 50 --donotsort -a {config[ensembl_gtf]} -o {output.counts} {params.local_tmp}/{wildcards.sample}.sorted.bam")
		shell("rm -r {params.local_tmp}")
		
#Make sure that all final output files get created
rule make_all:
	input:
		#expand("processed/{study}/verifyBamID/{sample}.verifyBamID.bestSM", study = config["study"], sample=config["samples"]),
		#expand("processed/{study}/bigwig/{sample}.str1.bw", study = config["study"], sample=config["samples"]),
		expand("processed/{{study}}/hisat2/{sample}.bam", sample=config["samples"]),
		expand("processed/{{study}}/featureCounts/{sample}.featureCounts.txt", sample=config["samples"]),
		#expand("processed/{study}/salmon/{annotation}/{sample}/quant.sf", study = config["study"], annotation=config["annotations"], sample=config["samples"]),
		#expand("processed/{study}/featureCounts/{sample}.featureCounts.txt", study = config["study"], sample=config["samples"]),
		#expand("processed/{study}/ASEcounts/{sample}.ASEcounts", study = config["study"], sample=config["samples"]),
		#expand("processed/{study}/matrices/{annotation}.salmon_txrevise.rds", study = config["study"], annotation=config["annotations"]),
		#"processed/{study}/leafcutter/leafcutter_perind.counts.gz"
	output:
		"processed/{study}/out.txt"
	resources:
		mem = 100
	threads: 1
	shell:
		"echo 'Done' > {output}"
