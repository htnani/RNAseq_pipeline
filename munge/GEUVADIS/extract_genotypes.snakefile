CHROMS = ["1","10","11","12","13","14","15","16","17","18","19","2","20","21","22","3","4","5","6","7","8","9","X","Y"]

rule make_all:
    input:
        expand("/gpfs/hpchome/a72094/rocket/projects/GEUVADIS/genotypes/GEUVADIS_445_samples.chr{chromosome}.vcf.gz", chromosome = CHROMS)
    output:
        "out.txt"
    threads: 1
    resources:
        mem = 1000
    shell:
        "echo 'Done! > {output}' 
        
rule extract_genotypes:
    input:
        vcf = expand("/gpfs/hpchome/a72094/rocket/datasets/1000G/GRCh38/ALL.chr{chromosome}_GRCh38.genotypes.20170504.vcf.gz", chromosome = CHROMS),
        samples = "../../../projects/GEUVADIS/RNAseq_pipeline/metadata/GEUVADIS/GEUVADIS_genotype_list.txt"
    output:
        vcf = "/gpfs/hpchome/a72094/rocket/projects/GEUVADIS/genotypes/GEUVADIS_445_samples.chr{chromosome}.vcf.gz"
    threads: 1
    resources:
        mem = 3000
    shell:
        "bcftools view -S {input.samples}  --force-samples {input.vcf} | bcftools filter -i 'MAF[0] >= 0.05' -O z - > {output.vcf}"
