package DBIx::Lookup::Field;

require 5.005_62;
use strict;
use warnings;
use Carp;
use base 'Exporter';

our $VERSION = '1.21';

our %EXPORT_TAGS = ( 'all' => [ qw(
	dbi_lookup_field dbi_lookup_field_with_reverse
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

sub dbi_lookup_field {
	my %args = @_;

	my $msg = 'dbi_lookup_field: missing required argument ';
	for (qw/DBH TABLE KEY VALUE/) {
		$args{$_} || croak "$msg '$_'\n";
	}

	my $where = $args{WHERE} ? "WHERE $args{WHERE}" : '';

	my $sth = $args{DBH}->prepare(<<EOSQL);
    select $args{KEY}, $args{VALUE} from $args{TABLE} $where
EOSQL
	$sth->execute;

	my %lookup;
	while (my ($key, $value) = $sth->fetchrow_array) {
		$lookup{$key} = $value;
	}

	$sth->finish;
	return \%lookup;
}

sub dbi_lookup_field_with_reverse {
	my $lookup = dbi_lookup_field(@_);
	my %reverse = reverse %$lookup;
	($lookup, \%reverse);
}

1;
__END__

=head1 NAME

DBIx::Lookup::Field - Create a lookup hash from a database table

=head1 SYNOPSIS

  use DBI;
  use DBIx::Lookup::Field qw/dbi_lookup_field/;

  $dbh = DBI->connect(...);
  my $inst_id = dbi_lookup_field(
      DBH   => $dbh,
      TABLE => 'institution'
      KEY   => 'name',
      VALUE => 'id',
  );

  print "Inst_A has id ", $inst_id->{Inst_A};

=head1 DESCRIPTION

This module provides a way to construct a hash from a database table. This
is useful for the situation where you have to perform many lookups of a
field by using a key from the same table. If, for example, a table has an
id field and a name field and you often have to look up the name by its
id, it might be wasteful to issue many separate SQL queries. Having
the two fields as a hash speeds up processing, although at the expense
of memory.

=head1 EXPORTS

=over 4

=item dbi_lookup_field()

This function creates a hash from two fields in a database table on a
DBI connection. One field acts as the hash key, the other acts as the
hash value. It expects a parameter hash and returns a reference to the
lookup hash.

The following parameters are accepted. Parameters can be required or
optional. If a required parameter isn't given, an exception is raised
(i.e., it dies).

=over 4

=item DBH

The database handle through which to access the table from which to
create the lookup. Required.

=item TABLE

The name of the table that contains the key and value fields. Required.

=item KEY

The field name of the field that is to act as the hash key. Required.

=item VALUE

The field name of the field that is to act as the hash value. Required.

=item WHERE

A SQL 'WHERE' clause with which to restrict the 'SELECT' statement that
is used to create the hash. Optional.

=back

=item dbi_lookup_field_with_reverse()

This function takes the same parameters as C<dbi_lookup_field()> but in
addition to the lookup hash, it also returns a reversed hash where you
can lookup the table keys by the table values.

  my ($lookup, $reverse) = dbi_lookup_field_with_reverse(...);

Note that if a value occurs more than once, only one of the potential
keys will win (the one that occurs first in the lookup hash's key order),
so be warned.

=back

=head1 BUGS

None known at this time. If you find any oddities or bugs, please do
report them to the author.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 VERSION

This document describes version 1.21 of C<DBIx::Lookup::Field>.

=head1 AUTHOR

Marcel GrE<uuml>nauer E<lt>marcel@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2001-2002 Marcel GrE<uuml>nauer. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

DBI(3pm).

=cut
