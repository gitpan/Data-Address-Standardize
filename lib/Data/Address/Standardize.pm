#
# Standardize.pm
#
# [ $Revision: 1.7 $ ]
#
# Perl 5 module to standardize U.S. postal addresses by referencing
# the U.S. Postal Service's web site:
#
#     http://www.usps.gov/ncsc/lookups/lookup_zip+4.html'
#
# BE SURE TO READ AND UNDERSTAND THE TERMS OF USE SECTION IN THE
# DOCUMENTATION, WHICH MAY BE FOUND AT THE END OF THIS SOURCE CODE.
#
# Copyright (C) 1999-2001 Gregor N. Purdy. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#

package Data::Address::Standardize;
use strict;

BEGIN {
	use Exporter;
	use vars qw(@ISA @EXPORT @EXPORT_OK);
	@ISA       = qw(Exporter);
	@EXPORT    = qw(&std_addr &std_addrs);
	@EXPORT_OK = @EXPORT;
}
use vars qw($VERSION);
$VERSION = '0.004';

use Scrape::USPS::ZipLookup;

my $zlu = Scrape::USPS::ZipLookup->new();


#
# verbose()
#

sub verbose
{
  $zlu->verbose(@_);
}


#
# std_addr()
#

sub std_addr
{
  return $zlu->std_addr(@_);
}


#
# std_addrs()
#

sub std_addrs
{
  return $zlu->std_addrs(@_);
}


#
# Proper module termination:
#

1;

__END__

#
# Documentation:
#

=pod

=head1 NAME

Data::Address::Standardize - Standardize U.S. postal addresses.

=head1 SYNOPSIS

  use Data::Address::Standardize;
  ($street, $city, $state, $zip) = std_addr($street, $city, $state, $zip);

or,

  use Data::Address::Standardize;
  # Read in a pipe-delimited data set like a filter.
  while(<>) {
      chomp;
      my @addr = split('\|');
      push @addr_list, [ @addr ];
  }
  my @std_list = std_addrs(@addr_list);
  # Write a pipe-delimited data set to standard output.
  foreach (@std_list) {
      print join('|', @$_), "\n";
  }


=head1 DESCRIPTION

B<NOTE:> This code is (nearly) obsolete. It has been gutted, and the guts now
reside in Scrape::USPS::ZipLookup. This module persists to maintain the
old interface, but use of this module now requires that Scrape::USPS::ZipLookup
be installed.

The United States Postal Service (USPS) has on its web site an HTML form at
C<http://www.usps.gov/ncsc/lookups/lookup_zip+4.html>
for standardizing an address. Given a firm, urbanization, street address,
city, state, and zip, it will put the address into standard form (provided
the address is in their database) and display a page with the resulting
address.

This Perl module provides a programmatic interface to this service, so you
can write a program to process your entire personal address book without
having to manually type them all in to the form.

Because the USPS could change or remove this functionality at any time,
be prepared for the possibility that this code may fail to function. In
fact, as of this version, there is little error checking in place, so if they
do change things, this code will most likely fail in a noisy way. If you
discover that the service has changed, please email the author your findings.

If an error occurs in trying to standardize the address, then no array
will be returned. Otherwise, a four-element array will be returned.

To see debugging output, call C<Data::Address::Standardize::verbose(1)>.


=head1 TERMS OF USE

BE SURE TO READ AND FOLLOW THE UNITED STATES POSTAL SERVICE TERMS OF USE
PAGE AT C<http://www.usps.gov/disclaimer.html>. IN PARTICULAR, NOTE THAT THEY
DO NOT PERMIT THE USE OF THEIR WEB SITE'S FUNCTIONALITY FOR COMMERCIAL
PURPOSES. DO NOT USE THIS CODE IN A WAY THAT VIOLATES THE TERMS OF USE.

The author believes that the example usage given above does not violate
these terms, but sole responsibility for conforming to the terms of use
belongs to the user of this code, not the author.


=head1 AUTHOR

Gregor N. Purdy, C<gregor@focusresearch.com>.


=head1 COPYRIGHT

Copyright (C) 1999-2001 Gregor N. Purdy. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut


#
# End of file.
#

