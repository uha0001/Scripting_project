=head1 NAME

PAI_scripts::CutOff

=head1 SYNOPSIS

determines dynamically a genome-specific score threshold using k-means clustering (k=3)

=head1 AUTHOR

George Vernikos <gsv(at)sanger.ac.uk>


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

package PAI_scripts::CutOff;
use Exporter;
@ISA = ("Exporter");
@EXPORT = qw (&Cutoff);


	sub Cutoff{
		$ScoresRef=$_[0];
		$min=0;
		%ALLscores;
		%scores;
		$cutoff=0;
		$Func_prev=0;
		$Func_max=0;

		foreach $z ($ScoresRef){
			foreach $key (keys %$z){
			$ALLscores{$key}="$z->{$key}";
			}
		}
		
		

		  					
		#@keys contains the keys sorted by their value (min->max)
		@keys = sort {
		$ALLscores{$a} <=> $ALLscores{$b}
		} keys %ALLscores; 	

				
		

		$NumKeys = keys %ALLscores; 

      		if($NumKeys<2){
		print "\n not enough data ($NumKeys) to determine threshold; T=0\n";	
		goto end;
		}
	    
	    	
		#minimum value
		$min=$ALLscores{$keys[0]};
		
		print "\n scaling 0-100\n";		
		#it scales to zero
		foreach $item (@keys){
		$ALLscores{$item}=$ALLscores{$item}-$min;
		}	
		#maximum value	
		$max=$ALLscores{$keys[$NumKeys-1]}; 			
			
		#it scales to maximum: Sx'=(Sx*100)/Smax
		foreach $item (@keys){
		$scores{$item}=sprintf("%.3f",($ALLscores{$item}*100)/$max);
		$ALLscores{$item}=sprintf("%.3f",($ALLscores{$item}*100)/$max);
		}

	
		
		#@keys contains the keys sorted by their value (max->min)
		@keys = sort {
		$scores{$b} <=> $scores{$a}
		} keys %scores; 					
	   	  
			

		#Exponential Smoothing (Damping factor = 0.5)
		print "\n Exponential Smoothing (Damping factor = 0.5)\n\n";
		for($i=1;$i<=$NumKeys-1;$i++){
		$scores{$keys[$i]}=0.5*$scores{$keys[$i]}+0.5*$scores{$keys[$i-1]};
		#print "$scores{$keys[$i]}\n";		
		}


		#@keys contains the keys sorted by their value (min->max)
		@keys = sort {
		$scores{$a} <=> $scores{$b}
		} keys %scores; 


		#for($i=0;$i<=$NumKeys-1;$i++){
		#print "$scores{$keys[$i]}\n";

		#}		
	
	############################################################

	
	#check if not enough data for k-means
	if($NumKeys>=300){
	print " K-means Clustering:\n\nFunc_max\tCutoff\tCntrA\t\tCntrB\t\tCntrC\n";
	
	#initialize the 3 centroids and redo - keeping the iteration with the maximum obj function, i.e. that seperates the 3 clusters the most
	for($j=10;$j<=40;$j+=10){
	
	for($k=0;$k<=(100-$j*2);$k+=10){
	$a=$k;
	$b=$k+$j;
	$c=$k+($j*2);


	
	
	#calculate distances of each Xi to each of the 3 centroids |Xi-Cj|^2
	REDO:
	for($i=0;$i<$NumKeys;$i++){
	$dist_a{$i}=($scores{$keys[$i]}-$a)*($scores{$keys[$i]}-$a);
	$dist_b{$i}=($scores{$keys[$i]}-$b)*($scores{$keys[$i]}-$b);
	$dist_c{$i}=($scores{$keys[$i]}-$c)*($scores{$keys[$i]}-$c);
	
	#calculates the objective function sum_j(sum_i(|Xi-Cj|^2))
	$f+=$dist_a{$i}+$dist_b{$i}+$dist_c{$i};
	}
	$Func=$f;
	$f=0;
	
	#scan through each hash to find where the transition to the other cluster occurs
	for($i=0;$i<$NumKeys;$i++){
		if($dist_a{$i}<=$dist_b{$i}){
		$trans_a=$i;
		}
		if($dist_b{$i}<=$dist_c{$i}){
		$trans_b=$i;
		}
	}
	#sets cutoff to the score value where the transition from cluster 1 -> 2 occurs
	$cutoff=$scores{$keys[$trans_a+1]};
	
	#recalculates mean for each cluster
	#cluster a
	$count=0;
	$sum=0;
	for($i=0;$i<=$trans_a;$i++){
	$count++;
	$sum+=$scores{$keys[$i]};
	}
	if($count!=0){
	$mean_a=$sum/$count;
	}
	else{
	$mean_a=0;
	}
	#cluster b
	$count=0;
	$sum=0;
	for($i=$trans_a+1;$i<=$trans_b;$i++){
	$count++;
	$sum+=$scores{$keys[$i]};
	}
	if($count!=0){
	$mean_b=$sum/$count;
	}
	else{
	$mean_b=0;
	}
	#cluster c
	$count=0;
	$sum=0;
	for($i=$trans_b+1;$i<$NumKeys;$i++){
	$count++;
	$sum+=$scores{$keys[$i]};
	}
	if($count!=0){
	$mean_c=$sum/$count;
	}
	else{
	$mean_c=0;
	}

	#convergence criteria
	$dif=abs($Func-$Func_prev);
	if($dif>0.1){
	$Func_prev=$Func;
	#re-initialize the centroids
	$a=$mean_a;
	$b=$mean_b;
	$c=$mean_c;
	
	#print "$Func\t$cutoff\t$a\t$b\t$c\n";
	
	#re-iterate with the new centroids
	goto REDO;
	}
	#keep the iteration with the highest objective function
	if($Func>$Func_max){
	$Func_max=$Func;
	$cutoff_best=$cutoff;
	$Fmax=sprintf("%.3f",$Func_max);
	$mA=sprintf("%.3f",$mean_a);
	$mB=sprintf("%.3f",$mean_b);
	$mC=sprintf("%.3f",$mean_c);
	$cutbest=sprintf("%.3f",$cutoff_best);
	print "$Fmax\t$cutbest\t$mA\t\t$mB\t\t$mC\n";
	}

	
	}
	}
	$cutoff_best=sprintf("%.3f",$cutoff_best);
	

	}
	#if not enough data - simple statistics
	else{
	$count=0;
	$average=0;
	$sum=0;
	foreach $k (keys %ALLscores){
	$sum+=$ALLscores{$k};
	$count++;	
	}
	$average=$sum/$count;
	
	foreach $k (keys %ALLscores){
	$sco=$ALLscores{$k}-$average;
	$scoSqr=$sco**2;
	$sumSqr+=$scoSqr;
	}
	
	$STANDEV=sqrt($sumSqr/($count-1));
	$STANDEV*=0.5;
	$cutoff_best=sprintf("%.3f",$average+$STANDEV);
	
	print "\n too little data to determine dynamically T;\n\n T=$cutoff_best(=average+0.5SD)\n";	
	goto end;
	}
	###############################################################
	
	end:		
	return ($cutoff_best,\%ALLscores);

	}
	1;
