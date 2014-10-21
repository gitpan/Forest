package Forest::Tree::Loader;
use Moose::Role;

our $VERSION   = '0.06';
our $AUTHORITY = 'cpan:STEVAN';

has 'tree' => (
    is      => 'ro',
    isa     => 'Forest::Tree',
    lazy    => 1,
    default => sub { Forest::Tree->new },
);

requires 'load';

sub create_new_subtree { 
    my ($self, %options) = @_;
    my $node = $options{node};
    if (blessed($node) && $node->isa('Forest::Tree')) {
        return $node;
    }
    else {
        return blessed($self->tree)->new(%options);
    }    
}

no Moose::Role; 1;

__END__

=pod

=head1 NAME

Forest::Tree::Loader - An abstract role for loading trees 

=head1 DESCRIPTION

This is an abstract role to be used for loading trees from 

=head1 METHODS 

=over 4

=item B<>

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2008-2009 Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
