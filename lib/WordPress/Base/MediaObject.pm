package WordPress::Base::MediaObject;
use strict;
use vars qw($VERSION @ISA @EXPORT_OK %EXPORT_TAGS);
use Exporter;
@ISA = qw/Exporter/;
$VERSION = sprintf "%d.%02d", q$Revision: 1.2 $ =~ /(\d+)/g;
@EXPORT_OK = qw(get_mime_type get_file_bits get_file_name abs_path_to_media_object_data);
%EXPORT_TAGS = ( 'all' => \@EXPORT_OK );

# optionally we can request other files to get mime on
sub get_mime_type {
   my $abs = shift;
   $abs or confess('missing arg');   
   require File::Type;
   my $ft = new File::Type;
   my $type = $ft->mime_type($abs) or die('missing mime');
   return $type;
}

sub get_file_bits {
   my $abs_path = shift;
   $abs_path or die;
   # from http://search.cpan.org/~gaas/MIME-Base64-3.07/Base64.pm
   require MIME::Base64;

   open(FILE, $abs_path) or die($!);
   my $bits;
   my $buffer;
   while( read(FILE, $buffer, (60*57)) ) {
      $bits.= $buffer;
   }

   return $bits;
}

sub get_file_name {
   my $string = shift;
   $string or croak('missing path');
   
   $string=~s/^.+\/+|\/+$//g;
   return $string;
}


sub abs_path_to_media_object_data {
   my $abs_path = shift;
   $abs_path or croak('missing path arg');

   my $struct ={
       name => get_file_name($abs_path),
       type => get_mime_type($abs_path),
       bits => get_file_bits($abs_path),
   };

   return $struct;
}


1;

__END__

=pod

=head1 NAME

WordPress::Base::MediaObject - create structs to upload media to wordpress

=head1 SYNOPSIS

   use WordPress::Base::MediaObject 'all';
   my $struct = abs_path_to_media_object_data('/home/my/picture.jpg');
   
=head1 DESCRIPTION

This is for dealing with files, slurping, cleaning up text, whatever.
Nothing is exported by default.
This is for use with WordPress::XMLRPC

=head1 SUBS

=head2 abs_path_to_media_object_data()

Arg is abs path, turns into data structure expected as arg to upload with WordPress::XMLRPC methods.
You would normally use a binary file for this.

=head2 get_file_name()

Argument is a path. Returns filename part.

=head2 get_file_bits()

Argument is abs path, returns file bits in MIME::Base64

=head2 get_mime_type()

Argument is abs path, returns mime type

=head1 REQUIREMENTS

File::Type
MIME::Base64

=head1 SEE ALSO

WordPress::XMLRPC

=head1 AUTHOR

Leo Charre leocharre at cpan dot org

=head1 LICENSE

This package is free software; you can redistribute it and/or modify it under the same terms as Perl itself, i.e., under the terms of the "Artistic License" or the "GNU General Public License".

=head1 DISCLAIMER

This package is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the "GNU General Public License" for more details.

=cut
