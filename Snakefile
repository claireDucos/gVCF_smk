import glob
import snakemake.utils

SAMPLES=[]

sample_id_list = glob.glob('/mnt/beegfs/scratch/bioinfo_core/B20018_NAHA_01/variant_calling/bam/*.bam')
for name in sample_id_list:
    SAMPLES.append(name.split('/')[8].split('.')[0])
print(SAMPLES)


include: "rules/haplotypecaller.smk"


rule all:
    input:
        test=expand(
            "/mnt/beegfs/scratch/bioinfo_core/B20018_NAHA_01/variant_calling/gVCF/{sample}.vcf.gz",
            sample=SAMPLES
        )
    message:
        "Finish"
