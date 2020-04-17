=head1 NAME

PAI_scripts::rrna

=head1 SYNOPSIS

Annotates alien_hunter predictions that overlap with a 16s 102bp rRNA motif;
This motif comes from a consensus of 16s rRNA alignment from:

Ecoli		223771:225312 forward
Mycobacterium	1341144:1342692 forward
Neisseria	198339:199883 reverse
Pseudomonas	722096:723631 forward
Rhizobium	2750005:2751465 reverse
Ricketsia	772263:773769 reverse
Salmonella	287479:289020 forward
Staph		514251:515805 forward
Streptococcus	17043:18549 forward
Thermotoga	188968:190526 forward
Vibrio		53823:55357 forward
Bacillus	9809:11361 forward
Chlamydia	856874:858423 forward
Clostridium 	8715:10223 reverse
Corynebacterium	76643:78166 forward
Campylobacter	39249:40761 forward
Mycoplasma	170007:171525 forward

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


package PAI_scripts::rrna;
use Exporter;
@ISA = ("Exporter");
@EXPORT = qw (&rrna &overlapRNA);
	
sub rrna{
	
	$GenSeq=$_[0];
	$GenSeq=uc($GenSeq);
	
	
	#forward strand:
	$_=$GenSeq;
 	while(/(ACA..GG.ACTGAGA.AC.G.CC..ACTC.{0,1}TACGGGAGGC.GCAGT.G.GAAT.TT...CAATG...G.AA...TGA...AGC.A..CCG.GTG...GA.GA)/g){
	$to=pos($_);
	
	$len=length($1);
	$from=$to-$len+1;
	$loc{$from}=$to;
	print " possible rRNA signature: $from..$to\n";		
	}
	
	#reverse strand:
	$_=$GenSeq;
 	while(/(TC.TC...CAC.CGG..T.GCT...TCA...TT.C...CATTG...AA.ATTC.C.ACTGC.GCCTCCCGTA.{0,1}GAGT..GG.C.GT.TCTCAGT.CC..TGT)/g){
	$to=pos($_);
	
	$len=length($1);
	$from=$to-$len+1;
	$loc{$from}=$to;
	print " possible rRNA signature: $from..$to\n";		
	}		

	
return();	
}
1;
	
		
	sub overlapRNA{
	$from=$_[0];
	$to=$_[1];
	$check=0;
			foreach $k (keys %loc){
				if(($k>=$from) & ($k<$to)){
				$check=1;
				}
				elsif(($loc{k}>$from) & ($loc{k}<=$to)){
				$check=1;
				}
			}
		
		
	return($check);
	}
	1;

	







