use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'DBIx::Lookup::Field',
    'VERSION_FROM'	=> 'lib/DBIx/Lookup/Field.pm',
    'PREREQ_PM'		=> {
    	Test::Distribution => 1.02,
    },
    dist                => {
	COMPRESS => 'gzip --force --best'
    },
);
