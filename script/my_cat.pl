#######!/usr/bin/perl

use strict;
use warnings;

my @linelist = '' ;
my @line = '' ;

`cat temp.v  > $ARGV[1] `;

open(FILE,"$ARGV[0]")||die"cannot open the file: $!\n";
while (<FILE>){
     @linelist = split(/\.$ARGV[2]/,$_);
     ##@linelist = $_;
     @line = @linelist[0] ;
     chomp  @line;          
     ##print "file_name is @line;\n";     
     @line = join "","@line",".$ARGV[2]";
     print "file_full_name is @line;\n";
    `cat  "@line"   >> $ARGV[1]` ;
    `cat temp.v  >> $ARGV[1] `
 }
 close FILE;



##print "$randomString\n";
