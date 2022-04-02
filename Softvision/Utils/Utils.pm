package Softvision::Utils::Utils;

use strict;
use warnings;

use base qw(Exporter);

our @EXPORT_OK = qw(
    trim 
    remove_duplicates_from_array
);

sub trim {
    my ($text) = @_;

    return
         unless $text;

    $text =~ s/^\s*|\s*$//g;

    return $text;
}

sub remove_duplicates_from_array {
    my ($array) = @_;

    return $array
        unless $array;

    my %hash = map { $_ => 1 } @$array;
    my @unique_array = keys %hash; 

    return \@unique_array;
}

1;