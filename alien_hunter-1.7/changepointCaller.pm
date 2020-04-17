=head1 NAME

changepointCaller

=head1 SYNOPSIS

changepointCaller - it calls the PAI_scripts::changePoint

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

use FindBin;
use lib $FindBin::Bin;

package changepointCaller;
use PAI_scripts::changePoint;
use Exporter;
@ISA = ("Exporter");
@EXPORT = qw (&changepointCaller);

	sub changepointCaller{

	$SeqFile=$_[0];
	$tabFile=$_[1];
	$Genlen=readGenomeSeq($SeqFile);
	
	open file1, $tabFile
	or die "dead";

	open file2, ">$tabFile.opt"
	or die "dead";

	open file3, ">$tabFile.opt.plot"
	or die "dead";

	$count=`grep -c misc_feature $tabFile`;
	$st=1;	
	$to_prev=0;

	while(<file1>){  								
	chomp($_);
	
		if (m#(\d+)\.\.(\d+)#){
			$left=$1;
			$right=$2;
			$c++;
			print "\n optimizing prediction $c out of $count\n";
		
			#it calls changepoint	
			($newLeft,$newRight)=changepoint($left,$right,$tabFile);
			print " opt boundaries: $newLeft..$newRight\n";
			
			$from=$newLeft;
			$to=$newRight;
			
			#if overlap after the HMM optimization of two consequtive regions
			#then re-update the plot file not to print extra bases
			if($to_prev>=$from){
			$from=$to_prev+1;
			$newLeft=$to_prev+1;
			}
			$to_prev=$to;
		}
				
		if (m#(colour=\d+ \d+ \d+)#){
		$colour=$1;
		}
		if (m#(note=.+)#){
		$note=$1;
		}
		if (m#score=(\d+\.*\d+)#){
		$score=$1;
		
print file2 "FT   misc_feature    $newLeft..$newRight
FT                   /$colour
FT                   /algorithm=\"alien_hunter\"
FT                   /$note
FT                   /score=$score\n";
			
			#begin -> from
			for($i=$st;$i<$from;$i++){
			print file3 "0\n";
			}
			#from -> to
			for($i=$from;$i<=$to;$i++){
			print file3 "$score\n";
			}
			$st=$to+1;
		
		}
		
	}#while
	
		#to -> end		
		for($i=$st;$i<=$Genlen;$i++){
		print file3 "0\n";
		}
	
	close file1;
	close file2;
	close file3;
		
	return (); 

	}
	1;
