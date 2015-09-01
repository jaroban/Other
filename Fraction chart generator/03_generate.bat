@echo off & perl -x %0 & pause & exit
#!perl
use strict;
use warnings;

# http://strawberryperl.com/ 
# http://www.imagemagick.org/
# export -> encode in utf-8 without bom

my $convert = qq|"C:\\Program Files\\ImageMagick-6.9.0-Q16\\convert.exe"|;
# landscape
#my $my = 3000;
#my $mx = int($my * sqrt(2));
# portrait
my $mx = 2000;
my $my = int($mx * sqrt(2));

my $size = $mx . 'x' . $my;
my $output = 'result.png';
my $lines = 'lines.txt';
my $texts = 'texts.txt';

my $cmd = "$convert -size $size xc:white -fill black -stroke black " .
    " -gravity None -pointsize 24 -draw \"\@$texts\" " .
    " -strokewidth 3 -draw \"\@$lines\" ";

open LINES, '>', $lines or die $!;
open TEXTS, '>', $texts or die $!;

my @f = (2..36);  # 25
my $y = 0;
for my $i (@f)
{
    my $lx = 50;
    my $ly = 20 + 120 * $y;
    my $rx = $mx - $lx;
    print LINES qq|line $lx,$ly $rx,$ly\n|;     # axis
    for my $j (0..$i)
    {
        my $px = sprintf("%0.00f", $lx + ($rx - $lx) * $j / $i);
        my $py1 = $ly - 10;
        my $py2 = $ly + 10;
        print LINES qq|line $px,$py1 $px,$py2\n|;   # tick
        my $tx = $px - 25; 
        my $ty = $ly + 10;
        $cmd .= "F\\${j}_${i}.png -geometry +$tx+$ty -composite ";
    }
    $y++;
}
close LINES or die $!;
close TEXTS or die $!;

$cmd .= " " . $output;

system($cmd) == 0 or die "system $cmd failed: $?";
system($output) == 0 or die "system $output failed: $?";
