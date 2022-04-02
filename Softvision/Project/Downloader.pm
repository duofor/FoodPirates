package Softvision::Project::Downloader;

use strict;
use warnings;

use Softvision::Utils::Utils qw(
    remove_duplicates_from_array
);

use WWW::Mechanize;

use constant {
    TEST => 'https://streetviewpixels-pa.googleapis.com/v1/thumbnail?',
    GOOGLE_SEARCH => 'https://www.google.com/search?tbm=map&',
    BASE => 'https://maps.googleapis.com/maps/api/streetview?size=1200x800&location=',
    LOCAL_SAVE_PATH => 'C:\Strawberry\perl\lib\Softvision\Images',
};

sub new {
    my ($class, %args) = @_;

    my $self = bless { %args }, $class;
    $self->_init();

    return $self;
}

sub _init {
    my ($self) = @_;

    $self->{browser} = WWW::Mechanize->new(
        agent_alias => 'Windows Mozilla',
        ssl_opts => { 
            'verify_hostname' => 0 
        }
    );
}

sub download_images_by_address {
    my ($self, $address) = @_;

    my $image_codes = $self->_search_google_maps_by_addr($address);
    $image_codes = remove_duplicates_from_array($image_codes);

    my $image_nr = 0;
    foreach my $image_code (@$image_codes) {
        $image_nr++;
        my $status = $self->_download_image($image_code, $image_nr, $address);
        
        last if $status; # one image is enough so we dont risk a ban from google :D 
    }

    return LOCAL_SAVE_PATH;
}

sub _search_google_maps_by_addr {
    my ($self, $addr) = @_;

    my @address = split(' ', $addr);

    eval {
        sleep(rand(3) + 2);
        $self->{browser}->get(GOOGLE_SEARCH . "pb=" . _get_pb() . "&q=" . join('%20', @address) . "%20");
    };
    die "Cant make google search: $@"
        if $@;
    
    my @panoid = $self->{browser}->content() =~ /street view.*?\[null.*?\d,"(.*?)"\]/ig;

    return \@panoid;
}

sub _download_image {
    my ($self, $image_code, $image_nr, $address) = @_;

    my $local_file = LOCAL_SAVE_PATH . "\\$address - $image_nr.jpeg";

    eval {
        sleep(rand(3) + 2);
        $self->{browser}->get("https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=$image_code&w=408&h=240&yaw=135.54837",
            ':content_file' => $local_file     
        );
    };
    if ($@) {
        # print "Invalid call for $image_code\n"; maybe with a debugger log on, show a message.
        return;
    }

    return 1;
}

sub _get_pb {

    return '!4m12!1m3!1d15387.810327376556!2d-122.40125980195612!3d37.787574035494295!2m3!1f0!2f0!3f0!3m2!1i729!2i937!4f13.' .
    '1!7i20!10b1!12m8!1m1!18b1!2m3!5m1!6e2!20e3!10b1!16b1!19m4!2m3!1i360!2i120!4i8!20m57!2m2!1i203!2i100!3m2!2i10!5b1!6m6!1m' .
    '2!1i86!2i86!1m2!1i408!2i240!7m42!1m3!1e1!2b0!3e3!1m3!1e2!2b1!3e2!1m3!1e2!2b0!3e3!1m3!1e8!2b0!3e3!1m3!1e10!2b0!3e3!1m3!1' .
    'e10!2b1!3e2!1m3!1e9!2b1!3e2!1m3!1e10!2b0!3e3!1m3!1e10!2b1!3e2!1m3!1e10!2b0!3e4!2b1!4b1!9b0!22m6!1s8xlIYvX2HvmS9u8PvrCSw' .
    'A4:2!2zMWk6Myx0OjExODg3LGU6MixwOjh4bElZdlgySHZtUzl1OFB2ckNTd0E0OjI!7e81!12e3!17s8xlIYvX2HvmS9u8PvrCSwA4:104!18e15!24m64!' .
    '1m21!13m8!2b1!3b1!4b1!6i1!8b1!9b1!14b1!20b1!18m11!3b1!4b1!5b1!6b1!9b1!12b1!13b1!14b1!15b1!17b1!20b1!2b1!4b1!5m5!2b1!3b1!5' .
    'b1!6b1!7b1!10m1!8e3!14m1!3b1!17b1!20m2!1e3!1e6!24b1!25b1!26b1!29b1!30m1!2b1!36b1!43b1!52b1!55b1!56m2!1b1!3b1!65m5!3m4!1m' .
    '3!1m2!1i224!2i298!71b1!72m4!1m2!3b1!5b1!4b1!89b1!26m4!2m3!1i80!2i92!4i8!30m28!1m6!1m2!1i0!2i0!2m2!1i458!2i937!1m6!1m2!1i' .
    '679!2i0!2m2!1i729!2i937!1m6!1m2!1i0!2i0!2m2!1i729!2i20!1m6!1m2!1i0!2i917!2m2!1i729!2i937!34m17!2b1!3b1!4b1!6b1!8m5!1b1!3' .
    'b1!4b1!5b1!6b1!9b1!12b1!14b1!20b1!23b1!25b1!26b1!37m1!1e81!42b1!47m0!49m5!3b1!6m1!1b1!7m1!1e3!50m4!2e2!3m2!1b1!3b1!67m2!' .
    '7b1!10b1!69i596';
}

1;