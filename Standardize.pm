#
# Standardize.pm
#
# Perl 5 module to standardize U.S. postal addresses by referencing
# the U.S. Postal Service's web site.
#
# BE SURE TO READ AND UNDERSTAND THE TERMS OF USE SECTION IN THE
# DOCUMENTATION, WHICH MAY BE FOUND AT THE END OF THIS SOURCE CODE.
#
# Copyright (C) 1999-2000 Gregor N. Purdy. All rights reserved.
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
$VERSION = '0.002';

use LWP::UserAgent;
use HTTP::Request::Common;

use vars qw($verbose);

my $form_url  = 'http://www.usps.gov/cgi-bin/zip4/zip4inq';


#
# parse_response()
#
# Input:  A string containing the HTML returned from the form request.
# Output: An array of the Street Address, City, State, and Zip.
#

sub parse_response
{
	my ($addr) = @_;

	return unless ($addr =~ m/The standardized address is:/sm);

	#
	# First, chop out all the lines preceding and following the
	# address:
	#

	$addr =~ s/^.*The standardized address is:<p>(.*)<TABLE.*$/$1/sm;

	#
	# Now, perform some simple transformations to get it into shape:
	#

	$addr =~ s/<\/?b>//ig;  # Remove <b> and </b> tags.
	$addr =~ s/<br>//ig;    # Remove <br> tags.
	$addr =~ s/^\s*//mg;    # Remove leading whitespace.
	$addr =~ s/\s*$//mg;    # Remove trailing whitespace.
	$addr =~ s/\n/|/mg;     # Put it all on one line with '|' between fields
	$addr =~ s/\s+/ /g;     # Collapse whitespace.

	#
	# Add field delimiters for the state and zip code:
	#

	$addr =~ s/ ([A-Z]{2}) (\d{5}(-\d{4})?).*$/|$1|$2/i;

	#
	# Split it into an array and return it:
	#
	# We do explicit assignment in case there were any extra elements
	# produced by split.
	#

	my ($street, $city, $state, $zip) = split('\|', $addr);

	return ($street, $city, $state, $zip);
}


#
# form_request()
#

sub form_request
{
	my ($street, $city, $state, $zip) = @_;

	my $req = POST $form_url, [
		company      => '',
		urbanization => '',
		street       => $street,
		city         => $city,
		state        => $state,
		zip          => $zip
	];

	return $req;
}


#
# std_inner()
#
# The inner portion of the process, so it can be shared by
# std_addr() and std_addrs().
#

sub std_inner
{
	my $ua  = shift;

	if ($verbose) {
		print ' ', '_' x 77, ' ',  "\n";
		print '/', ' ' x 77, '\\', "\n";
		print "THE INPUT WAS:\n";
		print "'", join("'\n'", @_), "'\n";
	}

	my $req = form_request(@_);

	if ($verbose) {
		print "-" x 79, "\n";
		print "THE REQUEST WAS:\n";
		print $req->content, "\n";
	}

	my $res = $ua->request($req);

	die $res->error_as_HTML unless $res->is_success;

	if ($verbose) {
		print "-" x 79, "\n";
		print "THE RESPONSE WAS:\n";
		print $res->content;
	}

	my @result = parse_response($res->content);

	if ($verbose) {
		print "-" x 79, "\n";

		if (@result) {
			print "THE OUTPUT WAS:\n";
			print "'", join("'\n'", @result), "'\n";
		} else {
			print "THERE WAS NO OUTPUT (ERROR).\n";
		}

		print '\\', '_' x 77, '/',  "\n";
	}

	return @result;
}


#
# std_addr()
#

sub std_addr
{
	my $ua  = new LWP::UserAgent;

	return std_inner $ua, @_;
}


#
# std_addrs()
#

sub std_addrs
{
	my @result;

	my $ua = new LWP::UserAgent;

	foreach my $addr (@_) {
		my @addr = std_inner($ua, @$addr);

		push @result, [ @addr ];
	}

	return @result;
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
fact, as of this version, there is no error checking in place, so if they
do change things, this code will most likely fail in a noisy way. If you
discover that the service has changed, please email the author your findings.

If an error occurs in trying to standardize the address, then no array
will be returned. Otherwise, a four-element array will be returned.

To see debugging output, set $Data::Address::Standardize::verbose to a
true value.


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

Copyright (C) 1999-2000 Gregor N. Purdy. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut


#
# End of file.
#

