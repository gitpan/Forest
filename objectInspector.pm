package objectInspector;

use Error qw(:try);
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
	# Who is the selected component?
	my $other = $self->_get_working_component;
	# Create the options for the component select
	$self->_create_selectComponent_options($self->{obj});
	# Where is the properties?
	$self->_create_properties_tr($other);
	return 1;
}

sub _get_working_component {
	my $self = shift;
	my $comp = $::SESSION->get("selectedComponent");
	unless ($comp) {
		$comp = $self->{obj}->get('name');
		$::SESSION->set("selectedComponent" => $comp);
	}
	$self->get_child("selectComponent")->set('value' => $comp);
	my $other;
	if ($comp eq $self->{obj}->get('name')) {
		$other = $self->{obj};
	} else {
		$other = $self->{obj}->get_child($comp);
	}
	return $other;
}

sub _create_selectComponent_options {
	my $self = shift;
	my $obj = shift;
	my $i = 0;
	require Oak::Web::HTML::Option;
	new Oak::Web::HTML::Option
	  (
	   RESTORE =>
	   {
	    name => "selectComponent_".$obj->get('name'),
	    value => $obj->get('name'),
	    label => $obj->get('name').": ".$obj->get('__CLASSNAME__'),
	    parent => "selectComponent",
	    top => $i,
	    select => "selectComponent"
	   },
	   OWNER => $self
	  );
	foreach my $t (sort $obj->list_childs) {
		$i++;
		my $name = $t;
		my $c = $obj->get_child($name);
		my $cclass = $c->get("__CLASSNAME__");
		$name = "selectComponent_".$name;
		new Oak::Web::HTML::Option
		  (
		   RESTORE =>
		   {
		    name => $name,
		    value => $t,
		    label => $t.": ".$cclass,
		    parent => "selectComponent",
		    top => $i,
		    select => "selectComponent"
		   },
		   OWNER => $self
		  );
	}
	return 1;
}

sub _unload_selectComponent_options {
	my $self = shift;
	my $obj = shift;
	$self->free_child("selectComponent_".$obj->get('name'));
	foreach my $t (sort $obj->list_childs) {
		$self->free_child("selectComponent_".$t);
	}
}

sub _create_properties_tr {
	my $self = shift;
	my $obj = shift;
	my $i = 0;
	foreach my $p (sort $obj->get_property_array) {
		next if $p eq "__CLASSNAME__";
		next if $p eq "__XML_FILENAME__";
		next if $p eq "";
		next if $p eq "1";
		next unless defined $obj->get($p);
		$self->_add_property_tr($p, $obj->get($p), $i);
		$i++;
	}
}

sub _add_property_tr {
	my $self = shift;
	my $p = shift;
	my $value = shift;
	my $i = shift;
	require Oak::Web::HTML::Tr;
	require Oak::Web::HTML::Td;
	require Oak::Web::HTML::Input;
	require Oak::Web::HTML::Label;
	new Oak::Web::HTML::Tr
	  (
	   RESTORE =>
	   {
	    name => "trProperty_".$p,
	    parent => "content",
	    top => $i
	   },
	   OWNER => $self
	  );
	new Oak::Web::HTML::Td
	  (
	   RESTORE =>
	   {
	    name => "tdPropertyName_".$p,
	    parent => "trProperty_".$p,
	    top => 0,
	    left => 0
	   },
	   OWNER => $self
	  );
	new Oak::Web::HTML::Label
	  (
	   RESTORE =>
	   {
	    name => "labelPropertyName_".$p,
	    parent => "tdPropertyName_".$p,
	    for => "inputPropertyName_".$p,
	    caption => $p,
	    top => 0,
	    left => 0
	   },
	   OWNER => $self
	  );
	new Oak::Web::HTML::Td
	  (
	   RESTORE =>
	   {
	    name => "tdPropertyValue_".$p,
	    parent => "trProperty_".$p,
	    top => 0,
	    left => 1
	   },
	   OWNER => $self
	  );
	new Oak::Web::HTML::Input
	  (
	   RESTORE =>
	   {
	    name => "inputPropertyName_".$p,
	    parent => "tdPropertyValue_".$p,
	    type => "text",
	    size => 25,
	    value => $value,
	    top => 0,
	    left => 0
	   },
	   OWNER => $self
	  );
}

sub on_selectComponent_change {
	my $self = shift;
	my $new = $self->get_child("selectComponent")->get('value');
	my $other = $self->_get_working_component;
	$self->_change_properties_tr($other,$new);
	$self->show;
}

sub _change_properties_tr {
	my $self = shift;
	my $old = shift;
	my $new = shift;
	$self->_unload_properties_tr($old);
	$::SESSION->set("selectedComponent" => $new);
	my $other = $self->_get_working_component;
	$self->_create_properties_tr($other);
}

sub _unload_properties_tr {
	my $self = shift;
	my $other = shift;
	foreach my $p (sort $other->get_property_array) {
		next if $p eq "__CLASSNAME__";
		next if $p eq "__XML_FILENAME__";
		next if $p eq "";
		next if $p eq "1";
		try {
			$self->free_child("inputPropertyName_".$p);
			$self->free_child("tdPropertyValue_".$p);
			$self->free_child("labelPropertyName_".$p);
			$self->free_child("tdPropertyName_".$p);
			$self->free_child("trProperty_".$p);
		} catch Oak::Component::Error::NotRegistered with {
			# do nothing
		};
	}
}

sub on_add_property_click {
	my $self = shift;
	my $other = $self->_get_working_component;
	my $p = $self->get_child('input_add_property')->get('value');
	# user can fill this field with
	# name => value, name => value
	my @props = split(/,/,$p);
	foreach my $prop (@props) {
		my ($name, $value) = split(/\s*\=\>\s*/, $prop);
		$name =~ s/^\s+//;
		$name =~ s/\s+$//;
		$value =~ s/^\s+//;
		$value =~ s/\s+$//;
		next if $name eq "name";
		$other->set($name => $value);
	}
	$self->_unload_properties_tr($other);
	$self->_create_properties_tr($other);
	$self->{obj}->store_all;
	$self->get_child('input_add_property')->set('value' => '');
	$self->set('script' => 'parent.previewFrame.location.reload();parent.treeFrame.location.reload();');
	$self->show;
}

sub on_update_click {
	my $self = shift;
	my $other = $self->_get_working_component;
	foreach my $p (sort $other->get_property_array) {
		next if $p eq "__CLASSNAME__";
		next if $p eq "__XML_FILENAME__";
		next if $p eq "";
		next if $p eq "1";
		my $value = $self->get_child("inputPropertyName_".$p)->get('value');
		next if $value eq $other->get($p);
		if ($p eq "name") {
			$other->change_name($value);
		} else {
			$other->set($p => $value);			
		}
	}
	$self->{obj}->store_all;
	$self->set('script' => 'parent.previewFrame.location.reload();parent.treeFrame.location.reload();');
	$self->show;
}


sub _delete_component {
	my $self = shift;
	my $other = shift;
	foreach my $o ($self->{obj}->list_childs) {
		my $obj;
		try {
			$obj = $self->{obj}->get_child($o);
			if ($obj->get('parent') eq $other->get('name')) {
				$self->_delete_component($obj);
			}
		} catch Oak::Component::Error::NotRegistered with {
			# This exception will be thrown because I'm
			# deleting components in a recursive function
			# ------------------------------------------
			# This exception is ignored.
		};
	}
	$self->{obj}->free_child($other->get('name'));
}

sub on_delete_click {
	my $self = shift;
	my $other = $self->_get_working_component;
	my $parent = $other->get('parent') || $self->{obj}->get('name');
	$self->_change_properties_tr($other, $parent);
	$self->_unload_selectComponent_options($self->{obj});
	unless ($other->get('name') eq $self->{obj}->get('name')) {
		$self->_delete_component($other);
	}
	$self->{obj}->store_all;
	$self->_create_selectComponent_options($self->{obj});
	$self->set('script' => 'parent.previewFrame.location.reload();parent.treeFrame.location.reload()');
	$self->show;
}

1;
