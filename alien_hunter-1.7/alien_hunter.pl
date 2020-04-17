#!/usr/local/bin/perl

=head1 NAME

alien_hunter.pl

=head1 SYNOPSIS

Prediction of Genomic Islands using Interpolated Variable Order Motifs (IVOMs)

=head1 AUTHOR

George Vernikos <gsv(at)sanger.ac.uk>

=head1 COPYRIGHT

=head1 BUGS

if you witness any bug please contact the author

=head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

=cut

use FindBin;
use lib $FindBin::Bin;
use POSIX qw(log10);
use Getopt::Long;
use PAI_scripts::help;
use PAI_scripts::MotifMaker;
use PAI_scripts::CutOff;
use PAI_scripts::overlap;
use PAI_scripts::rrna;

use changepointCaller;
use Time::Local;
use Time::HiRes qw (gettimeofday);

$once=0;
$WinSize=5000;
$Overlap=2500;


GetOptions("file_genome=s"=>\$SeqFile,"output=s"=>\$Output,"artemis"=>\$artemis,"help"=>\$help,"changePoint"=>\$changePoint);

	if($help|!$SeqFile|!$Output){
	help();
	goto END;	
	}

	open file1, $SeqFile
	or die "dead";

	print"\n reading sequence...\n";
	
	while(<file1>){  								
	chomp($_);
		if (m#>#){
		}
		else {
		$GenSeq.=$_;
		}
	}
	close file1;

	#runs rrna method in rrna.pm to find rrna operons
	rrna($GenSeq);
	
	$GenLen=length($GenSeq);
		
	if($GenLen<20000){
	print "\n$GenLen bp; too short sequence!\n\n";
	goto END;
	}
	
	#builds the motif vectors
	MMaker();
		
	#scans genome sequence for all kth order motifs
	print" scanning genome for motifs...\n";
	($amb_base,$count8merswithN)=scan($GenSeq,0);	
	
	if($amb_base==1){
	print "\n\nambiguous bases in the sequence!!!\n\n";
	
	#check percentage of total 8mers in the sequence that contain ambiquous bases (if > 30% stop) 
	$per8merswithN=$count8merswithN/($GenLen-8+1);
		if($per8merswithN > 0.3){
		print "\n\nmore than 30% of 8mers contain ambiguous bases -- cannot continue!!!\n\n";
		goto END;
		}
	}
		
	#builds the IVOM vectors
	print"\n building genome IVOM vectors...\n";
	$GenIVOMref=IvomBuild();	
	
		foreach $p ($GenIVOMref){
			foreach $key (keys %$p){
			$GenIVOM{$key}="$p->{$key}";
			}
		}
			
	print"\n sliding window running - calculate relative entropy (KL)...\n";
	
	#how many overlapping windows
	$HowMany=($GenLen/$Overlap)-1; 				
		
	$start=gettimeofday();
	
	for ($i=0;$i<=$HowMany-1;$i++){
	
		$from=$i*$WinSize-($i*$Overlap);
		$to=$from+$WinSize;
		
	#so as for the last window if != winsize, to take different 
	#start point to the end of the genome, but again with size=winsize
		if(($HowMany-1)-$i<=1){
		$to=$GenLen;
		$from=$GenLen-$WinSize;					
		}
	
		$Query=substr($GenSeq,$from,$to-$from);
		
	#scans each sliding window for all kth order motifs
		($amb_base,$count8merswithN)=scan($Query,1);
		#if the current sliding window contains at least 1 ambiguous base skip it and go to the next one
		if($amb_base==1){
		$counter++;	
		goto HERE;	
		}
	
	#builds the IVOM vectors for each sliding window
		$QueryIVOM=IvomBuild();
		$counter++;
		
	# to convert base 0.. into 1..
		if($i==0){					
		$from=1;	
		}
				
	#calculates relative entropy (Kullback-Leibler)
		foreach $k (keys %GenIVOM){
			
			$w=${$QueryIVOM}{$k};
			$G=$GenIVOM{$k};
			
			#print "$k $w $G\n";
			$Score+=($w*log10($w/$G));
					
		}
		
		$AllScores{"$from..$to"}=$Score;
	
			
	#keeps track of process completed			
		$PercentComplete=($counter/$HowMany)*100; 	
		$PercentComplete=sprintf("%.1f",$PercentComplete);

		if($PreviousValue ne $PercentComplete){
			print "completed ... $PercentComplete%\n";
		
			if($PercentComplete>=1){
			
				#calculating finish time
				if($once==0){
				$once=1;
				$dif=gettimeofday()-$start;
				$remain=$HowMany/$counter;
				$dif=$dif*$remain;
				$estimated=$start+$dif;
				print "\n\t\testimated finish time:\n\t\t";
				print scalar(localtime($estimated));
				print "\n\n";
				}
			
			}
		}
		$PreviousValue= $PercentComplete;
		
	HERE:
	$Score=0;	
	}#for how many
		
	print"\n determining score threshold...\n";
			
		($cutoff,$ScaledScores)= Cutoff(\%AllScores);
		$cutoff=sprintf("%.3f",$cutoff);

	########### to print all scores ##############
	open file4, ">$Output.sco"
	or die "dead";
	
	foreach $h ($ScaledScores){
		foreach $key (keys %$h){
		$temp_sc{$key}="$h->{$key}";
		}
	}

	foreach $k (keys %temp_sc){
	$v = $temp_sc{$k};
	print file4 "FT   misc_feature    $k\nFT                   /score=$v\n";
	}

	close file4;
	#############################################
	
	
	$NumKeys= keys %temp_sc;
	if($NumKeys<2){
		goto END;
	}
	

	print"\n merging predictions...\n";
	
		$joinedScoresRef=overlap($cutoff,$ScaledScores);
	
		foreach $h ($joinedScoresRef){
			foreach $key (keys %$h){
		 	$joinedScores{$key}="$h->{$key}";
			}
		}
	
	print"\n writing predictions in embl format...\n";
	
	#find the max joined_window score
			@keys = sort {					
			$joinedScores{$a} <=> $joinedScores{$b}		
			} keys %joinedScores;
			$NumKeys = keys %joinedScores;
			$max=$joinedScores{$keys[$NumKeys-1]};
	
	open file2, ">$Output"
	or die "dead";	

	if($cutoff>0){
	open file3, ">$Output.plot"
	or die "dead";
	}
	
	$st=1;
				
	#sorts the scores based on their keys (from..to) in order for the artemis 
	#plot to print the regions in the order they occur in the genome
	@keys = sort { 
	$a<=>$b
	}keys %joinedScores;
					
	foreach $k (@keys) {
	$res=0;
   	$v = $joinedScores{$k};
    	#all scores above the cutoff are coloured scaled: red->white (max->min)
		if($v>=$cutoff){					 
		$x=($v-$cutoff)/($max-$cutoff);
		$green=255-($x*255);
		$blue=255-($x*255);
		$green=sprintf("%.0f",$green);
		$blue=sprintf("%.0f",$blue);
		$red=255;	
		$color="$red $green $blue";
		#$label="Alien";	
		}

	#calls rrna.pm to annotate regions overlapping rrnas
	($rfrom,$rto)=split/\.\./,$k;
	$res=overlapRNA($rfrom,$rto);
	
	if($res==1){
print file2 "FT   misc_feature    $k
FT                   /colour=$color
FT                   /algorithm=\"alien_hunter\"
FT                   /note=\"threshold: $cutoff; probably region overlapping rRNA operon\"
FT                   /score=$v\n";
	}
	else{
print file2 "FT   misc_feature    $k
FT                   /colour=$color
FT                   /algorithm=\"alien_hunter\"
FT                   /note=\"threshold: $cutoff\"
FT                   /score=$v\n";
	}
		#writes scores for artemis plot
		#check if cutoff>0 else it doen's write plot
		if($cutoff>0){
						
			($from,$to)=split /\.\./, $k;
			#begin -> from
			for($i=$st;$i<$from;$i++){
			print file3 "0\n";
			}
			#from -> to
			for($i=$from;$i<=$to;$i++){
			print file3 "$v\n";
			}
			$st=$to+1;
			
		}
	
	}
	close file2;

	#to -> end
		if($cutoff>0){		
			for($i=$st;$i<=$GenLen;$i++){
			print file3 "0\n";
			}
			close file3;
			
	#optimizing the boundaries
			if($changePoint){
			print"\n optimizing predicted boundaries...\n\n";
			changepointCaller($SeqFile,$Output);
			$Output.=".opt";
			}
		}

	#calculate time elapsed
	$finish=gettimeofday();
	$diff=$finish-$start;
	$sec=$diff % 60;
	$diff=($diff-$sec) /60;
	$min=$diff % 60;
	$diff=($diff-$min) /60;
	$hours=$diff % 24;
	$diff=($diff-$hours) /24;
	print "\ntime elapsed: $hours:$min:$sec\n";	
	
	#it runs artemis; if also -c then it will load the optimized predictions
	if($artemis){ 					
	print"\n loading predictions into artemis ...\n\n\n";
	exec "art $SeqFile + $Output";
	}
	
#end of code
END: 
