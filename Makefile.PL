use ExtUtils::MakeMaker;

WriteMakefile (
	NAME         => 'Data::Address::Standardize',
	VERSION_FROM => 'Standardize.pm',
	PREREQ_PM    => {
		LWP::UserAgent        => 0,
		HTTP::Request::Common => 0
	},
	AUTHOR       => 'Gregor N. Purdy (gregor@focusresearch.com)',
	ABSTRACT     => 'Standardize U.S. postal addresses',
	dist         => { COMPRESS => 'gzip -9f', SUFFIX => 'gz' }
);

