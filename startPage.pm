package startPage;

use base qw(Oak::Web::Page);

sub on_create {
	my $self = shift;
	require Oak::Web::HTML::Option;
	my $i = 0;
	foreach my $t ($self->_valid_top_levels) {
		my $name = $t;
		$name =~ s/\://g;
		my $name = "select_new_parent_".$name;
		my $obj = new Oak::Web::HTML::Option
		  (
		   RESTORE =>
		   {
		    name => $name,
		    value => $t,
		    label => $t,
		    parent => "select_new_parent",
		    top => $i,
		    select => "select_new_parent"
		   },
		   OWNER => $self
		  );
		$i++;
	}
	return 1;
}

sub _valid_top_levels {
	qw(
	   Oak::Web::Page
	   Oak::Web::Additional::Included
	   Oak::DataModule
	  );
}

sub _temporaryFileName {
	my $file = "/tmp/forest_".$$."_".$ENV{REMOTE_ADDR}.".xml";
	`touch $file`;
	$::SESSION->set('filename' => $file);
}

sub submit_new_on_click {
	my $self = shift;
	$self->_temporaryFileName;
	my $parent = $self->select_new_parent->get('value');
	$::SESSION->set('selectedComponent' => '');
	$::SESSION->set('classname' => $parent);
	eval "require $parent" || die $@;
	my $obj = $parent->new
	  (
	   RESTORE =>
	   {
	    __XML_FILENAME__ => $::SESSION->get('filename'),
	    name => $self->name_new->get('value')
	   }
	  );
	$obj->store_all;
	$::APPLICATION->initiateTopLevel("actionPage");
	$::TL::actionPage->show;
}

sub submit_edit_on_click {
	my $self = shift;
	$self->_temporaryFileName;
	my $parent = $self->edit_parent->get('value');
	$::SESSION->set('selectedComponent' => '');
	$::SESSION->set('classname' => $parent);
	open(FILE, ">".$::SESSION->get('filename')) || die $!;
	print FILE $self->textarea_file->get('text');
	close FILE;
	$::APPLICATION->initiateTopLevel("actionPage");
	$::TL::actionPage->show;
}

1;
