package addComponent;

use strict;
use base qw(Oak::Web::Page);

sub on_create {
	my $self = shift;
	# add the class options
	$self->_add_class_options;
	# add the possible parent components
	$self->_add_possible_parents;
}

sub _add_class_options {
	my $self = shift;
	my @classes = $self->_get_component_classes;
	require Oak::Web::HTML::Option;
	require Oak::Web::HTML::Optgroup;
	my $i = 0;
	my %namespaces = ();
	foreach my $c (sort @classes) {
		my $ns = $c;
		my $cn = $c;
		$ns =~ s/::[^:]+$/::/;
		unless (exists $namespaces{$ns}) {
			new Oak::Web::HTML::Optgroup
			  (
			   RESTORE =>
			   {
			    name => "class_".$ns,
			    parent => "class",
			    label => $ns,
			    top => $i
			   },
			   OWNER => $self
			  );
			$namespaces{$ns} = 1;
		}
		$cn =~ s/^.+::([^:]+)$/$1/;
		new Oak::Web::HTML::Option
		  (
		   RESTORE =>
		   {
		    name => "class_".$c,
		    value => $c,
		    parent => "class_".$ns,
		    select => "class",
		    label => $cn,
		    top => $i
		   },
		   OWNER => $self
		  );
		$i++;
	}
}

sub _get_component_classes {
	qw(
	   Oak::Web::HTML::H1
	   Oak::Web::HTML::H2
	   Oak::Web::HTML::H3
	   Oak::Web::HTML::Label
	   Oak::Web::HTML::H4
	   Oak::Web::HTML::H5
	   Oak::Web::HTML::H6
	   Oak::Web::HTML::Form
	   Oak::Web::HTML::Input
	   Oak::Web::HTML::Span
	   Oak::Web::HTML::Q
	   Oak::Web::HTML::H
	   Oak::Web::HTML::Sub
	   Oak::Web::HTML::Bdo
	   Oak::Web::HTML::Div
	   Oak::Web::HTML::P
	   Oak::Web::HTML::Address
	   Oak::Web::HTML::Em
	   Oak::Web::HTML::Blockquote
	   Oak::Web::HTML::Sup
	   Oak::Web::HTML::PhraseElement
	   Oak::Web::HTML::Small
	   Oak::Web::HTML::I
	   Oak::Web::HTML::Li
	   Oak::Web::HTML::A
	   Oak::Web::HTML::Dfn
	   Oak::Web::HTML::Ul
	   Oak::Web::HTML::Strong
	   Oak::Web::HTML::Br
	   Oak::Web::HTML::Pre
	   Oak::Web::HTML::Code
	   Oak::Web::HTML::Ol
	   Oak::Web::HTML::Samp
	   Oak::Web::HTML::Dt
	   Oak::Web::HTML::Kbd
	   Oak::Web::HTML::Dd
	   Oak::Web::HTML::Var
	   Oak::Web::HTML::Cite
	   Oak::Web::HTML::Dl
	   Oak::Web::HTML::Table
	   Oak::Web::HTML::Abbr
	   Oak::Web::HTML::Acronym
	   Oak::Web::HTML::Tt
	   Oak::Web::HTML::Caption
	   Oak::Web::HTML::Thead
	   Oak::Web::HTML::Colgroup
	   Oak::Web::HTML::B
	   Oak::Web::HTML::Tbody
	   Oak::Web::HTML::Big
	   Oak::Web::HTML::Img
	   Oak::Web::HTML::Style
	   Oak::Web::HTML::Map
	   Oak::Web::HTML::Frame
	   Oak::Web::HTML::Param
	   Oak::Web::HTML::Tfoot
	   Oak::Web::HTML::Object
	   Oak::Web::HTML::Col
	   Oak::Web::HTML::Area
	   Oak::Web::HTML::Link
	   Oak::Web::HTML::Tr
	   Oak::Web::HTML::Hr
	   Oak::Web::HTML::Body
	   Oak::Web::HTML::Td
	   Oak::Web::HTML::Base
	   Oak::Web::HTML::Th
	   Oak::Web::HTML::Select
	   Oak::Web::HTML::Button
	   Oak::Web::HTML::Option
	   Oak::Web::HTML::Optgroup
	   Oak::Web::HTML::Script
	   Oak::Web::HTML::Frameset
	   Oak::Web::HTML::Fieldset
	   Oak::Web::HTML::Textarea
	   Oak::Web::HTML::Legend
	   Oak::Web::HTML::Noframes
	   Oak::Web::HTML::Iframe
	   Oak::Web::HTML::Radiogroup
	   Oak::Web::Additional::Template
	   Oak::Web::Additional::Datefield
	   Oak::Web::Additional::DateTimeField
	   Oak::Web::Additional::ActionFrame
	   Oak::Web::Additional::ActionLink
	   Oak::Web::Additional::ActionLinkList
	   Oak::Web::Additional::Include
	   Oak::Web::Additional::LabeledInput
	   Oak::Web::Additional::SimpleList
	   Oak::Web::Additional::TableList
	   Oak::Web::Additional::UsernameField
	   Oak::Web::Additional::MaskedInput
	   Oak::Web::Additional::PageNavigator
	  );
}

sub _add_possible_parents {
	my $self = shift;
	my $xml = $::SESSION->get('filename');
	my $class = $::SESSION->get('classname');
	eval "require $class" || die $@;
	$self->{obj} = new $class
	  (
	   RESTORE_TOPLEVEL => $xml,
	   IS_DESIGNING => 1
	  );
	$self->_add_parent($self->{obj}->get('name'));
	my $i = shift;
	foreach my $c ($self->{obj}->list_childs) {
		$self->_add_parent($c,$i);
	}
}

sub _add_parent {
	my $self = shift;
	my $name = shift;
	my $order = shift;
	new Oak::Web::HTML::Option
	  (
	   RESTORE =>
	   {
	    name => "parent_".$name,
	    value => $name,
	    parent => "parent",
	    select => "parent",
	    label => $name,
	    top => $order
	   },
	   OWNER => $self
	  );
}

sub on_add_click {
	my $self = shift;
	my $xml = $::SESSION->get('filename');
	my $class = $::SESSION->get('classname');
	eval "require $class" || die $@;
	$self->{obj} = new $class
	  (
	   RESTORE_TOPLEVEL => $xml,
	   IS_DESIGNING => 1
	  );
	my $c = $self->get_child('class')->get('value');
	eval "require $c" || die $@;
	new $c
	  (
	   RESTORE =>
	   {
	    name => $self->get_child('name')->get('value'),
	    parent => $self->get_child('parent')->get('value'),
	    top => $self->get_child('top')->get('value'),
	    left => $self->get_child('left')->get('value')
	   },
	   OWNER => $self->{obj}
	  );
	$self->{obj}->store_all;
	$self->_add_parent($self->get_child('name')->get('value'));
	$self->set('script' => 'parent.objInspFrame.location.href = "?__owa_origin__=objectInspector&selectComponent='.$self->get_child('name')->get('value').'"; parent.previewFrame.location.reload();parent.treeFrame.location.reload();');
	$self->get_child('name')->set('value' => '');
	$self->get_child('class')->set('value' => '');
	$self->get_child('parent')->set('value' => '');
	$self->get_child('top')->set('value' => '');
	$self->get_child('left')->set('value' => '');
	$self->show;
}

sub on_finish_click {
	my $self = shift;
	$::APPLICATION->initiateTopLevel("endPage");
	$::TL::endPage->show;
}

1;
