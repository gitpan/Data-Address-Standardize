#!/usr/bin/perl -w
#
# test.pl - Test script.
#

use strict;
use Data::Address::Standardize;

#$Data::Address::Standardize::verbose = 1;


#
# Read in the tries:
#

my @addrs;
my @tries;

open TRIES, "tries.dat"
	or die "test.pl: Could not open 'tries.dat' for reading: $!\n";

my %try = ( );

while (<TRIES>) {
	chomp;

	next if m/^\s*#/; # Skip comment lines.
	next if m/^\s*$/; # Skip blank lines.

	my ($key, $value) = m/^\s*([A-Za-z]+)\s*=\s*(.*)$/;

	die "test.pl: Bad format for line '$_'\n" unless defined($key) and defined($value);

	$key = uc $key;
	$value =~ s/^\s*//;
	$value =~ s/\s*$//;

	if (exists($try{$key})) {
		push @addrs, [ $try{STREET}, $try{CITY}, $try{STATE}, $try{ZIP} ];

		%try = ( );
	}

	$try{$key} = $value;
}

push @addrs, [ $try{STREET}, $try{CITY}, $try{STATE}, $try{ZIP} ];

%try = ( );

close TRIES;

if (scalar(@addrs) % 2) {
	die "try.pl: There must be an even number of addresses in 'tries.dat' since they are used in pairs!\n";
}

while (@addrs) {
	my $in  = shift @addrs;
	my $out = shift @addrs;

	push @tries, [ $in, $out ];
}


#
# Perform the test cases:
#

printf "1..%d\n", scalar(@tries);

my $i;
my $failed = 0;


foreach my $try (@tries) {
	my ($in, $out) = @$try;

	my @result = std_addr(@$in);

	if ($out->[0] eq '<error>') {
		if (@result) {
			print 'not ';
			$failed++;
		}
	} else {
		if (join('|', @$out) ne join('|', @result)) {
			print 'not ';
			$failed++;
		}
	}

	printf "ok %d\n", ++$i;
}


exit $failed;

#
# End of file.
#

