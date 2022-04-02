package Softvision::Project::Runner;

use strict;
use warnings;

use Softvision::Project::Parser;
use Softvision::Project::Downloader;

__PACKAGE__->run() 
    unless caller;

sub run {

    my $parser = Softvision::Project::Parser->new();
    my $downloader = Softvision::Project::Downloader->new();
    my $permits = $parser->parse_file();
    _start($permits, $downloader);
}

sub _start {
    my ($permits, $downloader) = @_;

    _print_and_sleep("Are you hungry?");
    _print_and_sleep("And broke?");
    _print_and_sleep("Welcome to food pirates!");
    _print_and_sleep("Today we gonna rob some foodtrucks.");
    _print_and_sleep("What would you like to have? Hot dogs? Sum Snacks?");
    _print_and_sleep("What about a quesadilla?");
    _print_and_sleep("Enter the food you want to search for:");

    my $food = <STDIN>;
    chomp($food);
    _print_and_sleep("Searching for vehicles with $food ...");

    my $info = _find_target_trucks($food, $permits);

    _print_and_sleep("We found " . scalar @$info . " possible targets");
    
    foreach my $item (@$info) {
        _print_and_sleep("Is this close to you?: $item->{Address}");
        _print_and_sleep("type yes or no: ");
        my $choice = <STDIN>;
        chomp($choice);

        next
            unless ($choice eq 'yes');

        my $path = $downloader->download_images_by_address($item->{Address});
        _print_and_sleep("Inside $path, you will find some images.");
        _print_and_sleep("The vehicle transporting $food will be passing by this area.");
        _print_and_sleep("Here you can find the schedule:\n$item->{Schedule}");
        _print_and_sleep("Happy pirating !");
        exit;
    }

    _print_and_sleep("Sadly we couldnt help you :(. Try other food maybe?");
}

sub _print_and_sleep {
    my ($text) = @_;

    print "$text\n";
    sleep(1);
}

sub _find_target_trucks {
    my ($food, $permits) = @_;

    my @addresses;
    foreach my $permit (@$permits) {
        if ($permit->{FoodItems} =~ /$food/i) {
            my $data = {
                'Address' => $permit->{Address},
                'Schedule' => $permit->{Schedule}
            };  
            push(@addresses, $data);
        }
    }

    return \@addresses;
}

1;