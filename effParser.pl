
use Data::Dumper;
#ANN snpeff parser 

#Finds the "EFF" column in file and expands it

my $rand=int(rand(3224323));
my $tmpfile=$rand.".tmpf.txt";
my $inx=1;
my $head="";
open(OUT,"+>$tmpfile") or die "$!";
while(<>) {
	chomp;
	my @F=split(/\t/,$_);
	if ($.==1) {
	#Find the annotation inde
		my $i=0;
		@hd=@F;
		foreach $k (@F) {
		if ($k=~/EFF/) {
			$inx=$i;
		}			
		$i++;
	}}else {
		$string=$F[$inx];
		#print $string,"\n";
        	foreach $s (split(",",$string)) {
			my $str="";   
	 		my $eff= parseEff($s);
			next unless $eff->{Type};
			next if $eff->{Type} =~ /intergenic_region/;
             		next unless $eff->{Type}=~/frame|splice|nonsens|missense|synon|stop|utr|nonse|non_syn/i;
			next unless $eff->{Gene_Name};
			next unless $eff->{Functional_Class};
			delete $eff->{WARNINGS};
			delete $eff->{ERRORS};
			#print Dumper($eff);
			$head=join"\t",sort {$a cmp $b} keys %$eff;
			foreach $k (sort {$a cmp $b} keys %$eff) {
				$str.=sprintf("%s\t",$eff->{$k});
			}
			printf OUT "$str%s\n",join("\t",@F);
			undef $eff;
		}
	}

}
close OUT;

printf "$head\t%s\n",join"\t",@hd;
open(IN,$tmpfile) or die "$!";
while(<IN>) {
	print;
}
unlink $tmpfile;


sub parseEff {
	my %h=();
	my $str=shift;
	$str=~s/\(/\t/;
	$str=~s/\)//;
    $h{Exon_Rank}=".";
	$h{Gene_Name}=".";
     $h{Transcript_ID}=".";
	my($type,$istr)=("","");
	($type,$istr)=split(/\t/,$str);
	#print $istr,"\n";
	my @eff= split(/\|/,$istr);
	$h{Amino_Acid_Change}="-";
    	$h{Type}=$type;
	$h{Effect_Impact}=$eff[0];
	$h{Functional_Class}=$eff[1];
	$h{Codon_Change}=$eff[2];
	$h{Amino_Acid_Change}=$eff[3];
	$h{Amino_Acid_length}=$eff[4];
	$h{Gene_Name}=$eff[5];
	$h{Transcript_BioType}=$eff[6];
	$h{Gene_Coding}=$eff[7];
	$h{Transcript_ID}=$eff[8];
	$h{Exon_Rank}=$eff[9];
	$h{Genotype_Number}=$eff[10];
	$h{ERRORS}=$eff[11];
	$h{WARNINGS}=$eff[12];
    #replace syn change with full AA#AA format
    $aac = $eff[3];
    $aac=~s/\d+//;
    if ($type=~/synonymous_|frame/) {
         #$h{Amino_Acid_Change}=$eff[3].$aac;    
    }

	return \%h;
}
