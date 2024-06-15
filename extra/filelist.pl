#!/usr/bin/env perl

use strict;
use warnings;
use File::Find;

open my $fh, '>', 'verible.filelist'
  or die "Could not open filelist: $!";

sub process_file {
    return unless -f;         # Check if it's a file
    return if $_ =~ /^\./;    # Skip hidden files
    my $full_path = $File::Find::name;
    my ($filename) = $_;
    print "$full_path\n";
    print $fh "$full_path\n";
}

find( \&process_file, './src/rtl' );

close $fh;
