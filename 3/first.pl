#!/usr/bin/perl
use strict;
use warnings;

my $file = "input.txt";
my @map;
my $n = 0, my $m = 0;

open my $input, $file or die "Could not open $file";

while(my $line = <$input>) {
    $n++;

    chomp $line;
    $m = length($line);

    my $i = $. - 1;
    my $j = 0;

    foreach my $char (split(//, $line)) {
        $map[$i][$j++] = $char;
    }
}

close $input;

my $j = 0, my $result = 0;

for my $i (1..($n - 1)) {
    $j = ($j + 3) % $m;

    if($map[$i][$j] eq '#') {
        $result++;
    }
}

print($result, "\n");
