"""
Variant Caller using Haplotype Caller from Gatk : create gVCF file
https://gatk.broadinstitute.org/hc/en-us/articles/360035531412-HaplotypeCaller-in-a-nutshell
"""
rule haplotypeCaller_calling:
    input:
        ref = "/mnt/beegfs/database/bioinfo/Index_DB/Fasta/Ensembl/GRCh38.99/GRCh38.99.homo_sapiens.dna.fasta",
        bam = "/mnt/beegfs/scratch/bioinfo_core/B20018_NAHA_01/variant_calling/bam/{sample}.bam",
        dict = "/mnt/beegfs/database/bioinfo/Index_DB/Fasta/Ensembl/GRCh38.99/GRCh38.99.homo_sapiens.dna.dict",
        fai = "/mnt/beegfs/database/bioinfo/Index_DB/Fasta/Ensembl/GRCh38.99/GRCh38.99.homo_sapiens.dna.fasta.fai",
        dbsnp = "/mnt/beegfs/database/bioinfo/Index_DB/dbSNP/GRCh38p7/All_20180418.nochr.vcf.gz",
        bed = "/mnt/beegfs/scratch/bioinfo_core/B20018_NAHA_01/variant_calling/bed_files/Covered.bed "
    output:
        vcf = "/mnt/beegfs/scratch/bioinfo_core/B20018_NAHA_01/variant_calling/gVCF/{sample}.vcf.gz"
    message:
        "Calling variants with Haplotype Caller on {wildcards.sample} (create gVCF file)"
    threads:
        4
    resources:
        mem_mb = (
            lambda wildcards, attempt: min(attempt * 8192, 16384)
        ),
        time_min = (
            lambda wildcards, attempt: min(attempt * 128, 512)
        )
    log:
        "/mnt/beegfs/scratch/bioinfo_core/B20018_NAHA_01/variant_calling/logs/{sample}.log"
    shell:
        """gatk --java-options "-Xmx8G" HaplotypeCaller -R {input.ref} -I {input.bam} -O {output.vcf} -D {input.dbsnp} -L {input.bed} --sequence-dictionary {input.dict} -ERC BP_RESOLUTION --interval-padding 100 2> {log} """
