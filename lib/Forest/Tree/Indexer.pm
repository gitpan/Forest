package Forest::Tree::Indexer;
use Moose::Role;
use MooseX::AttributeHelpers;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

has 'tree' => (
    is  => 'rw',
    isa => 'Forest::Tree',
);

has 'index' => (
    metaclass => 'Collection::Hash',
    is        => 'rw',
    isa       => 'HashRef[Forest::Tree]',
    lazy      => 1,
    default   => sub { {} },    
    provides  => {
        'get'   => 'get_tree_at',
        'clear' => 'clear_index',
        'keys'  => 'get_index_keys',
    }
);

requires 'build_index';

sub get_root { (shift)->tree }

1;

__END__

=pod

=head1 NAME

Forest::Tree::Indexer - An abstract role for tree indexers

=head1 DESCRIPTION

This is an abstract role for tree writers.

=head1 ATTRIBUTES

=over 4

=item I<tree>

=item I<index>

=over 4

=item B<get_tree_at ($key)>

=item B<clear_index>

=item B<get_index_keys>

=back

=back

=head1 REQUIRED METHODS 

=over 4

=item B<build_index>

=back

=head1 METHODS 

=over 4

=item B<get_root>

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
