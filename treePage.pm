package treePage;

use strict;
use base qw(Oak::Web::Page);

sub on_create {
	my $self = shift;
	my $xml = $::SESSION->get('filename');
	my $class = $::SESSION->get('classname');
	eval "require $class" || die $@;
	$self->{obj} = new $class
	  (
	   RESTORE_TOPLEVEL => $xml,
	   IS_DESIGNING => 1
	  );
	my $components = {};
	$components->{"0_0_".$self->{obj}->get('name')} = $self->_parental_tree($self->{obj});
	$self->componentList->set(list => $self->_format_list($components,0));
	return 1;
}

sub _parental_tree {
	my $self = shift;
	my $obj = shift;
	my $hash = {};
	foreach my $c ($self->{obj}->list_childs) {
		my $co = $self->{obj}->get_child($c);
		next if $co->get('parent') ne $obj->get('name');
		$hash->{int($co->get('top'))."_".int($co->get('left'))."_".$c} = $self->_parental_tree($co);
	}
	return $hash;
	
}

sub _format_list {
	my $self = shift;
	my $components = shift;
	my $level = shift;
	my $list = "";
	unless (ref $components eq "HASH") {
		$components = {};
	}
	foreach my $key (sort keys %{$components}) {
		my $item = $key;
		$item =~ s/^(\d*)_(\d*)_//;
		$list .= (" " x $level).$item.'|'.$item." ($1,$2)\n";
		$list .= $self->_format_list($components->{$key},($level+1));
	}
	return $list;
}

sub on_list_click {
	my $self = shift;
	my $itemid = $self->componentList->get('selected_item');
	$::SESSION->set('selectedComponent' => $itemid);
	$::APPLICATION->initiateTopLevel("objectInspector");
	$::TL::objectInspector->show();
}

1;
