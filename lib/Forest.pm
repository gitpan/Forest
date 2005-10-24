package Forest;

our $VERSION = '0.99_01';

1;
__END__

=head1 NAME

Forest - the distribution for L<Tree> and friends

=head1 DESCRIPTION

Forest is the name for a group of related modules that all deal with trees. 

B<NOTE:> This is currently a developer release. The API is nearly-completely
frozen, but we reserve the right to make incompatible changes. When 1.0 is
released, its API I<will> be backwards-compatible.

=head1 CIRCULAR REFERENCES

All the modules in this distribution use L<Scalar::Util>'s C<weaken()> to
avoid circular references. This avoids the problem of circular references in
all cases.

=head1 BUGS

None that we are aware of.

The test suite for Forest is based very heavily on the test suite for
L<Test::Simple>, which has been tested extensively and is used in a number of
major applications/distributions, such as L<Catalyst> and rt.cpan.org.

=head1 TODO

=over 4

=item * Traversals and memory

Need tests for what happens with a traversal list and deleted nodes,
particularly w.r.t. how memory is handled - should traversals weaken?

=item * Added NestedSets has a way of storing trees in a DB

=item * Provide a way of loading the payload from a secondary datastore

=item * Lazyload the children of the loaded tree

=item * Provide a way of defaulting the class if it's not a column in the DB

=item * Allow has_child() and get_index_for() to work with a supplied callback

=back

=head1 NOTES

These are items to consider adding in general.

=over 4

=item * Partial balancing

Creating an AVL search tree

=item * BTree

A special m-ary balanced tree.

=over 4

=item 1 The root either is a leaf or has 2+ children

=item 2 Every node (except root/leaf) has between ceil(m/2) and m children

=item 3 Every path from root to leaf is the same size

=back

=item * 2-3 Tree

A BTree of order 3.

=over 4

=item 1 All nodes have 2 or 3 children

=item 2 The leaves, traversed from left to right, are ordered.

=item 3 Insertion

Locate where it should be and add it. If the parent's children > 3, split it into two nodes with 2 children and add the 2nd to the parent. Continue up to the root, adding a new root, if needed.

=item 4 Deletion

Locate the leaf and remove it. If the parent's children < 2, merge it with an adjacent sibling, removing it from its parent. Continue up to the root, removing the root, if needed.

=back

=item * Red-Black

=over 4

=item 1 Every node has 2 children colored either red or black

=item 2 Every leaf is black

=item 3 Every red node has 2 black children

=item 4 Every path from the root to a leaf contains the same number of black children (called the I<black-height>)

=back

Special case is an AA tree. This requires that right children must always be red. q.v. L<http://en.wikipedia.org/wiki/AA_tree> for more info.

=item * Andersson

q.v. L<http://www.eternallyconfuzzled.com/tuts/andersson.html>

=item * Splay

q.v. L<http://en.wikipedia.org/wiki/Splay_tree>

=item * Scapegoat

q.v. L<http://en.wikipedia.org/wiki/Scapegoat_tree>

=back

=head1 CODE COVERAGE

We use L<Devel::Cover> to test the code coverage of our tests. Below is the
L<Devel::Cover> report on this module's test suite. We use TDD, which is why
our coverage is so high.
 
  ---------------------------- ------ ------ ------ ------ ------ ------ ------
  File                           stmt branch   cond    sub    pod   time  total
  ---------------------------- ------ ------ ------ ------ ------ ------ ------
  blib/lib/Tree.pm              100.0  100.0  100.0  100.0  100.0   58.9  100.0
  blib/lib/Tree/Binary.pm        96.1   95.0  100.0  100.0  100.0    7.1   96.5
  blib/lib/Tree/Fast.pm          99.4   95.5   91.7  100.0  100.0   27.7   98.5
  blib/lib/Tree/Persist.pm      100.0   83.3    n/a  100.0  100.0    1.5   97.6
  .../lib/Tree/Persist/Base.pm  100.0   87.5  100.0  100.0  100.0    1.0   98.1
  blib/lib/Tree/Persist/DB.pm   100.0    n/a    n/a  100.0    n/a    0.1  100.0
  ...ist/DB/SelfReferential.pm  100.0   90.0    n/a  100.0    n/a    2.6   99.1
  .../lib/Tree/Persist/File.pm  100.0   50.0    n/a  100.0    n/a    0.4   96.7
  .../Tree/Persist/File/XML.pm  100.0  100.0  100.0  100.0    n/a    0.8  100.0
  Total                          99.3   94.4   97.7  100.0  100.0  100.0   98.6
  ---------------------------- ------ ------ ------ ------ ------ ------ ------

=head1 AUTHORS

Rob Kinyon E<lt>rob.kinyon@iinteractive.comE<gt>

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

Thanks to Infinity Interactive for generously donating our time.

=head1 COPYRIGHT AND LICENSE

Copyright 2004, 2005 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. 

=cut
