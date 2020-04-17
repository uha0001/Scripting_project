=head1 NAME

PAI_scripts::changePoint

=head1 SYNOPSIS

runs a 2 state 2nd order HMM on the boundaries of each prediction

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

package PAI_scripts::changePoint;
use Exporter;
@ISA = ("Exporter");
@EXPORT = qw (&changepoint &readGenomeSeq);


	sub readGenomeSeq{
	
		$SeqFile=$_[0];
		
		open file1, $SeqFile
		or die "dead";
	
		while(<file1>){  								
			chomp($_);
			if (m#>#){
			}
			else {
			$GenSeq.=$_;
			}
		}
	
		$Genlen=length($GenSeq);
		close file1;
	
	return ($Genlen);
	}
	1;

	sub changepoint{

		$left=$_[0];
		$right=$_[1];
		$tabfile=$_[2];
	
		$len=$right-$left;
		 
		#size check: if 5 or 7.5 or 10 or 12.5 kb use different size for the hybrid
		if($len==5000){
		$from=2000;
		$to=6000;
		$step=2000;
		$h_s=5000;
		$h_e=2000;
		}
		
		elsif($len==7500){
		$from=2000;
		$to=6000;
		$step=2000;
		$h_s=5000;
		$h_e=3000;
		}
		
		elsif($len==10000){
		$from=2000;
		$to=6000;
		$step=2000;
		$h_s=5000;
		$h_e=4000;
		}
		
		elsif($len==12500){
		$from=2000;
		$to=8000;
		$step=2000;
		$h_s=5000;
		$h_e=5000;
		}
		
		elsif($len>12500){
		$from=2000;
		$to=8000;
		$step=2000;
		$h_s=5000;
		$h_e=6000;
		}
		
		$size=$h_s+$h_e;
		#check if not too close to the boundaries
		if(($left>=2500) & ($right<=$Genlen-5000)){
		
		#-2500
		$Leftchunk=substr($GenSeq,$left-$h_s,$size);
		#-5000 
		$Rightchunk=substr($GenSeq,$right-$h_e,$size);
					
		#RightChunk
		open file3, ">$tabfile.hmmR"   
		or die "dead";
		
		print file3 ">seq\n$Rightchunk";
		close file3;
		
		#LeftChunk
		open file4, ">$tabfile.hmmL" 
		or die "dead";
		
		print file4 ">seq\n$Leftchunk";
		close file4;
		$max=0;
		
		for($i=$from;$i<=$to;$i+=$step){
			print $i."bp\n";
			
			###############################################
			
			$pid1 = open(LEFT, "java ChangepointLeft $tabfile.hmmL 3 1 0 $i |")  or die "Couldn't fork: $!\n";
			print "running HMM on left boundary..\n";
			
			$pid2 = open(RIGHT, "java ChangepointRight $tabfile.hmmR 3 1 0 $i |") or die "Couldn't fork: $!\n";
			print "running HMM on right boundary..\n";
			
			while (<LEFT>) {
			    $outLeft{$i}= $_;
			}
			close(LEFT);
			
			while (<RIGHT>) {
			    $outRight{$i}= $_;
			}
			close(RIGHT);
			
			print "$out1\n$out2";
			
			##############################################
			
			#parses transition point and path score for each iteration
			($location_L, $score_L)=split / /,$outLeft{$i};
			$score_L=abs($score_L);
			
			($location_R, $score_R)=split / /,$outRight{$i};
			$score_R=abs($score_R);
						
			#only once
			if($i==$from){
			$max_R=$score_R;
			$max_L=$score_L;
			$transPos_R=$location_R;
			$transPos_L=$location_L;
			$duration=$i;	
			}
			
			#keeps the highest scoring path	
			if($score_L lt $max_L){
			$max_L=$score_L;
			$transPos_L=$location_L;
			$duration=$i;	
			}
			
			if($score_R lt $max_R){
			$max_R=$score_R;
			$transPos_R=$location_R;
			$duration=$i;	
			}
			
		}
			
			$new_right=$right-$h_e+$transPos_R;
			$new_left=$left-$h_s+$transPos_L;
		
			$a=$left-2500;
			$b=$left+5000;
				
		}#if check
	
		#else if prediction is very close to the genome ends then don't optimize, just return it as it is
		else{
		$new_left=$left;
		$new_right=$right;
		}	
	
	#deletes the temp files	
	unlink "$tabfile.hmmL", "$tabfile.hmmR";
	
	return ($new_left,$new_right);

	}
	1;
	
