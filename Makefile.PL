use inc::Module::Install;
name 'DBIx-Lookup-Field';
all_from 'lib/DBIx/Lookup/Field.pm';
perl_version '5.006';

build_requires 'Test::More' => '0.70';

use_standard_tests;
auto_include;
WriteAll;
