@echo off & perl -x %0 >02_generate.bat & pause & exit
#!perl
use strict;
use warnings;

# http://strawberryperl.com/ 
# http://www.imagemagick.org/
# export -> encode in utf-8 without bom

my $convert = qq|"C:\\Program Files\\ImageMagick-6.9.0-Q16\\convert.exe"|;
my $mx = 50;
my $my = 100;
my $hy = $my / 2;

for(my $i = 35; $i <= 40; $i++)
{
    for(my $j = 0; $j <= $i; $j++)
    {
        my($r, $g, $b) = map { int($_ * 256) } color(3000 / (4.3 + 3.2 * $j / $i));
        
        print "$convert -background white -fill \"rgb($r,$g,$b)\" -stroke black " .
            "-size ${mx}x${my} -gravity center label:\"$j\\n$i\" " .
            "-strokewidth 1 -draw \"line 0,$hy $mx,$hy\" " .
            " F\\${j}_${i}.png\n";
    }
}

# http://stackoverflow.com/questions/3407942/rgb-values-of-visible-spectrum
# RGB <0,1> <- lambda l <400,700> [nm]
sub color
{
    my $l = shift;
    my $t;
    my $r = 0;
    my $g = 0;
    my $b = 0;
    
       if (($l>=400.0)&&($l<410.0)) { $t=($l-400.0)/(410.0-400.0); $r=    +(0.33*$t)-(0.20*$t*$t); }
    elsif (($l>=410.0)&&($l<475.0)) { $t=($l-410.0)/(475.0-410.0); $r=0.14          -(0.13*$t*$t); }
    elsif (($l>=545.0)&&($l<595.0)) { $t=($l-545.0)/(595.0-545.0); $r=    +(1.98*$t)-(     $t*$t); }
    elsif (($l>=595.0)&&($l<650.0)) { $t=($l-595.0)/(650.0-595.0); $r=0.98+(0.06*$t)-(0.40*$t*$t); }
    elsif (($l>=650.0)&&($l<700.0)) { $t=($l-650.0)/(700.0-650.0); $r=0.65-(0.84*$t)+(0.20*$t*$t); }
       if (($l>=415.0)&&($l<475.0)) { $t=($l-415.0)/(475.0-415.0); $g=              +(0.80*$t*$t); }
    elsif (($l>=475.0)&&($l<590.0)) { $t=($l-475.0)/(590.0-475.0); $g=0.8 +(0.76*$t)-(0.80*$t*$t); }
    elsif (($l>=585.0)&&($l<639.0)) { $t=($l-585.0)/(639.0-585.0); $g=0.84-(0.84*$t)             ; }
       if (($l>=400.0)&&($l<475.0)) { $t=($l-400.0)/(475.0-400.0); $b=    +(2.20*$t)-(1.50*$t*$t); }
    elsif (($l>=475.0)&&($l<560.0)) { $t=($l-475.0)/(560.0-475.0); $b=0.7 -(     $t)+(0.30*$t*$t); }
    
    return ($r, $g, $b);
}