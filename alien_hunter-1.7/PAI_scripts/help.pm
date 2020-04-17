=head1 NAME

PAI_scripts::help

=head1 SYNOPSIS

provides help info to the user

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


package PAI_scripts::help;
use Exporter;
@ISA = ("Exporter");
@EXPORT = qw (&help);

	sub help{
	print "\n----------------------------\n\talien_hunter [Release 1.7] \n\n\tINPUT: raw genomic sequence PREDICTION: HGT regions based on Interpolated Variable Order Motifs (IVOMs) 
	
	arguments:
	
	[<sequence.file>]
	
	[<output.file>]
	
	(optional):
	
	[-a] to load the prediction file into Artemis
		
	[-c] optimize predicted boundaries with a change-point detection 2 state 2nd order HMM
	
	output:
	
	<output.file> predictions (tab file) in embl format
	
	<output.file.opt> optimized (HMM) predictions (tab file) in embl format
	
	<output.file.plot> predictions in Artemis User Plot format to be loaded manually using Graph -> Add User Plot...
	
	<output.file.opt.plot> optimized (HMM) predictions in Artemis User Plot format to be loaded manually using Graph -> Add User Plot...
	
	<output.file.sco> the scores over all the sliding windows - for score distribution check
	
	Note: Predictions that overlap with rRNA operon are mentioned in the note qualifier
	
	------------------------\n";

	}
