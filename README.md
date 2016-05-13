
# VCF to table maker

Description
------------

Run basic snpEff annotation on a variant call format  VCF file and then convert this output to a wide table

Requirements
--------------------

* snpEff 
* R (> 3.1.2)
* R data.table
* R stringr


Usage
-------

Once you have a snpEff database e.g. hg19, run the pipeline as below

```
vcf_shortAnnotationTable.sh   snpeff_db input.vcf.gz output

```


