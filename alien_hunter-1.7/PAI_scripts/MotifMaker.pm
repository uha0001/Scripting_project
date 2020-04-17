=head1 NAME

PAI_scripts::MotifMaker

=head1 SYNOPSIS

scans for motifs and builds the IVOM vectors

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


package PAI_scripts::MotifMaker;
use Exporter;
@ISA = ("Exporter");
@EXPORT = qw (&MMaker &scan &IvomBuild);

$pos_base{"1"}="A";
$pos_base{"2"}="T";
$pos_base{"3"}="C";
$pos_base{"4"}="G";

$compl{"A"}="T";
$compl{"T"}="A";
$compl{"C"}="G";
$compl{"G"}="C";
$compl{"a"}="t";
$compl{"t"}="a";
$compl{"c"}="g";
$compl{"g"}="c";

$amb=0;

#creates all k (<=8) order motifs
sub MMaker{
	print"\n building motif vectors (order k <=7) ...\n\n";

	for ($a=1;$a<=4;$a++){#1
	$m1=$pos_base{$a};
	$n1mer="$m1";
	$n1mers{$n1mer}=0;
#--------------------------------	 
	 for ($b=1;$b<=4;$b++){#2
	 $m2=$pos_base{$b};
	 $n2mer="$m1$m2";
	 $n2mers{$n2mer}=0;
	 
	 $motifRev="";
	 for($x=0;$x<=2-1;$x++){
	 $base=substr($n2mer,$x,1);
	 $motifRev.=$compl{$base};
	 }
	 $Con2{$n2mer}=reverse($motifRev);
#--------------------------------	 
	  for ($c=1;$c<=4;$c++){#3
	  $m3=$pos_base{$c};
	  $n3mer="$m1$m2$m3";
	  $n3mers{$n3mer}=0;
	  
	 $motifRev="";
	 for($x=0;$x<=3-1;$x++){
	 $base=substr($n3mer,$x,1);
	 $motifRev.=$compl{$base};
	 }
	 $Con3{$n3mer}=reverse($motifRev);
#--------------------------------	  
	   for ($d=1;$d<=4;$d++){#4
	   $m4=$pos_base{$d};
	   $n4mer="$m1$m2$m3$m4";
	   $n4mers{$n4mer}=0;
	   
	 $motifRev="";
	 for($x=0;$x<=4-1;$x++){
	 $base=substr($n4mer,$x,1);
	 $motifRev.=$compl{$base};
	 }
	 $Con4{$n4mer}=reverse($motifRev);
#--------------------------------	   
	    for ($e=1;$e<=4;$e++){#5
	    $m5=$pos_base{$e};
	    $n5mer="$m1$m2$m3$m4$m5";
	    $n5mers{$n5mer}=0;
	    
	 $motifRev="";
	 for($x=0;$x<=5-1;$x++){
	 $base=substr($n5mer,$x,1);
	 $motifRev.=$compl{$base};
	 }
	 $Con5{$n5mer}=reverse($motifRev);
#--------------------------------	    
	     for ($f=1;$f<=4;$f++){#6
	     $m6=$pos_base{$f};
	     $n6mer="$m1$m2$m3$m4$m5$m6";
	     $n6mers{$n6mer}=0;
	     
	 $motifRev="";
	 for($x=0;$x<=6-1;$x++){
	 $base=substr($n6mer,$x,1);
	 $motifRev.=$compl{$base};
	 }
	 $Con6{$n6mer}=reverse($motifRev);
#--------------------------------	     
	      for ($g=1;$g<=4;$g++){#7
	      $m7=$pos_base{$g};
	      $n7mer="$m1$m2$m3$m4$m5$m6$m7";
	      $n7mers{$n7mer}=0;
	      
	 $motifRev="";
	 for($x=0;$x<=7-1;$x++){
	 $base=substr($n7mer,$x,1);
	 $motifRev.=$compl{$base};
	 }
	 $Con7{$n7mer}=reverse($motifRev);
#--------------------------------	      
	       for ($h=1;$h<=4;$h++){#8
	       $m8=$pos_base{$h};
	       $n8mer="$m1$m2$m3$m4$m5$m6$m7$m8";
	       $n8mers{$n8mer}=0; 					
	       
	 $motifRev="";
	 for($x=0;$x<=8-1;$x++){
	 $base=substr($n8mer,$x,1);
	 $motifRev.=$compl{$base};
	 }
	 $Con8{$n8mer}=reverse($motifRev);
	       
	       }
	      }
	     }
	    }
	   }
	  }
	 }
	}
	
	
	
	
return();	
}#sub MMaker	
1;

sub scan{
	
	$seq=$_[0];
	$ch=$_[1];

	$len=length($seq);
	$amb=0;
	$count8merswithN=0;
	
	#empty the hashes - ready for the next 5kb window
	flushHash();
		
	for ($i=0;$i<=$len-8;$i++){
		
		#8mers									
		$motif=substr($seq,$i,8);
		$motif=uc($motif);#converts to upper case always
		
		#ambiguous bases check
		if(!exists($n8mers{$motif})){
		$amb=1;
		
			#in the case of the Genome scan simply ignore the current 8mer and continue with the next one
			if($ch==0){
			$count8merswithN++;
			goto HERE;
			}
			#in the case of the slid. window, skip the scan process for the whole window and continue with the next one
			else{
			goto HERE2;
			}
		
		}
		
		$n8mers{$motif}++;
		$n8mers{$Con8{$motif}}++;
		
		#1mers
		$n=substr($motif,7,1);
		$n1mers{$n}++;
		$n1mers{$compl{$n}}++;
				
		#2mers
		$n=substr($motif,6,2);
		$n2mers{$n}++;
		$n2mers{$Con2{$n}}++;
		
		#3mers
		#$n=unpack("x5 A3", $motif);
		$n=substr($motif,5,3);
		$n3mers{$n}++;
		$n3mers{$Con3{$n}}++;
		
		#4mers
		$n=substr($motif,4,4);
		$n4mers{$n}++;
		$n4mers{$Con4{$n}}++;
		
		#5mers
		$n=substr($motif,3,5);
		$n5mers{$n}++;
		$n5mers{$Con5{$n}}++;
		
		#6mers
		$n=substr($motif,2,6);
		$n6mers{$n}++;
		$n6mers{$Con6{$n}}++;
				
		#7mers
		$n=substr($motif,1,7);
		$n7mers{$n}++;
		$n7mers{$Con7{$n}}++;
		
	HERE:	
	}
	
	#motifs in the first 8mer
	$motif=substr($seq,0,8);
	$motif=uc($motif);
		
		
		#7mers
		for($a=0;$a<=0;$a++){
		$n=substr($motif,$a,7);
		
			if(!exists($n7mers{$n})){
			goto HERE2;
			}
		
		$n7mers{$n}++;
		$n7mers{$Con7{$n}}++;
		}
		#1mer
		for($a=0;$a<=6;$a++){
		$n=substr($motif,$a,1);
		$n1mers{$n}++;
		$n1mers{$compl{$n}}++;
		}
		#2mers
		for($a=0;$a<=5;$a++){
		$n=substr($motif,$a,2);
		$n2mers{$n}++;
		$n2mers{$Con2{$n}}++;
		}
		#3mers
		for($a=0;$a<=4;$a++){
		$n=substr($motif,$a,3);
		$n3mers{$n}++;
		$n3mers{$Con3{$n}}++;
		}
		#4mers
		for($a=0;$a<=3;$a++){
		$n=substr($motif,$a,4);
		$n4mers{$n}++;
		$n4mers{$Con4{$n}}++;
		}
		#5mers
		for($a=0;$a<=2;$a++){
		$n=substr($motif,$a,5);
		$n5mers{$n}++;
		$n5mers{$Con5{$n}}++;
		}
		#6mers
		for($a=0;$a<=1;$a++){
		$n=substr($motif,$a,6);
		$n6mers{$n}++;
		$n6mers{$Con6{$n}}++;
		}
		
		
HERE2:		
return($amb,$count8merswithN);
}
1;
	
sub flushHash{
		foreach $k (keys %n8mers){
		$n8mers{$k}=0;
		}
		foreach $k (keys %n7mers){
		$n7mers{$k}=0;
		}
		foreach $k (keys %n6mers){
		$n6mers{$k}=0;
		}
		foreach $k (keys %n5mers){
		$n5mers{$k}=0;
		}
		foreach $k (keys %n4mers){
		$n4mers{$k}=0;
		}
		foreach $k (keys %n3mers){
		$n3mers{$k}=0;
		}
		foreach $k (keys %n2mers){
		$n2mers{$k}=0;
		}
		foreach $k (keys %n1mers){
		$n1mers{$k}=0;
		}
return();	
}
1;

sub IvomBuild{
	
		#calculates weights Wi(=Counts*deg_freedom) and obs_freqs (Pi)
		foreach $k (keys %n8mers){
			
		#w8
		$w8=$n8mers{$k}*65536;
		$p8=$n8mers{$k}/(($len-7-$count8merswithN)*2);
		
		#deletes the values;
		#$n8mers{$k}=0;
		#print "$k $p8\n";
		#w7
		$n=substr($k,1,7);
		$w7=$n7mers{$n}*16384;
		$p7=$n7mers{$n}/(($len-6-$count8merswithN)*2);
		#print "$n $p7\n";
		#w6
		$n=substr($k,2,6);
		$w6=$n6mers{$n}*4096;
		$p6=$n6mers{$n}/(($len-5-$count8merswithN)*2);
		#print "$n $p6\n";
		#w5
		$n=substr($k,3,5);
		$w5=$n5mers{$n}*1024;
		$p5=$n5mers{$n}/(($len-4-$count8merswithN)*2);
		#$n5mers{$n}=0;
		#print "$n $p5\n";
		#w4
		$n=substr($k,4,4);
		$w4=$n4mers{$n}*256;
		$p4=$n4mers{$n}/(($len-3-$count8merswithN)*2);
		#print "$n $p4\n";
		#w3
		$n=substr($k,5,3);
		$w3=$n3mers{$n}*64;
		$p3=$n3mers{$n}/(($len-2-$count8merswithN)*2);
		#print "$n $p3\n";
		#w2
		$n=substr($k,6,2);
		$w2=$n2mers{$n}*16;
		$p2=$n2mers{$n}/(($len-1-$count8merswithN)*2);
		#print "$n $p2\n";
		#w1
		$n=substr($k,7,1);
		$w1=$n1mers{$n}*4;
		$p1=$n1mers{$n}/(($len-$count8merswithN)*2);
		#print "$n $p1\n";
		
		$w_tot=$w8+$w7+$w6+$w5+$w4+$w3+$w2+$w1;
				
		#calculates w%
		$w8=$w8/$w_tot;
		$w7=$w7/$w_tot;
		$w6=$w6/$w_tot;
		$w5=$w5/$w_tot;
		$w4=$w4/$w_tot;
		$w3=$w3/$w_tot;
		$w2=$w2/$w_tot;
		$w1=$w1/$w_tot;
				
		#calculates IVOMk= Wk*Pk + [1-Wk]IVOMk-1
		$IVOM1=$w1*$p1;
		$IVOM2=$w2*$p2+((1-$w2)*$IVOM1);
		$IVOM3=$w3*$p3+((1-$w3)*$IVOM2);
		$IVOM4=$w4*$p4+((1-$w4)*$IVOM3);
		$IVOM5=$w5*$p5+((1-$w5)*$IVOM4);
		$IVOM6=$w6*$p6+((1-$w6)*$IVOM5);
		$IVOM7=$w7*$p7+((1-$w7)*$IVOM6);
		$IVOM8{$k}=$w8*$p8+((1-$w8)*$IVOM7);
		#print"$k $IVOM8 $w8 $p8 $w7 $p7 $w6 $p6 $w5 $p5 $w4 $p4 $w3 $p3 $w2 $p2 $w1 $p1\n";
		$sum+=$IVOM8{$k};
		}
		
		#scale from 0 to 1 (cause relative entropy)
		foreach $k (keys %IVOM8){
		$IVOM8{$k}=$IVOM8{$k}/$sum;
		}
		$sum=0;

return(\%IVOM8);
}
1;
	
	
	
