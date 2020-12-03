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

my $shift_count = 5;
my @right_shifts = (1, 3, 5, 7, 1);
my @down_shifts  = (1, 1, 1, 1, 2);

my $result = 1;

for my $z (0..($shift_count - 1)) {
    my $i = 0, my $j = 0, my $tree_count = 0;

    while ($i < $n - $down_shifts[$z]) {
        $i += $down_shifts[$z];
        $j = ($j + $right_shifts[$z]) % $m;

        if($map[$i][$j] eq '#') {
            $tree_count++;
        }
    }

    $result *= $tree_count;
}

print($result, "\n");
