#!/usr/bin/perl

use strict;
use warnings;

# Check if a file path is provided as a command-line argument
my $file = shift @ARGV;
die "Usage: perl script.pl <file_path>\n" unless defined $file;

# Read the file into an array
open(my $fh, '+<', $file) or die "Failed to open $file: $!";
my @lines = <$fh>;

# Find the first non-empty line
my $first_non_empty_line = 0;
foreach my $index (0 .. $#lines) {
    if ($lines[$index] =~ /\S/) {
        $first_non_empty_line = $index;
        last;
    }
}

truncate($fh, 0) or die "Failed to truncate $file: $!";
seek($fh, 0, 0) or die "Failed to seek to the beginning of $file: $!";
print $fh @lines[$first_non_empty_line .. $#lines];
close($fh);

print "Empty lines removed from the beginning of $file.\n";
