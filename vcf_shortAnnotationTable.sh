#!/bin/sh

#simple vcf annotation
#snpeff annotation
#output vcf
# requires java 1.7
#requires R data.table

#snpeff location
EFF="/home/vagrant/software/snpEff"
#snpeff db
EFFDB=$1
input=$2
OUTPUT=$3

if [ $# -lt 3 ];then
	echo need 3 args
	exit
fi

tmp=`mktemp -d -p .`
mkdir -p $tmp/input $tmp/ref

echo `date` Begin, temp dir is $tmp
echo "snpeff $EFF $EFFDB "
if [ ! -d $EFF ];then
	echo No $EFF snpeff location
	d=`find . -name snpEff.jar`
	EFF=`dirname $d`
	#echo $EFF
	exit
fi

SNPEFFOPTS="-onlyProtein -no-downstream  -no-intergenic  -no-intron -no-upstream -no-utr -chr -canon -noHgvs -classic -formatEff -sequenceOntology -noStats -t "

#Run SnpEff 
zcat $input | java -Xmx1g -jar $EFF/snpEff.jar eff -c $EFF/snpEff.config \
	$SNPEFFOPTS \
	 $EFFDB | perl $EFF/scripts/vcfEffOnePerLine.pl |bgzip -c > $tmp/input/inputvariants.vcf.gz 

./VCF_printAllTags.sh $tmp/input/inputvariants.vcf.gz > tmptable.txt

#Filter columns
Rscript -e 'library(data.table);dat=fread("tmptable.txt");dat=subset(dat,EFF !="." & EFF != "0" & !grepl("intergenic|intragen",EFF));dat$EFF=gsub("\\(","|",dat$EFF);write.table(dat,"output_table.txt",sep="\t",quote=F,row.names=F)'
Rscript -e 'library(stringr);library(data.table); dat=fread("output_table.txt"); dat1 <- data.frame(do.call(rbind, strsplit(as.vector(dat$EFF), split = "\\|"))); dat1=subset(dat1,select=c(1:12));names(dat1)=c("impact","Predicted_severity","Functional_Class","Codon_Change","variant_aa","Amino_Acid_length","gene","Transcript_BioType","Gene_Coding","Transcript_ID","Exon_Rank","Genotype");dat=cbind(dat1,dat);nn=tolower(names(dat));setnames(dat,nn);dat$eff=NULL;setnames(dat,"sample","sample_name");write.table(dat,"out2_tbl.txt",sep="\t",row.names=F,quote=F);'
rm tmptable.txt 
mv "out2_tbl.txt" $OUTPUT
echo "##################################"
echo `date` Finished $OUTPUT Output file made




