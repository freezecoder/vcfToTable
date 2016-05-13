
# VCF to table maker

Description
================

Many NGS variant analysis tasks require generation of variants in variant call format (VCF). These files are  large and inconsistently formatted. 
This package allows one to run basic snpEff annotation on a variant call format  VCF file and then convert this output to a wide table. One can use the output to load into a database system for quick lookup and filtering on different column names.

Input format
================
The input VCF files  *must* be compressed and indexed with tabix. To prepare raw VCF files that are not compressed or tabix-indexed, do:

```
#Make input files tabix compressed
bgzip file.vcf
tabix -p vcf file.vcf.gz
```


Requirements
=====================

A UNIX/Linux environment is ideal for running this pipeline. I've been running this on Mac OSX and Ubuntu OS. This is a command line program.

Clone/Download this repository and optionally add the folder location to your UNIX ${PATH}.

Bioinformatics tools
----------------------
* snpEff (>= version 4)
* tabix ( version 0.2.5 or higher).
* bcftools (Version: 1.3 (using htslib 1.3)  or higher) 

R libraries 
----------------------------
* R (> 3.1.2)
* R data.table i.e. 
* R stringr

installation of R packages can be done as following

```
install.packages(c("stringr","data.table"))
```

Usage
=========================

With snpEff Annotation
-------------------------------
Once you have a snpEff database e.g. hg19,  Set the $SNPEFF variable in the ```vcf_shortAnnotationTable.sh``` script to the snpEff installation on your system. A minimum memory requirement of ~2G RAM is recommended to run this pipeline.

.Run the pipeline as below

```
vcf_shortAnnotationTable.sh   snpeff_db input.vcf.gz output

```

Without Annotation
---------------------------

If you're simply trying to convert an annotated VCF file without wanting to run snpEff then you may do the following

```
VCF_printAllTags.sh inputvariants.vcf.gz > output.tsv
```
Each INFO field in the VCF will be printed.








