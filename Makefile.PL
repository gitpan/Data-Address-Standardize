#
# Makefile.PL
#
# [ $Version: $ ]
#

use ExtUtils::MakeMaker;

WriteMakefile (
	NAME         => 'Data::Address::Standardize',
	VERSION_FROM => 'lib/Scrape/USPS/ZipLookup.pm',
	PREREQ_PM    => {
		HTTP::Request          => 0,
		HTTP::Request::Common  => 0,
		HTTP::Response         => 0,
		LWP::UserAgent         => 0,
        URI                    => 0,
	},
	AUTHOR       => 'Gregor N. Purdy (gregor@focusresearch.com)',
	ABSTRACT     => 'Standardize U.S. postal addresses',
	dist         => { COMPRESS => 'gzip -9f', SUFFIX => 'gz' }
);

#
# End of file.
#
