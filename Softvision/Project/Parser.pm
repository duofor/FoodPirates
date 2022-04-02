package Softvision::Project::Parser;

use strict;
use warnings;

use Softvision::Utils::Utils qw( trim );

use constant {
    FILE_NAME => 'Mobile_Food_Facility_Permit.csv',
    FILE_PATH => 'C:\Strawberry\perl\lib\Softvision\DataFiles'
};

sub new {
    my ($class, %args) = @_;

    my $self = bless { %args }, $class;

    return $self;
}

sub parse_file {
    my ($self) = @_;

    open(my $IN, '<', FILE_PATH . '\\' . FILE_NAME)
        or die "Cannot open file: @{[FILE_NAME]}: $?";

    my @headers = map { trim($_) } split(',', <$IN> );

    my $all_permits;
    while (my $line = <$IN>) {
        my @data = split(',', $line);

        my %permit;
        @permit{@headers} = @data;
        push(@$all_permits, \%permit);
    }

    close $IN
        or die "Cannot close file: @{[FILE_NAME]}: $?";

    return $all_permits;
}

1;