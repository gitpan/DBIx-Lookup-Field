use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'DBIx::Lookup::Field',
    'VERSION_FROM'	=> 'lib/DBIx/Lookup/Field.pm',
    'PREREQ_PM'		=> {
    	Test::Comprehensive => 1.00,
    },
    dist                => {
    	# don't ask about existing .tar.gz files
	COMPRESS => 'gzip --force --best'
    },
);
