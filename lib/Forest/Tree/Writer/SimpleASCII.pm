package Forest::Tree::Writer::SimpleASCII;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

with 'Forest::Tree::Writer';

sub as_string {
    my ($self) = @_;
    my $out;
    
    $self->tree->traverse(sub {
        my $t = shift;
        $out .= (('    ' x $t->depth) . ($t->node || '\undef') . "\n");
    });
    
    return $out;
}

__PACKAGE__->meta->make_immutable();
no Moose; 1;

__END__

=pod

=head1 NAME

Forest::Tree::Writer::SimpleASCII - A simple ASCII writer for Forest::Tree heirarchies

=head1 DESCRIPTION

This is a simple writer which draws a tree in ASCII.

=head1 METHODS 

=over 4

=item B<as_string>

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
