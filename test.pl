#!/usr/bin/perl -w

use strict;
use Data::Address::Standardize;

my @tries = (
	[ '6216 Eddington Drive', 'Liberty Township', 'oh', '45044' ]
);

print "1..", scalar(@tries), "\n";

my $i;

foreach my $try (@tries) {
	print join("\n", std_addr(@$try)), "\n";
	print "ok\n\n";
}


#
# End of file.
#

