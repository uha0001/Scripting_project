=head1 NAME

PAI_scripts::overlap

=head1 SYNOPSIS

merges predictions

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

package PAI_scripts::overlap;
use Exporter;
@ISA = ("Exporter");
@EXPORT = qw (&overlap);

 
	sub overlap{
		$cutoff=$_[0];
		$scoresRef=$_[1];
		$prevFrom=0;
		$prevTo=0;
		$check=0;
		%joinedScores;
		$b=0;
		$bb=0;
		$count=0;
		
			#if cutoff = 0 don't join at all - return them as they are		
			if($cutoff==0){
				
				foreach $z ($scoresRef){
					foreach $key (keys %$z){
					$joinedScores{$key}="$z->{$key}";
					}
				}
			}
			else{
	
				foreach $z ($scoresRef){
					foreach $key (keys %$z){
				 	$scores{$key}="$z->{$key}";
				 	}
				}
			
				@keys2 = sort {$a <=> $b} keys %scores;		
			
				$numkeys= keys %scores;		
		
				for($i=0;$i<=$numkeys-1;$i++){
			
					if($scores{$keys2[$i]}>=$cutoff){
					$aboveCut[$b]=$keys2[$i];
					$b++	
					}
			
				}
				
				#if there is only one window with score > T
				if($b==1){
				$joinedScores{$aboveCut[$b-1]}=$scores{$aboveCut[$b-1]};	
				}
			
				for($c=0;$c<=$b;$c++){
					
					($from,$to)=split /\.\./, $aboveCut[$c];	
		
					if(($prevTo>=$from) | ($prevTo==0)){
						if($c>0){
						$count++;
						$joinedScore+=$scores{$aboveCut[$c]};
						} 
							
					}	
					else{
						$check=1;
					}
				
					#that's for the last windows where there is no next window to make check=1
					if($c==$b){
	   					#because it's doing once more the loop		
						$count--; 						
						$check=1;	
					}
				
					if ($check==1){
						($fromF,$toF)=split /\.\./, $aboveCut[$c-1-$count];
						($fromL,$toL)=split /\.\./, $aboveCut[$c-1];
						#to add also the 1st win score
						$joinedScore+=$scores{$aboveCut[$c-1-$count]};		
						$average=$joinedScore/($count+1);
						$average=sprintf("%.3f",$average);
					
						#for the first window; there is no previous window
						if($c>0){						
						$joinedScores{"$fromF..$toL"}=$average;
						
						}
						$count=0;
						$check=0;
						$joinedScore=0; 	
					}	
				
							
					$prevFrom=$from;
					$prevTo=$to;
	
				}
			
			
			}#else
	
	return (\%joinedScores);		
			
	}
	1;
