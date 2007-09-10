use inc::Module::Install;
name 'DBIx-Lookup-Field';
all_from 'lib/DBIx/Lookup/Field.pm';

build_requires 'Test::More';

use_test_base;
auto_include;
WriteAll;
