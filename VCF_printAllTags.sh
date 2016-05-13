#!/bin/sh

#prints all INFO tags in a VCF file

#requires bcftools, tabix

if [ $# -lt 1  ];then
	echo "Usage: $0 file.vcf.gz "
	exit 
fi

file=$1

tmp="headers."`perl -e 'print int(rand(1000000000))'`".txt"

#index the file with tabix
if [ ! -e "$file.tbi" ];then
	tabix -f -p vcf $file
fi

zcat $file  |grep "^##INFO="  | perl -pe 's/,.+//;s/##INFO=\<ID=//' |sort -u | tr "\n" ","  > $tmp

perl -e  '$tags=shift;$file=shift;
open(IN,$tags) or die "$!";
while(<IN>) {
	chomp;s/,$//;
	@f=split(",",$_);
	$str= join"\\t%INFO/",@f; 
	$in="[%SAMPLE]\\t%CHROM\\t%POS\\t%REF\\t%ALT\\t%ID\\t%QUAL\\t%FILTER\\t%INFO/$str\\t[%DP\\t]\\n"; 
	$cmd= "bcftools query -H -f \"$in\" $file";
	system($cmd);
}
close IN;
' $tmp $file 2> error.txt | perl -lane 'if (/^#/){ s/SAMPLE\S+/SAMPLE/;s/\.\///g; s/# //;s/\[\d+\]//g;s/:/_/g;print}else { s/\t\.\t/\t0\t/g;print;}'  > $file.o

perl -e '$f=shift; open(IN,$f);while(<IN>){ if ($.==1) {print "FILENAME\t$_"; }else {$f=~s/\.o$//;print "$f\t$_";}}' $file.o

rm $tmp $file.o

